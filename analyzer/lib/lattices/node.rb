module VersatileDiamond
  module Lattice

    # Provides general information about elementary fragment of present lattice
    class Node

      attr_accessor :z, :y, :x, :is_visited

      # Sets z, y, x coordinates and wheather this node visited or not
      def initialize(*args)
        # constructor of copying
        if args.size == 1
          @z = args[0].z
          @y = args[0].y
          @x = args[0].x
          @is_visited = args[0].is_visited
        # constructor with parameters
        elsif args.size == 4
          @z = args[0]
          @y = args[1]
          @x = args[2]
          @is_visited = args[3]
        end
      end

      # Compares two nodes
      # @param [Node] node to compare with current one
      # @return [Boolean] is or not identical
      def ==(node)
        return false if @z != node.z
        return false if @y != node.y
        return false if @x != node.x
        return false if @is_visited != node.is_visited
        true
      end
    end

  end
end
