require 'spec_helper'

module VersatileDiamond
  module Generators
    module Formula

      describe Atom do
        subject { Atom.new('some_atom') }
        let(:round_lambda) { -> i {i.round(6) } }

        describe '#move_on_sph' do
          [
            [[0.0, 0.0, 0.0], [1.0, Math::PI / 2, Math::PI / 2], [0.0, 0.0, 1.0]],

            [[0.0, 0.0, 0.0], [1.0, Math::PI / 4, Math::asin(Math::sqrt(1.0 / 3.0))],
            [Math::sqrt(1.0 / 3.0), Math::sqrt(1.0 / 3.0), Math::sqrt(1.0 / 3.0)]],

            [[0.0, 0.0, 0.0], [1.0, -Math::PI / 4, -Math::asin(Math::sqrt(1.0 / 3.0))],
            [-Math::sqrt(1.0 / 3.0), -Math::sqrt(1.0 / 3.0), Math::sqrt(1.0 / 3.0)]]
          ].each do |coordinates, difference, answer|
            before { subject.z, subject.y, subject.x = coordinates }
            let(:result) { subject.move_on_sph(*difference) }
            let(:rounded_result) { result.map(&round_lambda) }
            let(:rounded_answer) { answer.map(&round_lambda) }
            it { expect(rounded_result).to eq(rounded_answer) }
          end
        end
      end

    end
  end
end
