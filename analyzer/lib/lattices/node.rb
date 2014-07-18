module VersatileDiamond
  module Lattice

    # Provides general information about elementary fragment of present lattice
    class Node

      attr_accessor :z, :y, :x, :atom, :depth

      # Sets z, y, x coordinates and wheather this node visited or not
      # ATTENTION!!! z, y, x ARE RELATIVE COORDINATES!!!
      # real coordinates a stored in @atom
      def initialize(*args)
        # constructor of copying
        if args.size == 1
          @z = args[0].z
          @y = args[0].y
          @x = args[0].x
          @atom = args[0].atom
          # parameter of recursion depth (see specie.rb)
          @depth = args[0].depth
        # constructor with parameters
        elsif args.size == 4
          @z = args[0]
          @y = args[1]
          @x = args[2]
          @atom = args[3]
          @depth = 0
        end
      end

      # Compares two nodes
      # @param [Node] node to compare with current one
      # @return [Boolean] is or not identical
      def ==(node)
        return false if node.class == nil.class
        return false if self.same_place?(node) == false
        return false if @atom != node.atom
        return false if @depth != node.depth
        true
      end

      # Checks wheather current node is on the same place as node is
      # @param [Node]
      # @return [Boolean]
      def same_place?(node)
        return false if @z != node.z
        return false if @y != node.y
        return false if @x != node.x
        true
      end

      # Converts Node to string-format for debugging
      # @return [String]
      def to_s
        "z = #{@z}, y = #{@y}, x = #{@x}, atom: #{@atom}"
      end

      # Returns Array of coordinates in matrix layout
      # @return [Float, Float, Float] z, y, x
      def coords
        [@z, @y, @x]
      end
    end

  end
end
