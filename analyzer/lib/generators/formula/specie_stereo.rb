module VersatileDiamond
  module Generators
    module Formula

      # Takes responsibility for all geometry of specie
      class SpecieStereo

        SIZE_MULTI = 10e11
        BOND_UNDIRECTED = 1.7e-10

        # @param [Specie] current specie
        def initialize(specie)
          @specie = specie
          centering
          rotate(Math::PI / 8, 0.0, Math::PI / 3)
          @z_max, @z_min, @y_max, @y_min, @x_max, @x_min = *measures
        end

        # Provides conersion from angstrem to pixels
        # @param [Float] some value in angstrems
        def self.to_p(figure)
          figure * SIZE_MULTI
        end

        # Provides information about y measure of specie
        # @return [Float] y-size
        def y_size
          @y_max - @y_min
        end

        # Provides information about x measure of specie
        # @return [Float] x-size
        def x_size
          @x_max - @x_min
        end

        # Locates center of the spec
        # @return [Float, Float, Float] coordinates of spec's center
        def center
          z = y = x = 0.0
          @specie.atoms.each do |key, atom|
            z, y, x = z + atom.z, y + atom.y, x + atom.x
          end
          amount = @specie.atoms.size
          [z / amount, y / amount, x / amount]
        end

        # Moves center and other atom in the way where center should be (0; 0; 0)
        def centering
          dz, dy, dx = center
          @specie.atoms.each do |key, atom|
            atom.z -= dz
            atom.y -= dy
            atom.x -= dx
          end
        end

        # Counts 3-dimentional measures of the specie
        # @return [Float, Float, Float] z-size, y-size, x-size
        def measures
          z_max = z_min = y_max = y_min = x_max = x_min = 0.0
          @specie.atoms.each do |key, atom|
            z_max = atom.z if atom.z > z_max
            z_min = atom.z if atom.z < z_min
            y_max = atom.y if atom.y > y_max
            y_min = atom.y if atom.y < y_min
            x_max = atom.x if atom.x > x_max
            x_min = atom.x if atom.x < x_min
          end
          [z_max, z_min, y_max, y_min, x_max, x_min]
        end

        # Rotates the spec on some degree by axises: Oz, Oy and Ox
        # @param [Float, Float ,Float] angles psi, etha, phi
        def rotate(psi, etha, phi)
          @specie.atoms.each do |key, atom|
            atom.z, atom.y, atom.x =
              *Stereo::rotate(atom.z, atom.y, atom.x, psi, etha, phi)
          end
        end
      end

    end
  end
end
