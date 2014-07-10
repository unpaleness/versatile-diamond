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
        @nodes = {0 => {0 => {0 => Node.new(0, 0, 0, false, nil)}}}
      end

      # Lets us to get a node with known atom or by coordinates
      # @param [Array]
      # @return [Node]
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

      # Lets us sort out every node in our layout
      def each
        (@bz[0]..@bz[1]).each do |z|
          (@by[0]..@by[1]).each do |y|
            (@bx[0]..@bx[1]).each do |x|
              yield @nodes[z][y][x]
            end
          end
        end
      end

      # Extend matrix layout by one bond by direction front_100
      # @param [Integer] direction (-1 - forward or 1 - backward)
      def extend_front_100(dir)
        # making 0, 1 from -1, 1 =)
        @bx[(dir + 1) / 2] += dir
        x_new = @bx[(dir + 1) / 2]
        (@bz[0]..@bz[1]).each do |z|
          (@by[0]..@by[1]).each do |y|
            @nodes[z][y][x_new] = Node.new(z, y, x_new, false, nil)
          end
        end
      end

      # Extend matrix layout by one bond by all directions front_100
      def extend_front_100_all
        extend_front_100(-1)
        extend_front_100(1)
      end

      # Extend matrix layout by one bond by direction cross_100
      # @param [Integer] direction (-1 - forward or 1 - backward)
      def extend_cross_100(dir)
        # making 0, 1 from -1, 1 =)
        @by[(dir + 1) / 2] += dir
        y_new = @by[(dir + 1) / 2]
        (@bz[0]..@bz[1]).each do |z|
          @nodes[z][y_new] = {}
          (@bx[0]..@bx[1]).each do |x|
            @nodes[z][y_new][x] = Node.new(z, y_new, x, false, nil)
          end
        end
      end

      # Extend matrix layout by one bond by all directions cross_100
      # @param [MatrixLayout] our matrix layout
      def extend_cross_100_all
        extend_cross_100(-1)
        extend_cross_100(1)
      end

      # Extend matrix layout by one bond by direction front_110
      # Using this method causes extending x backwards on 1 atom!
      # @param [MatrixLayout] our matrix layout
      def extend_front_110
        @bz[1] += 1
        @nodes[@bz[1]] = {}
        (@by[0]..@by[1]).each do |y|
          @nodes[@bz[1]][y] = {}
          (@bx[0]..@bx[1]).each do |x|
            @nodes[@bz[1]][y][x] = Node.new(@bz[1] - 1, y, x, false, nil)
          end
        end
        extend_front_100(-1)
      end

      # Extend matrix layout by one bond by direction cross_110
      # Using this method causes extending y backwards on 1 atom!
      # @param [MatrixLayout] our matrix layout
      def extend_cross_110
        @bz[0] -= 1
        @nodes[@bz[0]] = {}
        (@by[0]..@by[1]).each do |y|
          @nodes[@bz[0]][y] = {}
          (@bx[0]..@bx[1]).each do |x|
            @nodes[@bz[0]][y][x] = Node.new(@bz[0] + 1, y, x, false, nil)
          end
        end
        extend_cross_100(-1)
      end
    end

  end
end
