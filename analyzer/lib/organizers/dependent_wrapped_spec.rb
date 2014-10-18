module VersatileDiamond
  module Organizers

    # Wraps some many-atomic species and provides common methods for using them
    # @abstract
    class DependentWrappedSpec < DependentSpec
      include Minuend
      include MultiChildrenSpec
      include ResidualContainerSpec

      def_delegators :@spec, :external_bonds, :gas?, :relation_between
      attr_reader :links

      # Also stores internal graph of links between used atoms
      # @param [Array] _args the arguments of super constructor
      def initialize(*_args)
        super
        @links = straighten_graph(spec.links)
      end

      # Gets anchors of internal specie
      # @return [Array] the array of anchor atoms
      def anchors
        target.links.keys
      end

      # Gets sorted parents of target specie
      # @return [Array] the sorted array of parent seqeucnes
      def sorted_parents
        parents.sort do |*prs|
          acln, bcln = prs.map(&:clean_relations_num)
          if acln == bcln
            aln, bln = prs.map(&:relations_num)
            bln <=> aln
          else
            bcln <=> acln
          end
        end
      end

      # Gets the children specie classes
      # @return [Array] the array of children specie class generators
      def non_term_children
        children.reject(&:termination?)
      end

      # Checks that finding specie is source specie
      # @return [Boolean] is source specie or not
      def source?
        parents.size == 0
      end

      # Checks that finding specie have more than one parent
      # @return [Boolean] have many parents or not
      def complex?
        parents.size > 1
      end

      def to_s
        "(#{name}, [#{parents.map(&:name).join(' ')}], " +
          "[#{children.map(&:name).join(' ')}])"
      end

      def inspect
        to_s
      end

    private

      # Replaces internal atom references to original atom and inject references of it
      # to result graph
      #
      # @param [Hash] links the graph where vertices are atoms (or references) and
      #   edges are bonds or positions between them
      # @return [Hash] the rectified graph
      def straighten_graph(links)
        links.each.with_object({}) do |(atom, relations), result|
          result[atom] = relations + atom.additional_relations
        end
      end

      # Provides links that will be cleaned by #clean_links
      # @return [Hash] the links which will be cleaned
      def cleanable_links
        spec.links
      end
    end

  end
end
