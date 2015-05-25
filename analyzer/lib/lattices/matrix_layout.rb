module VersatileDiamond
  module Lattices

    # Provides general information about elementary fragment of present lattice
    class MatrixLayout

      attr_accessor :bx, :by, :bz, :nodes

      # Creates dummy arrays of coordinates of further created atoms
      def initialize
        @bz = [0, 0]
        @by = [0, 0]
        @bx = [0, 0]
        # z -> y -> x -> coordinates
        @nodes = {0 => {0 => {0 => Node.new(0, 0, 0, nil)}}}
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
          # raise ArgumentError, 'Lattice doesn\'t contain this atom.'
        # if there are three arguments they are coordinates
        elsif args.size == 3
          # we should be sure that our lattice contain this node
          # checking z-range
          while args[0] < @bz[0] do extend_z(-1) end
          while args[0] > @bz[1] do extend_z(1) end
          # checking y-range
          while args[1] < @by[0] do extend_y(-1) end
          while args[1] > @by[1] do extend_y(1) end
          # checking y-range
          while args[2] < @bx[0] do extend_x(-1) end
          while args[2] > @bx[1] do extend_x(1) end
          return @nodes[args[0]][args[1]][args[2]]
        end
        nil
      end

      # Lets us to set an atom in accordance to node
      # @param [Array, Atom]
      # @return [Node]
      def []=(z, y, x, atom)
        node = self[z, y, x]
        # node ? (node.atom = atom) : (return nil)
        node.atom = atom
        node
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

      # Checks if all elements are unique
      # @return [Boolean]
      def unique?
        result = true
        self.each do |node_outter|
          self.each do |node_inner|
            # puts node_inner.same_place?(node_outter)
            if node_inner.same_place?(node_outter) == false &&
              node_inner.atom == node_outter.atom &&
              node_inner.atom != nil
              result = false
            end
          end
        end
        result
      end

      # /*************************************************\
      # | METHODS FOR EXTENDING OUR PIECE OF SH.. lATTICE |
      # \*************************************************/

      # Extends matrix layout by z
      # @param [Integer] derection (-1 - forwardor 1 - backward)
      def extend_z(dir)
        @bz[(dir + 1) / 2] += dir
        z_new = @bz[(dir + 1) / 2]
        @nodes[z_new] = {}
        (@by[0]..@by[1]).each do |y|
          @nodes[z_new][y] = {}
          (@bx[0]..@bx[1]).each do |x|
            @nodes[z_new][y][x] = Node.new(z_new, y, x, nil)
          end
        end
      end
      private :extend_z

      # Extends matrix layout by y
      # @param [Integer] derection (-1 - forwardor 1 - backward)
      def extend_y(dir)
        @by[(dir + 1) / 2] += dir
        y_new = @by[(dir + 1) / 2]
        (@bz[0]..@bz[1]).each do |z|
          @nodes[z][y_new] = {}
          (@bx[0]..@bx[1]).each do |x|
            @nodes[z][y_new][x] = Node.new(z, y_new, x, nil)
          end
        end
      end
      private :extend_y

      # Extends matrix layout by x
      # @param [Integer] derection (-1 - forwardor 1 - backward)
      def extend_x(dir)
        @bx[(dir + 1) / 2] += dir
        x_new = @bx[(dir + 1) / 2]
        (@bz[0]..@bz[1]).each do |z|
          (@by[0]..@by[1]).each do |y|
            @nodes[z][y][x_new] = Node.new(z, y, x_new, nil)
          end
        end
      end
      private :extend_x

      # /***************************************************\
      # | METHODS-ITERATORS FOR ACCESSING TO NODES BY BONDS |
      # \***************************************************/

      # Allows us to access to node by bond front_100
      # @param [Node] current node
      # @return [Node, Node] next nodes
      def front_100(node)
        if node.z % 2 == 0
          [self[node.z, node.y - 1, node.x], self[node.z, node.y + 1, node.x]]
        else
          [self[node.z, node.y, node.x - 1], self[node.z, node.y, node.x + 1]]
        end
      end

      # Allows us to access to node by bond cross_100
      # @param [Node] current node
      # @return [Node, Node] next nodes
      def cross_100(node)
        if node.z % 2 == 0
          [self[node.z, node.y, node.x - 1], self[node.z, node.y, node.x + 1]]
        else
          [self[node.z, node.y - 1, node.x], self[node.z, node.y + 1, node.x]]
        end
      end

      # Allows us to access to node by bond front_110
      # @param [Node] current node
      # @return [Node, Node] next nodes
      def front_110(node)
        if node.z % 2 == 0
          [self[node.z + 1, node.y - 1, node.x], self[node.z + 1, node.y, node.x]]
        else
          [self[node.z + 1, node.y, node.x - 1], self[node.z + 1, node.y, node.x]]
        end
      end

      # Allows us to access to node by bond cross_110
      # @param [Node] current node
      # @return [Node, Node] next nodes
      def cross_110(node)
        if node.z % 2 == 0
          [self[node.z - 1, node.y, node.x], self[node.z - 1, node.y, node.x + 1]]
        else
          [self[node.z - 1, node.y, node.x], self[node.z - 1, node.y + 1, node.x]]
        end
      end
    end

  end
end
