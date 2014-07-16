module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Atom' for Formula. Contains !relative! coordinates in volume
      class Atom

        include Stereo

        attr_reader :atom, :id
        attr_accessor :x, :y, :z, :id, :bonds, :node

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

        # Compares current atom with another one
        # @param [Atom] atom to compare
        # @return [Boolean] result of comparison
        def ==(other_atom)
          return false if other_atom == nil
          return false if @id != other_atom.id
          return false if @z != other_atom.z
          return false if @y != other_atom.y
          return false if @x != other_atom.x
          true
        end

        # Sets all coordinates in the same time
        # @param [Float, Float, Float] z, y, x coorinates respectively
        def set_coords(z, y, x)
          @z = z
          @y = y
          @x = x
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
      end

    end
  end
end
