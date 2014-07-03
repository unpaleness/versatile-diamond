module VersatileDiamond
  module Generators
    module Formula

      module Stereo

        # Converts decart coordinates x, y, z to spherical ro, phi, etha respectively
        # @return [Float, Float, Float]
        def dec_to_sph(x, y, z)
          ro = Math.sqrt(x*x + y*y + z*z)
          phi = Math.asin(y / Math.sqrt(x*x + y*y))
          (y > 0.0 ? (phi = Math::PI - phi) : (phi = - Math::PI - phi)) if x < 0.0
          etha = Math.asin(z / ro)
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
