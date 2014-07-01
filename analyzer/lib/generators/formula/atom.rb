module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Atom' for Formula. Contains !relative! coordinates in volume
      class Atom

        attr_reader :atom, :id
        attr_accessor :x, :y, :z

        # Initializer
        # 'atom' is a reference to atoms defined for current spec by Gleb
        # firstly all coordinates are 0
        def initialize(atom)
          @x = @y = @z = 0
          @atom = atom
          @id = get_atom.object_id
        end

        # Returns symbolic illustration of current atom
        def name
          @atom.name
        end

        # Returns reference to atom used in 'spec.links'
        def get_atom
          @atom
        end
      end

    end
  end
end
