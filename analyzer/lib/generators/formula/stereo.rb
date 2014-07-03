module VersatileDiamond
  module Generators
    module Formula

      # Converts decart coordinates x, y, z to spherical ro, phi, etha respectively
      # @return [Float, Float, Float]
      def dec_to_sph(x, y, z)
        ro = Math.sqrt(x*x + y*y + z*z)
        y > 0 ? phi = 0 : phi = Math::PI
        phi += Math.atan(y / x)
        z > 0 ? etha = 0 : etha = Math::PI
        etha += Math.atan(z / Math.sqrt(x*x + y*y))
        [ro, phi, etha]
      end

      # Converts spherical coordinates ro, phi, etha to decart x, y, z respectively
      # @return [Float, Float, Float]
      def sph_to_dec(ro, phi, etha)
        
        [x, y, z]
      end

    end
  end
end
