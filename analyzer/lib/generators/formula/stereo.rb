module VersatileDiamond
  module Generators
    module Formula

      # Provides unlimited opportunities for affine transformations
      # Well, almost unlimited.
      # To tell the truth there are few methods. =)
      module Stereo

        extend Math

        # Rotates a point relating O(0; 0; 0) around axis Oz
        # @param [Float] z
        # @param [Float] y
        # @param [Float] x
        # @param [Float] angle to rotate
        # @return [Float, Float, Float] new values of z, y, x
        def self.rotateOz(z, y, x, phi)
          z, y, x = z, y * cos(phi) + x * sin(phi), - y * sin(phi) + x * cos(phi)
          # puts "Rotated around Oz", [z, y, x]
          # [z, y, x]
        end

        # Rotates a point relating O(0; 0; 0) around axis Oy
        # @param [Float] z
        # @param [Float] y
        # @param [Float] x
        # @param [Float] angle to rotate
        # @return [Float, Float, Float] new values of z, y, x
        def self.rotateOy(z, y, x, etha)
          z, y, x = z * cos(etha) - x * sin(etha), y, z * sin(etha) + x * cos(etha)
          # puts "Rotated around Oy", [z, y, x]
          # [z, y, x]
        end

        # Rotates a point relating O(0; 0; 0) around axis Ox
        # @param [Float] z
        # @param [Float] y
        # @param [Float] x
        # @param [Float] angle to rotate
        # @return [Float, Float, Float] new values of z, y, x
        def self.rotateOx(z, y, x, psi)
          z, y, x = z * cos(psi) + y * sin(psi), - z * sin(psi) + y * cos(psi), x
          # puts "Rotated around Ox", [z, y, x]
          # [z, y, x]
        end

        # Rotates a point relating O(0; 0; 0) around all axises
        # @param [Float] z
        # @param [Float] y
        # @param [Float] x
        # @param [Float] angle to rotate around Oz
        # @param [Float] angle to rotate around Oy
        # @param [Float] angle to rotate around Ox
        # @return [Float, Float, Float] new values of z, y, x
        def self.rotate(z, y, x, phi, etha, psi)
          # Oz
          z, y, x = *self.rotateOz(z, y, x, phi) if phi != 0.0
          # Oy
          z, y, x = *self.rotateOy(z, y, x, etha) if etha != 0.0
          # Ox
          z, y, x = *self.rotateOx(z, y, x, psi) if psi != 0.0
          [z, y, x]
        end


      end

    end
  end
end
