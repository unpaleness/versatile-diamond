require 'spec_helper'

module VersatileDiamond
  module Lattice

    describe MatrixLayout do

      subject(:ml) { MatrixLayout.new }

      describe '#[]' do
        let(:test_atom) { ml.nodes[0][0][0].atom }
        let(:test_node) { ml.nodes[0][0][0] }
        it { expect(ml[test_atom]).to eq(test_node) }
        it { expect(ml[0, 0, 0]).to eq(test_node) }
      end

      describe '#[]=' do
        let(:test_node) { ml.nodes[0][0][0] }
        let(:test_atom) { Object.new }
        before { ml[0, 0, 0] = test_atom }
        it { expect(ml[0, 0, 0]).to eq(test_node) }
      end

      describe '#extend_z' do
        before { ml.extend_z(-1); ml.extend_z(1) }
        it "Checking extending by z-axis in both directions" do
          (ml.bz[0]..ml.bz[1]).each do |z|
            expect(ml.nodes[z][0][0]).to eq(Node.new(z, 0, 0, nil))
          end
        end
      end

      describe '#extend_y' do
        before { ml.extend_y(-1); ml.extend_y(1) }
        it "Checking extending by y-axis in both directions" do
          (ml.by[0]..ml.by[1]).each do |y|
            expect(ml[0, y, 0]).to eq(Node.new(0, y, 0, nil))
          end
        end
      end

      describe '#extend_x' do
        before { ml.extend_x(-1); ml.extend_x(-1) }
        it "Checking extending by x-axis in both directions" do
          (ml.bx[0]..ml.bx[1]).each do |x|
            expect(ml[0, 0, x]).to eq(Node.new(0, 0, x, nil))
          end
        end
      end

      describe '#front_100' do
        [
          [[0, 0, 0], [0, -1, 0], [0, 1, 0]],
          [[1, 0, 0], [1, 0, -1], [1, 0, 1]]
        ].each do |start, first, second|
          let (:start_atom) { ml[*start] }
          let (:result) { ml.front_100(start_atom) }
          let (:first_atom) { ml[*first] }
          let (:second_atom) { ml[*second] }
          it { expect(result).to eq([first_atom, second_atom]) }
        end
      end

      describe '#cross_100' do
        [
          [[0, 0, 0], [0, 0, -1], [0, 0, 1]],
          [[1, 0, 0], [1, -1, 0], [1, 1, 0]]
        ].each do |start, first, second|
          let (:start_atom) { ml[*start] }
          let (:result) { ml.cross_100(start_atom) }
          let (:first_atom) { ml[*first] }
          let (:second_atom) { ml[*second] }
          it { expect(result).to eq([first_atom, second_atom]) }
        end
      end

      describe '#front_110' do
        [
          [[0, 0, 0], [1, -1, 0], [1, 0, 0]],
          [[1, 0, 0], [2, 0, -1], [2, 0, 0]]
        ].each do |start, first, second|
          let (:start_atom) { ml[*start] }
          let (:result) { ml.front_110(start_atom) }
          let (:first_atom) { ml[*first] }
          let (:second_atom) { ml[*second] }
          it { expect(result).to eq([first_atom, second_atom]) }
        end
      end

      describe '#cross_110' do
        [
          [[0, 0, 0], [-1, 0, 0], [-1, 0, 1]],
          [[1, 0, 0], [0, 0, 0], [0, 1, 0]]
        ].each do |start, first, second|
          let (:start_atom) { ml[*start] }
          let (:result) { ml.cross_110(start_atom) }
          let (:first_atom) { ml[*first] }
          let (:second_atom) { ml[*second] }
          it { expect(result).to eq([first_atom, second_atom]) }
        end
      end
    end

  end
end
