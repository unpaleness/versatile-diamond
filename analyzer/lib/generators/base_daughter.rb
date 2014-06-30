module VersatileDiamond
  module Generators

    # Provides some additional methods to class 'Base' used in GChemFormula and
    # its functionality
    class BaseDaughter < Base

      # Gets all species
      # @return [Array] the array of all specs
      def all_specs
        (base_specs || []) + (specific_specs || [])
      end
    end

  end
end
