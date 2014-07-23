require 'spec_helper'

module VersatileDiamond
  module Generators
    module Formula

      describe Stereo do

        subject { Stereo }
        let(:round_lambda) { -> i { i.round(6) } }

        # TRUE MAGIC ITSELF!!!
        # THIS TEST IS CURSED BY SOMEONE!!!

        describe '#rotateOz' do
          [
            [[1.0, 1.0, 1.0], Math::PI, [1.0, -1.0, -1.0]],
            [[1.0, 1.0, 1.0], Math::PI / 2, [1.0, 1.0, -1.0]]
          ].each do |arr|
            let(:result) { subject.rotateOz(*arr[0], arr[1]).map(&round_lambda) }
            let(:answer) { arr[2] }
            it { expect(result).to eq(answer) }
          end
        end

        describe '#rotateOy' do
          [
            [[1.0, 1.0, 1.0], Math::PI, [-1.0, 1.0, -1.0]],
            [[1.0, 1.0, 1.0], Math::PI / 2, [-1.0, 1.0, 1.0]]
          ].each do |arr|
            let(:result) { subject.rotateOy(*arr[0], arr[1]).map(&round_lambda) }
            let(:answer) { arr[2] }
            it { expect(result).to eq(answer) }
          end
        end

        describe '#rotateOx' do
          [
            [[1.0, 1.0, 1.0], Math::PI, [-1.0, -1.0, 1.0]],
            [[1.0, 1.0, 1.0], Math::PI / 2, [1.0, -1.0, 1.0]]
          ].each do |arr|
            let(:result) { subject.rotateOx(*arr[0], arr[1]).map(&round_lambda) }
            let(:answer) { arr[2] }
            it { expect(result).to eq(answer) }
          end
        end

        describe '#rotate' do
          [
            [[1.0, 1.0, 1.0], [Math::PI, Math::PI, Math::PI], [1.0, 1.0, 1.0]],
            [[1.0, 1.0, 1.0], [Math::PI / 4, Math::PI / 4, Math::PI / 4], [1.5, 0.5, 0.707107]]
          ].each do |arr|
            let(:result) { subject.rotate(*arr[0], *arr[1]).map(&round_lambda) }
            let(:answer) { arr[2] }
            it { expect(result).to eq(answer) }
          end
        end

      end

    end
  end
end
