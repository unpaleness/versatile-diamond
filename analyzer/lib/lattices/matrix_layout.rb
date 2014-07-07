module VersatileDiamond
  module Lattice

    # Provides general information about elementary fragment of present lattice
    class MatrixLayout

      attr_accessor :bx, :by, :bz, :nodes

      # Creates dummy arrays of coordinates of further created atoms
      def initialize
        @bx = [0, 0]
        @by = [0, 0]
        @bz = [0, 0]
        # z -> y -> x -> coordinates
        @nodes = {0 => {0 => {0 => Node.new(0.0, 0.0, 0.0, false)}}}
      end
    end

  end
end
