module VersatileDiamond
  module Generators
    module Formula

      # Created class 'Specie' for formula
      class Specie

        def initialize(filename, spec)
          # binding.pry
          @filename = filename
          @spec = spec
        end

        def draw(xml_stream)
          puts "#{@spec.to_s}\n"
        end
      end

    end
  end
end
