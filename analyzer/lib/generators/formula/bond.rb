module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Bond' for Formula.
      class Bond

        # Opens 1-st and 2-nd atoms and description for reading
        attr_reader :id_atom_begin, :id_atom_end, :description
        # Opens access to 'order'
        attr_accessor :order

        # Initializer
        # 'order' - order of the bond
        def initialize(id_atom_begin, id_atom_end, description)
          @id_atom_begin = id_atom_begin
          @id_atom_end = id_atom_end
          @description = description
          # initial order is always 1
          @order = 1
        end

      end

    end
  end
end
