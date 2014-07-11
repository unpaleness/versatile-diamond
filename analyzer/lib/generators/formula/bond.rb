module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Bond' for Formula.
      class Bond

        # Opens 1-st and 2-nd atoms and bond for reading
        attr_reader :atom_begin, :atom_end, :bond
        # Opens access to 'order'
        attr_accessor :order

        # Initializer
        # 'order' - order of the bond
        def initialize(atom_begin, atom_end, bond)
          @atom_begin = atom_begin
          @atom_end = atom_end
          @bond = bond
          # initial order is always 1
          @order = 1
        end

        # Shows that our bond is really bond. Not just a relation!!!
        # @return [Boolean]
        def is_bond?
          return true if "#{@bond.class}" == 'VersatileDiamond::Concepts::Bond'
          false
        end

        # Returns a string with detailed information about current bond
        # @return [String]
        def to_s
          "from: #{@atom_begin.id}, to: #{@atom_end.id}, order = #{order}, "\
            "face: #{@bond.face}, dir: #{@bond.dir}, is bond? - #{is_bond?}"
        end
      end

    end
  end
end
