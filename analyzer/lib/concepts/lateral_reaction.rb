module VersatileDiamond
  module Concepts

    # Describes reaction which has a some environment expresed by there objects
    class LateralReaction < Reaction

      attr_reader :theres

      # Among super, keeps the atom map
      # @param [Array] super_args the arguments of super method
      # @param [Array] theres the array of there objects
      def initialize(*super_args, theres)
        super(*super_args)
        @theres = theres
      end

      # Also checks using in there objects
      # @param [Spec | SpecificSpec] spec the one of reactant
      # @return [Array] the array of using atoms
      def used_atoms_of(spec)
        (super + theres.flat_map { |there| there.used_atoms_of(spec) }).uniq
      end

      # Also compare there objects
      # @param [UbiqutousReaction] other see at #super same argument
      # @return [Boolean] the same or not
      # @override
      def same?(other)
        self.class == other.class ? all_same?(other) : false
      end

      # Checks that current reaction covered by other reaction
      # @param [LateralReaction] other the comparable reaction
      # @return [Boolean] covered or not
      def cover?(other)
        super_same?(other) && theres.all? do |there|
          other.theres.any? { |t| there.same?(t) || there.cover?(t) }
        end
      end

      def to_s
        lateral_strs = theres.map(&:to_s)
        "#{super} : #{lateral_strs.join(' + ')}"
      end

    private

      # Also reverse there objects
      # @override
      def reverse_params
        reversed_theres = theres.map do |there|
          reversed_positions = {}
          there.positions.each do |spec_atom, links|
            spec, atom = @mapping.other_side(*spec_atom)
            if atom.lattice
              reversed_positions[[spec, atom]] = links
            else
              os, oa = spec_atom # original spec and original atom
              # for each spec of environment
              links.each do |(ws, wa), _|
                # finds another position between latticed atom of original
                # spec and atom of environment spec
                os.links[oa].each do |na, nl|
                  next unless na.lattice
                  rsa = @mapping.other_side(os, na)
                  next unless rsa[1].lattice
                  # skip atom if it already used for connecting environment
                  next if there.positions[[os, na]] || reversed_positions[rsa]

                  sana = ws.links[wa].find { |_, wl| wl == nl }.first
                  rel = ws.links[sana].find { |a, _| a == wa }.last

                  reversed_positions[rsa] ||= []
                  reversed_positions[rsa] << [[ws, wa], rel.make_position]
                  break
                end
              end
            end
          end
          There.new(there.where, reversed_positions)
        end

        [*super, reversed_theres]
      end

      # Calls the #same? method from superclass
      # @param [LateralReaction] other the comparable lateral reaction
      # @return [Boolean] same by super or not
      def super_same?(other)
        self.class.superclass.instance_method(:same?).bind(self).call(other)
      end

      # Are another reaction completely same
      # @param [LateralReaction] other with which comparison
      # @return [Boolean] is reaction initially similar, and all theres are same
      def all_same?(other)
        super_same?(other) && lists_are_identical?(theres, other.theres, &:same?)
      end

      # Also swaps target atoms for all used there objects
      # @param [SpecificSpec] spec see at #super same argument
      # @param [Atom] from see at #super same argument
      # @param [Atom] to see at #super same argument
      # @override
      def swap_atom_in_positions(spec, from, to)
        super
        theres.each { |there| there.swap_target_atom(spec, from, to) } if from != to
      end
    end

  end
end
