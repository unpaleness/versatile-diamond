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

        # Moves atom on values dx, dy, dz
        def move_on_dec(dx, dy, dz)
          @x += dx
          @y += dy
          @z += dz
        end

        # Moves atom on values dro, dphi, detha
        def move_on_sph(dro, dphi, detha)
          ro, phi, etha = *Stereo::dec_to_sph(@x, @y, @z)
          @x, @y, @z = *Stereo::sph_to_dec(ro + dro, phi + dphi, etha + detha)
        end
      end

    end
  end
end
