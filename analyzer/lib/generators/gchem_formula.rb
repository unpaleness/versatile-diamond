module VersatileDiamond
  module Generators

    # Generates some graphical representations of used specs and reaction for
    # GChemPaint
    class GChemFormula < BaseDaughter

      SPACE_Y = 200
      SPACE_X = 200

      # @override
      def initialize(analysis_result, out_path)
        super(analysis_result)
        @out_path = out_path
        # puts "Class GChemFormula initialized!"
      end

      # Generator
      # @param [Array]
      def generate(**params)
        # puts "GChemFormula generator now executes!"
        # initializing indexes of species and atoms
        @species = []
        specie_index = 0
        y_position = SPACE_Y
        # creating XML-stream
        xml_stream = Nokogiri::XML::Builder.new do |xml|
          # main tag
          xml.send('gcp:chemistry','xmlns:gcp'=>'http://www.nongnu.org/gchempaint') do
            # for every specie in our model
            specific_surface_specs.each do |dep_spec|
              # 'if' condition should be removed
              # if specie_index == 15
                # adding specie
                @species[specie_index] = Formula::Specie.new(dep_spec.spec)
                xml.text!('id' => "o#{specie_index}") do
                  xml.position('x' => SPACE_X * 2 + @species[specie_index].x_size,
                    'y' => y_position)
                  xml.font('name' => "Pursia 10") do
                    xml << dep_spec.spec.name.to_s
                  end
                end
                @species[specie_index].draw(xml, specie_index, SPACE_X, y_position)
                y_position += SPACE_Y + @species[specie_index].y_size
              # end
              # incrementing specie index
              specie_index += 1
            end
          end
        end
        File.open("#{@out_path}.gchempaint", 'w') { |f| f.write(xml_stream.to_xml) }
        # binding.pry
      end
    end

  end
end
