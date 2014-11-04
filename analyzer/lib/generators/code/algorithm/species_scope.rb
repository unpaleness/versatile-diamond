module VersatileDiamond
  module Generators
    module Code
      module Algorithm

        # Contains many species as one
        class SpeciesScope

          def initialize(species)
            @species = species
          end

          def inspect
            "scope:<#{@species.map(&:inspect).join(', ')}>"
          end
        end

      end
    end
  end
end
