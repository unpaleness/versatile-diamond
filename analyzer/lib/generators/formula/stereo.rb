module VersatileDiamond
  module Generators
    module Formula

      # Provides unlimited opportunities for affine transformations
      # Well, almost unlimited.
      # To tell the truth there are few methods. =)
      module Stereo

        extend Math

        # Rotates a point relating point (0; 0; 0)
        # @param [Float, Float, Float, Float, Float, Float]
        # - z, y, x - initial coordinates
        # - psi, etha, phi - angles of rotating by axises
        # Oz, Oy and Ox respectively
        # @return [Float, Float, Float] - z, y, x - resulting coordinates
        def self.rotate(z, y, x, psi, etha, phi)
          # Oz
          z, y, x = z, y * cos(psi) + x * sin(psi), - y * sin(psi) + x * cos(psi)
          # Oy
          z, y, x = z * cos(etha) - x * sin(etha), y, z * sin(etha) + x * cos(etha)
          # Ox
          z, y, x = z * cos(phi) + y * sin(phi), - z * sin(phi) + y * cos(phi), x
          [z, y, x]
        end
      end

    end
  end
end
