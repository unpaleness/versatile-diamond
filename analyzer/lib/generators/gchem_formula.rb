module VersatileDiamond
  module Generators

    # Generates some graphical representations of used specs and reaction for
    # GChemPaint
    class GChemFormula < Base

      def initialize(analysis_result, out_path)
        puts "Class GChemFormula initialized!"

        @species = collect_formula_species
      end

      def generate(**params)
        puts "GChemFormula generator now executes!"

      end

      def collect_formula_species
        all_specs.each.with_object({}) do |(name, spec), hash|
          hash[name] = 
        end
      end

    end

  end
end
