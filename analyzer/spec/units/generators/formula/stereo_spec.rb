require 'spec_helper'

module VersatileDiamond
  module Generators
    module Formula

      describe Stereo do

        subject { Stereo }
        let(:round_lambda) { -> i { i.round(6) } }

        describe '#rotate' do
          [
            [[1.0, 1.0, 1.0], [Math::PI, Math::PI, Math::PI], [1.0, 1.0, -1.0]],
            [[1.0, 1.0, 1.0], [Math::PI / 2, 0.0, 0.0], [1.0, 1.0, -1.0]]
          ].each do |point, angles, result|
            let(:answer) { subject.rotate(*point, *angles).map(&round_lambda) }
            it { expect(answer).to eq(result) }
          end
        end

      end

    end
  end
end
