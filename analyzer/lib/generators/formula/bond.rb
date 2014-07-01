module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Bond' for Formula.
      class Bond

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

        # Returns link to 'id_atom_begin'
        def id_atom_begin
          @id_atom_begin
        end

        # Returns link to 'id_atom_end'
        def id_atom_end
          @id_atom_end
        end

      end

    end
  end
end
