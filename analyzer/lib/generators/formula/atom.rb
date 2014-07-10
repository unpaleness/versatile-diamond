module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Atom' for Formula. Contains !relative! coordinates in volume
      class Atom

        include Stereo

        attr_reader :atom, :id
        attr_accessor :x, :y, :z, :bonds, :node

        # Initializer
        # 'atom' is a reference to atoms defined for current spec by Gleb
        # firstly all coordinates are 0
        def initialize(atom)
          @x = @y = @z = 0
          @atom = atom
          @id = @atom.object_id
          @bonds = {}
          @node = nil
          # binding.pry
        end

        # Returns symbolic illustration of current atom
        # @return [String]
        def name
          @atom.name
        end

        def ==(other_atom)
          return false if @id != other_atom.id
          return false if @z != other_atom.z
          return false if @y != other_atom.y
          return false if @x != other_atom.x
          true
        end

        # Lets us to receive information about atom in more readable format
        # @return [String]
        def to_s
          res = "id = #{@id}, z = #{@z}, y = #{@y}, x = #{@x}, bonds:\n"
          @bonds.each do |id_atom_to, bond|
            res << "#{bond.to_s}\n"
          end
          res
        end

        # Moves atom on values dx, dy, dz
        def move_on_dec(dz, dy, dx)
          @z += dz
          @y += dy
          @x += dx
        end

        # Moves atom on values dro, dphi, detha
        # @return [Float, Float, Float]
        def move_on_sph(dro, dphi, detha)
          ro, phi, etha = dec_to_sph(@x, @y, @z)
          @z, @y, @x = sph_to_dec(ro + dro, phi + dphi, etha + detha)
          [@z, @y, @x]
        end

        # Rotate relative to the point (x; y; z)
        def rotate(z, y, x, dphi, detha)

        end
      end

    end
  end
end
