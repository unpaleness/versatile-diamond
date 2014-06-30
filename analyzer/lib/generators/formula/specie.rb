module VersatileDiamond
  module Generators
    module Formula

      # Created class 'Specie' for formula
      class Specie

        def initialize(spec)
          # binding.pry
          @spec = spec
        end

        def draw(xml)
          # puts "#{@spec.to_s}\n"
          xml['gcp'].chemistry('xmlns:gcp' => 'http://www.nongnu.org/gchempaint') do
            xml.molecule('id' => '1') do
            end
          end
        end
      end

    end
  end
end
