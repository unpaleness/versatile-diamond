module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Atom' for Formula. Contains !relative! coordinates in volume
      class Atom

        attr_reader :atom, :id
        attr_accessor :p, :id, :bonds, :node

        # Initializer
        # 'atom' is a reference to atoms defined for current spec by Gleb
        # firstly all coordinates are 0
        def initialize(atom)
          @p = [0, 0, 0]
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
          @p.each_with_index do |coord, i|
            return false if coord != other_atom.p[i]
          end
          true
        end

        # @overload set_coords(coords)
        #  Coordinates in array view
        #  @param [Array] array of Float z, y, x coordinates
        # @overload set_coords(z, y, x)
        #  Coordinates in pile view
        #  @param [Float, Float, Float] z, y, x coorinates respectively
        def set_coords(*coords)
          # if array view
          if coords.size == 1
            coords[0].each_with_index do |coord, i|
              @p[i] = coord
            end
          elsif coords.size == 3
            coords.each_with_index do |coord, i|
              @p[i] = coord
            end
          else
            raise ArgumentExeption, 'Wrong number of arguments (not 1 and not 3)'
          end
        end

        # @overload inc_coords(coords)
        #  Increment of coordinates in array view
        #  @param [Array] array of Float dz, dy, dx increments
        # @overload inc_coords(z, y, x)
        #  Increment of coordinates in pile view
        #  @param [Float, Float, Float] dz, dy, dx increments respectively
        def inc_coords(*coords)
          # if array view
          if coords.size == 1
            coords[0].each_with_index do |coord, i|
              @p[i] += coord
            end
          elsif coords.size == 3
            coords.each_with_index do |coord, i|
              @p[i] += coord
            end
          else
            raise ArgumentExeption, 'Wrong number of arguments (not 1 and not 3)'
          end
        end

        # Lets us to receive information about atom in more readable format
        # @return [String]
        def to_s
          res = "#{bonds.size}\nid = #{@id}, z = #{@p[0]}, y = #{@p[1]}, x = #{@p[2]}, bonds:"
          @bonds.reduce(res) { |acc, (_, bond)| acc << " #{bond.to_s};" }
        end
      end

    end
  end
end
