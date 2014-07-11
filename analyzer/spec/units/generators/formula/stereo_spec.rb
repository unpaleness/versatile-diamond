require 'spec_helper'

module VersatileDiamond
  module Generators
    module Formula

      describe Stereo do
        class StereoExample
          include Stereo
        end

        describe StereoExample do
          subject { StereoExample.new }
          let(:round_lambda) { -> i { i.round(6) } }

        end

      end

    end
  end
end
