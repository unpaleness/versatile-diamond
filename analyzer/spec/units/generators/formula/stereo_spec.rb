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
            it "rotate point #{arr[0]} on angle #{arr[1]} around Oz" do
              result = subject.rotateOz(*arr[0], arr[1]).map(&round_lambda)
              answer = arr[2]
              expect(result).to eq(answer)
            end
          end
        end

        describe '#rotateOy' do
          [
            [[1.0, 1.0, 1.0], Math::PI, [-1.0, 1.0, -1.0]],
            [[1.0, 1.0, 1.0], Math::PI / 2, [-1.0, 1.0, 1.0]]
          ].each do |arr|
            it "rotate point #{arr[0]} on angle #{arr[1]} around Oy" do
              result = subject.rotateOy(*arr[0], arr[1]).map(&round_lambda)
              answer = arr[2]
              expect(result).to eq(answer)
            end
          end
        end

        describe '#rotateOx' do
          [
            [[1.0, 1.0, 1.0], Math::PI, [-1.0, -1.0, 1.0]],
            [[1.0, 1.0, 1.0], Math::PI / 2, [1.0, -1.0, 1.0]]
          ].each do |arr|
            it "rotate point #{arr[0]} on angle #{arr[1]} around Ox" do
              result = subject.rotateOx(*arr[0], arr[1]).map(&round_lambda)
              answer = arr[2]
              expect(result).to eq(answer)
            end
          end
        end

        describe '#rotate' do
          [
            [[1.0, 1.0, 1.0], [Math::PI, Math::PI, Math::PI], [1.0, 1.0, 1.0]],

            [[1.0, 1.0, 1.0], [Math::PI / 4, Math::PI / 4, Math::PI / 4],
            [1.5, 0.5, 0.707107]]
          ].each do |arr|
            it "rotate point #{arr[0]} on angle #{arr[1][0]} around Oz, "\
              "on angle #{arr[1][1]} around Oy and on angle #{arr[1][2]} around Ox" do
              result = subject.rotate(*arr[0], *arr[1]).map(&round_lambda)
              answer = arr[2]
              expect(result).to eq(answer)
            end
          end
        end

      end

    end
  end
end
