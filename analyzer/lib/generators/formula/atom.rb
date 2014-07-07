module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Atom' for Formula. Contains !relative! coordinates in volume
      class Atom

        include Stereo

        attr_reader :atom, :id
        attr_accessor :x, :y, :z, :bonds

        # Initializer
        # 'atom' is a reference to atoms defined for current spec by Gleb
        # firstly all coordinates are 0
        def initialize(atom)
          @x = @y = @z = 0
          @atom = atom
          @id = @atom.object_id
          @bonds = {}
        end

        # Returns symbolic illustration of current atom
        def name
          @atom.name
        end

        # Moves atom on values dx, dy, dz
        def move_on_dec(dx, dy, dz)
          @x += dx
          @y += dy
          @z += dz
        end

        # Moves atom on values dro, dphi, detha
        def move_on_sph(dro, dphi, detha)
          ro, phi, etha = dec_to_sph(@x, @y, @z)
          @x, @y, @z = sph_to_dec(ro + dro, phi + dphi, etha + detha)
          [@x, @y, @z]
        end

        # Rotate relative to the point (x; y; z)
        def rotate(x, y, z, dphi, detha)

        end
      end

    end
  end
end
