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

          describe '#dec_to_sph' do
            [
              [[1.0, 1.0, 1.0], [1.732050808, 0.785398163, 0.615479709]],
              [[1.0, 1.0, -1.0], [1.732050808, 0.785398163, -0.615479709]],
              [[1.0, -1.0, 1.0], [1.732050808, -0.785398163, 0.615479709]],
              [[1.0, -1.0, -1.0], [1.732050808, -0.785398163, -0.615479709]],
              [[-1.0, 1.0, 1.0], [1.732050808, 2.35619449, 0.615479709]],
              [[-1.0, 1.0, -1.0], [1.732050808, 2.35619449, -0.615479709]],
              [[-1.0, -1.0, 1.0], [1.732050808, -2.35619449, 0.615479709]],
              [[-1.0, -1.0, -1.0], [1.732050808, -2.35619449, -0.615479709]]
            ].each do |args, answer|
              let(:result) { subject.dec_to_sph(*args) }
              let(:rounded_result) { result.map(&round_lambda) }
              let(:rounded_answer) { answer.map(&round_lambda) }
              it { expect(rounded_result).to eq(rounded_answer) }
            end
          end

          describe '#sph_to_dec' do
            [
              [[1.732050808, 0.785398163, 0.615479709], [1.0, 1.0, 1.0]],
              [[1.732050808, 0.785398163, -0.615479709], [1.0, 1.0, -1.0]],
              [[1.732050808, -0.785398163, 0.615479709], [1.0, -1.0, 1.0]],
              [[1.732050808, -0.785398163, -0.615479709], [1.0, -1.0, -1.0]],
              [[1.732050808, 2.35619449, 0.615479709], [-1.0, 1.0, 1.0]],
              [[1.732050808, 2.35619449, -0.615479709], [-1.0, 1.0, -1.0]],
              [[1.732050808, -2.35619449, 0.615479709], [-1.0, -1.0, 1.0]],
              [[1.732050808, -2.35619449, -0.615479709], [-1.0, -1.0, -1.0]]
            ].each do |args, answer|
              let(:result) { subject.sph_to_dec(*args) }
              let(:rounded_result) { result.map(&round_lambda) }
              let(:rounded_answer) { answer.map(&round_lambda) }
              it { expect(rounded_result).to eq(rounded_answer) }
            end
          end
        end

      end

    end
  end
end
