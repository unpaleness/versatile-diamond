module VersatileDiamond
  module Generators

    # Generates some graphical representations of used specs and reaction for
    # GChemPaint
    class GChemFormula < BaseDaughter

      # @override
      def initialize(analysis_result, out_path)
        super(analysis_result)
        @out_path = out_path
        puts "Class GChemFormula initialized!"
      end

      def generate(**params)
        puts "GChemFormula generator now executes!"
        i = 0
        all_specs.each do |dep_spec|
          puts "#{i}"
          xml_stream = Nokogiri::XML::Builder.new do |xml|
            Formula::Specie.new(dep_spec.spec).draw(xml)
          end
          File.open("#{@out_path}#{i}.gchempaint", 'w') { |f| f.write(xml_stream.to_xml) }
          i += 1
          break if i > 0 # GOTO: A VERY SPIKY EXIT!!!
        end
      end
    end

  end
end
