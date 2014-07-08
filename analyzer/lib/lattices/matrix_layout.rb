module VersatileDiamond
  module Lattice

    # Provides general information about elementary fragment of present lattice
    class MatrixLayout

      attr_accessor :bx, :by, :bz, :nodes

      # Creates dummy arrays of coordinates of further created atoms
      def initialize
        @bz = [0, 0]
        @by = [0, 0]
        @bx = [0, 0]
        # z -> y -> x -> coordinates
        @nodes = {0 => {0 => {0 => Node.new(0.0, 0.0, 0.0, false, nil)}}}
      end

      # Lets us to get a Node with known id of atom
      # @param [Array]
      def [](*args)
        # if there is one argument so it is Atom
        if args.size == 1
          @nodes.each do |z, node_z|
            node_z.each do |y, node_zy|
              node_zy.each do |x, node_zyx|
                return node_zyx if node_zyx.atom == args[0]
              end
            end
          end
        elsif args.size == 3
          return @nodes[args[0]][args[1]][args[2]]
        end
        nil
      end
    end

  end
end
