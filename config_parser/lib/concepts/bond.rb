module VersatileDiamond
  module Concepts

    # Class for bond instance. The bond can be without face and direction.
    class Bond

      class << self
        # The singleton method [] caches all instnaces and returns it if face and
        #   direction of the same.
        #
        # @option [Symbol] :face the face of bond
        # @option [Symbol] :dir the direction of bond
        # @return [Bond] cached instance
        def [](face: nil, dir: nil)
          key = face.to_s
          key << "_#{dir}" if dir
          @consts ||= {}
          @consts[key] ||= new(face, dir)
        end

        # Resets internal cache for RSpec
        def reset
          @consts = nil
        end
      end

      # Store the face and dir for instance
      # @param [Symbol] face the face of bond
      # @param [Symbol] dir the direction of bond
      def initialize(face, dir)
        @face, @dir = face, dir
      end

      # Approximate compares two instances. If their classes is same then
      # instances is the same. Else deligate comparing to other instance.
      #
      # @param [Concepts::Bond] other an other comparing instances
      # @return [Boolean] same or not
      def same?(other)
        self.class == other.class || other.same?(self)
      end

      def to_s
        symbol = '-'
        str = symbol.dup
        str << "#{@face}#{symbol}" if @face
        str << "#{@dir}#{symbol}" if @dir
        "#{str}#{symbol}"
      end

    protected

      attr_reader :face, :dir

    end

  end
end