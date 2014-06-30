module VersatileDiamond
  module Generators

    # Generates some graphical representations of used specs and reaction for
    # GChemPaint
    class GChemFormula < BaseDaughter

      # @override
      def initialize(analysis_result, out_path)
        super(analysis_result)
        puts "Class GChemFormula initialized!"
      end

      def generate(**params)
        xml_stream = Nokogiri::XML::Builder.new
        puts "GChemFormula generator now executes!"
        i = 0
        all_specs.each do |dep_spec|
          puts "#{i}"
          Formula::Specie.new(i.to_s, dep_spec.spec).draw(xml_stream)
          i += 1
        end
      end
    end

  end
end
