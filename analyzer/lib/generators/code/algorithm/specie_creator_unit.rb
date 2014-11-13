module VersatileDiamond
  module Generators
    module Code
      module Algorithm

        # The instance of class could defines all neccessary variables and calls
        # engine framework method for create a specie which was found
        class SpecieCreatorUnit < BaseCreatorUnit
          include MultiParentSpeciesCppExpressions
          extend Forwardable

          # Gets the code lines for specie creation
          # @return [String] the lines by which the specie will be created
          def lines
            additional_lines = ''
            creation_args = []

            if spec.source?
              additional_lines << define_atoms_variable_line
              creation_args << namer.name_of(sequence.short)
            else
              additional_lines << define_additional_atoms_variable_line if delta > 1
              creation_args << namer.name_of(sequence.addition_atoms) if delta > 0

              additional_lines << define_parents_variable_line if spec.complex?
              creation_args << namer.name_of(parent_species)
            end

            args_str = creation_args.join(', ')
            additional_lines +
              code_line("create<#{original_specie.class_name}>(#{args_str});")
          end

          def inspect
            "SCU:(#{original_specie.inspect})"
          end

        private

          def_delegators :original_specie, :spec, :sequence
          def_delegator :sequence, :delta

          alias :original_specie :original_target
          alias :parent_species :defined_species

          # Finds atom that has twin in passed parent
          # @param [UniqueSpecie] parent for which atom will be found
          # @return [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   atom the twin that belongs to passed parent
          def atom_of(parent)
            spec.anchors.find { |a| namer.name_of(a) && twin_by(parent, a) }
          end

          # Selects correspond twin atom
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   atom the twin that belongs to passed parent
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   the twin that correspond to passed atom in parent specie
          def twin_by(parent, atom)
            (pwt = parent_with_twin_for(atom) { |pr, _| pr == parent }) && pwt.last
          end

          # Makes code which gets parent specie instance from passed atom
          # @param [UniqueSpecie] parent which simulation instance will be gotten
          # @return [String] the string of cpp code with specByRole call
          # @override
          def spec_by_role_call(parent)
            atom = atom_of(parent)
            twin = twin_by(parent, atom)
            super(atom, parent, twin)
          end

          # Gets a code with defining parents variable for creating complex specie
          # when simulation do
          #
          # @return [String] the string with defined parents variable
          def define_parents_variable_line
            items = parent_species.map do |parent|
              namer.name_of(parent) || spec_by_role_call(parent)
            end

            namer.reassign('parent', parent_species)
            define_var_line('ParentSpec *', parent_species, items)
          end

          # Gets a code string with defining atoms variable for creating source specie
          # when simulation do
          #
          # @return [String] the string with defined atoms variable
          def define_atoms_variable_line
            redefine_vars_line('Atom', 'atom', sequence.short)
          end

          # Gets cpp code string with defining additional atoms variable
          # @return [String] the string with defining additional atoms variable
          def define_additional_atoms_variable_line
            redefine_vars_line('Atom', 'additionalAtom', sequence.addition_atoms)
          end

          # Gets a code string with defined variable
          # @param [String] type of defining variable
          # @param [String] single_name which will be passed to namer for assign name
          #   to array of passed atoms
          # @param [Array] atoms which will be defined
          # @return [String] the string with defined atoms variable
          def redefine_vars_line(type, single_name, vars)
            names = vars.map { |a| namer.name_of(a) }
            namer.reassign(single_name, vars)
            define_var_line("#{type} *", vars, names)
          end
        end

      end
    end
  end
end
