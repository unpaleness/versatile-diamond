module VersatileDiamond
  module Generators
    module Code
      module Algorithm

        # Contains methods for generate cpp expressions which iterates neghbours
        module NeighboursCppExpressions

          # Gets the code which checks relations between current unit and other unit
          # @param [BaseUnit] other to which relations will be checked
          # @param [Hash] rel_params the parameters of cheking relations
          # @yield should return cpp code string which will be implaced into code
          #   condition block
          # @return [String] the code with checking relations between units
          def check_relations(other, rel_params, &block)
            if latticed? && other.latticed?
              check_crystal_relations(other, rel_params, &block)
            else
              check_amorph_relations(other, &block)
            end
          end

        protected

          # Generates code if target atom is latticed
          # @param [BaseUnit] other from which the relations will be checked
          # @param [Hash] rev_rel_params the parameters of relations from self unit to
          #   other unit
          # @yield should return cpp code string for condition body
          # @return [String] the cpp code with expressions of walking through crystal
          #   lattice
          def check_crystal_relations(other, rev_rel_params, &block)
            if single? == other.single?
              each_nbrs_lambda(other, rev_rel_params, &block)
            elsif single?
              one_to_many_condition(other, rev_rel_params, &block)
            else # other.single?
              many_to_one_condition(other, rev_rel_params, &block)
            end
          end

          # Generates code if target atom isn't latticed and other unit isn't multi
          # atomic
          #
          # @param [BaseUnit] other from which the relation will be checked
          # @yield should return cpp code string for condition body
          # @return [String] the cpp code whith checking current amorphous atom
          def check_amorph_relations(other, &block)
            if single?
              raise 'Wrong initial backbone of algorithm' if !other.single?
              amorph_nbr_condition(other, &block)
            else
              raise 'No algorithm implementation for next many amorph atoms case'
            end
          end

          # Generates the code for case when to need to find one atom from several
          # atoms by using the properties of crystal lattice
          #
          # @param [BaseUnit] other the unit neighbour atom which could be achived
          #   through crystal lattice
          # @param [Hash] rel_params the parameters of relations by which the target
          #   neighbour atoms could be achived
          # @yield should return cpp code which will be executed if target atom will
          #   be achived
          # @return [String] the cpp algorithm code
          # TODO: not tested
          def many_to_one_condition(other, rel_params, &block)
            unless target_atom.relations_limits[rel_params] == atoms.size
              raise 'Incorrect getting one atom from many'
            end

            nbr = other.target_atom
            namer.assign_next('neighbour', nbr)
            crystal_call_str = crystal_atom_call(rel_params)
            define_nbr_line = define_var_line('Atom *', nbr, crystal_call_str)

            nbr_var_name = namer.name_of(nbr)
            condition_str = "#{nbr_var_name} && #{other.check_role_condition}"

            with_bond = atoms_with_bond_to(other)
            unless with_bond.empty?
              condition_str = append_check_bond_conditions(condition_str, with_bond)
            end

            define_nbr_line + code_condition(condition_str, &block)
          end

          # Gets a code with checking all crystal neighbours of target atom along
          # relations with same as passed parameters
          #
          # @param [BaseUnit] other the unit with available neighbours of target atom
          # @param [Hash] rel_params the relation parameters through which neighbours
          #   was gotten
          # @yield should return cpp code string for condition body
          # @return [String] the string with cpp code
          def one_to_many_condition(other, rel_params, &block)
            nbrs = other.atoms
            unless target_atom.relations_limits[rel_params] == nbrs.size
              raise 'Incorrect getting many atoms from one'
            end

            namer.assign_next('neighbour', nbrs)
            crystal_call_str = crystal_nbrs_call(rel_params)
            define_nbrs_line = define_var_line('auto', nbrs, crystal_call_str)

            nbrs_var_name = namer.name_of(nbrs)
            condition_str = "#{nbrs_var_name}.all() && #{other.check_role_condition}"

            with_bond = target_atom_with_bond_to(other)
            unless with_bond.empty?
              condition_str = append_check_bond_conditions(condition_str, with_bond)
            end

            define_nbrs_line + code_condition(condition_str, &block)
          end

          # Gets a code with checking amorph neighbour of target atom
          # @param [BaseUnit] other unit with amorph atom which is achivable from
          #   current target atom
          # @yield should return cpp code string for condition body
          # @return [String] the string with cpp code
          def amorph_nbr_condition(other, &block)
            nbr = other.target_atom
            if namer.name_of(nbr)
              condition_str = check_bond_call(target_atom, nbr)
              code_condition(condition_str, &block)
            else
              namer.assign_next('amorph', nbr)
              amorph_nbr_call = "#{target_atom_var_name}->amorphNeighbour()"
              define_nbr_line = define_var_line('Atom *', nbr, amorph_nbr_call)
              condition_str = other.check_role_condition
              define_nbr_line + code_condition(condition_str, &block)
            end
          end

          # Gets a code which uses eachNeighbour method of engine framework and checks
          # role of iterated neighbour atoms
          #
          # @param [BaseUnit] other the unit with neighbour atoms to which iteration
          #   will do
          # @param [Hash] rel_params the relation parameters through which neighbours
          #   was gotten
          # @yield should return cpp code string of lambda body
          # @return [String] the string with cpp code
          def each_nbrs_lambda(other, rel_params, &block)
            nbrs = other.atoms
            raise 'Incorrect number of neighbour atoms' unless nbrs.size == atoms.size

            defined_nbrs_with_names = nbrs.map { |nbr| [nbr, namer.name_of(nbr)] }
            defined_nbrs_with_names.select!(&:last)
            namer.erase(nbrs)

            each_nbrs_lambda_call(nbrs, rel_params) do
              condition_str =
                if defined_nbrs_with_names.empty?
                  other.check_role_condition
                else
                  check_new_names(other, Hash[defined_nbrs_with_names])
                end

              condition_str = append_check_other_relations(condition_str, other)
              code_condition(condition_str) do
                another_same_atoms_condition(other, &block)
              end
            end
          end

          # Checks that atom has a bond like the passed
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   atom which relations in current specie will be checked
          # @param [Concepts::Bond] bond which existance will be checked
          # @return [Boolean] is atom uses bond in current specie or not
          def use_bond?(atom, bond)
            dept_spec_for(atom).relations_of(atom).any? { |r| r == bond }
          end

          # Checks that other unit has an atom which also available by passed relation
          # and if is truthy then returns linked atom
          #
          # @param [BaseUnit] other unit for which the atom second will be checked
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   own_atom the atom of current unit for which the relations will be checked
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   other_atom the atom from other unit which uses for comparing original
          #   species
          # @param [Concepts::Bond] relation which existance will be checked
          # @return [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   the atom which same as last of passed atoms and available by relation
          def same_linked_atom(other, own_atom, other_atom, relation)
            !same_specs?(other, own_atom, other_atom) &&
              position_with(own_atom, relation)
          end

          # Gets the cpp code string with comparison the passed atoms
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   linked_atom the atom from target specie which will be compared
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   own_atom the atom of current unit by which the specie will be gottne
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   neighbour_atom the atom from another specie which will be compared
          # @return [String] the cpp code string with comparison the passed atoms
          #   between each other
          def not_own_atom_condition(linked_atom, own_atom, neighbour_atom)
            specie = uniq_specie_for(own_atom)
            specie_call = atom_from_specie_call(specie, linked_atom)
            neighbour_atom_var_name = namer.name_of(neighbour_atom)
            "#{neighbour_atom_var_name} != #{specie_call}"
          end

        private

          # Defines anchor atoms for get neighbour atoms and call eachNeighbour method
          # @param [Array] nbrs the neighbour atoms from which the iteration will do
          # @param [Hash] rel_params the relation parameters through which neighbours
          #   was gotten
          # @yield should return cpp code string of lambda body
          # @return [String] the string with cpp code
          def each_nbrs_lambda_call(nbrs, rel_params, &block)
            define_nbrs_specie_anchors_lines +
              code_lambda(*each_nbrs_args(nbrs, rel_params), &block)
          end

          # Gets the arguments for #each_nbrs_lambda internal call
          # @param [Array] nbrs the neighbour atoms from which the iteration will do
          # @param [Hash] rel_params the relation parameters through which neighbours
          #   was gotten
          # @return [Array] the array of arguments for each neighbours operation
          def each_nbrs_args(nbrs, rel_params)
            namer.assign_next('neighbour', nbrs)

            method_args = [namer.name_of(atoms), full_relation_name_ref(rel_params)]
            clojure_args = ['&']

            nbrs_var_name = namer.name_of(nbrs)
            method_name = 'eachNeighbour'
            if single?
              lambda_arg = "Atom *#{nbrs_var_name}"
            else
              method_name = "#{method_name}s<#{atoms.size}>"
              lambda_arg = "Atom **#{nbrs_var_name}"
            end

            [method_name, method_args, clojure_args, [lambda_arg]]
          end

          # Gets the conditions where new names of neighbour atoms compares with old
          # names
          #
          # @param [BaseUnit] other unit from which the neighbour atoms will be gotten
          # @param [Hash] nbrs_with_old_names the mirror of neighbour atoms to old
          #   names
          # @return [String] the code string which could be used in condition expr
          def check_new_names(other, nbrs_with_old_names)
            nbrs = other.atoms
            zipped_names = nbrs.map { |a| [nbrs_with_old_names[a], namer.name_of(a)] }
            comp_strs = atoms.zip(nbrs).zip(zipped_names).map do |ats, nms|
              uwas = append_units(other, [ats])
              op = relation_between(*uwas.first) ? '==' : '!='
              nms.join(" #{op} ")
            end
            comp_strs.join(' && ')
          end

          # Gets the code which calls the atom of crystal by calculating coordinates
          # @param [Hash] rel_params the parameters of relations by which the coords
          #   of target atom will be calculated from own atom instances
          # @return [String] the string with cpp code for getting the atom of crystal
          def crystal_atom_call(rel_params)
            frn_method_name = "#{full_relation_name(rel_params)}_at"
            atoms_vars_names_str = atoms.map { |a| namer.name_of(a) }.join(', ')
            "#{crystal_call}->atom(#{frn_method_name}(#{atoms_vars_names_str}))"
          end

          # Gets the code which calls the method of crystal which gets neighbours of
          # target atom
          #
          # @param [Hash] rel_params the relations parameters by which the neighbour
          #   atoms will be gotten
          # @return [String] the string wich cpp code
          def crystal_nbrs_call(rel_params)
            srn_method_name = short_relation_name(rel_params)
            "#{crystal_call}->#{srn_method_name}(#{target_atom_var_name})"
          end

          # Gets the list of atoms pairs between which has a relation, where the first
          # item of pair is atom of current node and the second item is passed atom
          # @param [BaseUnit] other the unit with neighbour atom the bond from which to
          #   each internal atom will be checked
          # @return [Array] the list of pairs of bonded atoms with units
          def atoms_with_bond_to(other)
            select_bonded(other, atoms.zip([other.target_atom] * atoms.size))
          end

          # Selects neighbour atoms which have bond with target atom
          # @param [BaseUnit] other unit with the cheking neighbour atoms
          # @return [Array] the list of pairs where bond has between each pair
          def target_atom_with_bond_to(other)
            nbrs = other.atoms
            select_bonded(other, ([target_atom] * nbrs.size).zip(nbrs))
          end

          # Appends the correspond units to each atom from each pair and selects pairs
          # with correspond bonded atoms
          #
          # @param [Array] pairs the list of atom pairs from which the each pair will
          #   be checked that atoms from it is bonded
          # @return [Array] the list of pairs where each item is array of two elements
          #   where the first item is unit and the second item is atom of it
          def select_bonded(other, pairs)
            append_units(other, pairs).select(&method(:check_bond))
          end

          # Selects pairs which has bond between each other
          # @param [Array] pair of two atoms between which the relation will be checked
          # @return [Array] the list of pairs where between each two atoms has a bond
          def check_bond(pair)
            rel = relation_between(*pair)
            rel && rel.bond?
          end

          # Appends unit to each atom of each pair
          # @param [BaseUnit] other unit which appended to eacn second atom
          # @param [Array] pairs of atoms to each pair of which the units will be
          #   appended
          # @return [Array] the array of pairs where each pair is unit with atom
          def append_units(other, pairs)
            pairs.map { |f, t| [[self, f], [other, t]] }
          end

          # Makes code string with checking bond between passed atoms
          # @param [Array] atoms the array with two atoms between which the bond will
          #   be checked
          # @return [String] code with calling check bond function
          def check_bond_call(*atoms)
            first_var, second_var = atoms.map { |atom| namer.name_of(atom) }
            "#{first_var}->hasBondWith(#{second_var})"
          end

          # Gets the short name of relation for get neighbour atoms
          # @param [Hash] rel_params the relation parameters by which short name will
          #   be gotten
          # @return [String] the short name of relation
          def short_relation_name(rel_params)
            "#{rel_params[:dir]}_#{rel_params[:face]}"
          end

          # Gets the full name of relation by atom and relation parameters
          # @param [Hash] rel_params the relation parameters by which full name will be
          #   gotten
          # @return [String] the full name relation
          def full_relation_name(rel_params)
            lattice_code = generator.lattice_class(target_atom.lattice)
            lattice_class_name = lattice_code.class_name
            short_name = short_relation_name(rel_params)
            "#{lattice_class_name}::#{short_name}"
          end

          # Gets the reference to correspond crystal method of engine framework
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   atom see at #full_relation_name same argument
          # @param [Hash] rel_params see at #full_relation_name same argument
          # @return [String] the reference to relation method
          def full_relation_name_ref(rel_params)
            "&#{full_relation_name(rel_params)}"
          end

          # Gets the cpp code which uses #crystalBy engine framework method for get a
          # crystal by atom
          #
          # @return [String] the string with cpp call
          def crystal_call
            "crystalBy(#{namer.name_of(target_atom)})"
          end

          # Appends other unit
          # @param [BaseUnit] other unit which will be appended
          # @return [Array] the appending reault
          def append_other(other)
            append_units(other, atoms.zip(other.atoms))
          end

          # Gets condition where checks that some atoms of current unit is not same as
          # atoms in other unit
          #
          # @param [BaseUnit] other unit with which atoms comparing will do
          # @yield should returns the internal code for body of condition
          # @return [String] cpp code string with condition if it need
          def another_same_atoms_condition(other, &block)
            parts = reduce_if_relation(append_other(other)) do |acc, usp, asp, rel|
              cur, oth = usp
              linked_atom = cur.same_linked_atom(oth, *asp, rel)
              if linked_atom
                acc << cur.not_own_atom_condition(linked_atom, *asp)
              end
            end

            parts.empty? ? block.call : code_condition(parts.join(' && '), &block)
          end

          # Appends condition of checking relations to atoms of other unit from current
          # @param [String] condition_str the string which will be extended by
          #   additional condition
          # @param [BaseUnit] other the unit to atoms of which the relations will be
          #   checked
          # @return [String] the extended condition
          def append_check_other_relations(condition_str, other)
            append_check_bond_conditions(condition_str, append_other(other))
          end

          # Appends condition of checking bond exsistance between each atoms in passed
          # pairs array
          #
          # @param [String] original_condition to which new conditions will be appended
          # @param [Array] units_with_atoms is the pairs of atoms between which the
          #   bond existatnce will be checked
          # @return [String] the extended condition
          def append_check_bond_conditions(original_condition, units_with_atoms)
            parts = reduce_if_relation(units_with_atoms) do |acc, usp, asp, relation|
              cb_call = check_bond_call(*asp)
              if relation.bond?
                acc << cb_call
              elsif any_uses_bond?(usp.zip(asp), relation.params)
                acc << "!#{cb_call}"
              end
            end

            ([original_condition] + parts).join(' && ')
          end

          # Iterates each real pair of atoms if relation between them is set
          # @param [Array] units_with_atoms is the pairs of atoms between which the
          #   relation existatnce will be checked
          # @yield [Array, Array, Array, Concepts::Bond] do for each correct pair;
          #   the first argument of block is accumulator variable
          # @return [Array] the accumulation result
          def reduce_if_relation(units_with_atoms, &block)
            units_with_atoms.each_with_object([]) do |pairs, acc|
              relation = relation_between(*pairs)
              block[acc, *pairs.transpose, relation] if relation
            end
          end

          # Checks that any atom from each pair are used passed relation
          # @param [Array] pairs the array with two elements where each item is pair of
          #   unit and atom of it
          # @param [Hash] rel_params by which the using bond will checked
          # @return [Boolean] are any atom use bond or not
          def any_uses_bond?(pairs, rel_params)
            _, atoms_pair = pairs.transpose
            pairs.permutation.any? do |prs|
              us, as = prs.transpose
              al, bl = as.map(&:lattice)
              bond = Concepts::Bond[rel_params]
              bond = al.opposite_relation(bl, bond) unless as == atoms_pair
              us.first.use_bond?(as.first, bond)
            end
          end

          # hecks the atom linked with passed atom by passed position
          # @param [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   atom from which the linked atom will be checked
          # @param [Concepts::Bond] position by which the linked atom will be checked
          # @return [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   the atom which linked with passed atom by passed position or nil
          def position_with(atom, position)
            dept_spec = dept_spec_for(atom)
            awr = dept_spec.relations_of(atom, with_atoms: true).find do |_, r|
              r == position
            end

            awr && awr.first
          end
        end

      end
    end
  end
end
