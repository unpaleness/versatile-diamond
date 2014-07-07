module VersatileDiamond
  module Generators
    module Formula

      module Stereo

        # Converts decart coordinates x, y, z to spherical ro, phi, etha respectively
        # @return [Float, Float, Float]
        def dec_to_sph(x, y, z)
          ro = Math.sqrt(x*x + y*y + z*z)
          ro_xy = Math.sqrt(x*x + y*y)
          ro_xy != 0 ? phi = Math.asin(y / ro_xy) : phi = 0.0
          (y > 0.0 ? (phi = Math::PI - phi) : (phi = - Math::PI - phi)) if x < 0.0
          ro != 0 ? etha = Math.asin(z / ro) : etha = 0.0
          [ro, phi, etha]
        end

        # Converts spherical coordinates ro, phi, etha to decart x, y, z respectively
        # @return [Float, Float, Float]
        def sph_to_dec(ro, phi, etha)
          x = ro * Math::cos(phi) * Math::cos(etha)
          y = ro * Math::sin(phi) * Math::cos(etha)
          z = ro * Math::sin(etha)
          [x, y, z]
        end
      end

    end
  end
end
