require 'spec_helper'

module VersatileDiamond
  module Lattice

    describe MatrixLayout do

      subject(:matrix_layout) { MatrixLayout.new }

      describe '#[]' do
        let(:test_atom) { subject.nodes[0][0][0].atom }
        let(:test_node) { subject.nodes[0][0][0] }
        it { expect(subject[test_atom]).to eq(test_node) }
        it { expect(subject[0, 0, 0]).to eq(test_node) }
      end

      describe '#[]=' do
        let(:test_node) { subject.nodes[0][0][0] }
        let(:test_atom) { Object.new }
        before { subject[0, 0, 0] = test_atom }
        it { expect(subject[0, 0, 0]).to eq(test_node) }
      end

      describe '#extend_z' do
        before { subject.extend_z(-1); subject.extend_z(1) }
        it "Checking extending by z-axis in both directions" do
          (subject.bz[0]..subject.bz[1]).each do |z|
            expect(subject.nodes[z][0][0]).to eq(Node.new(z, 0, 0, false, nil))
          end
        end
      end

      describe '#extend_y' do
        before { subject.extend_y(-1); subject.extend_y(1) }
        it "Checking extending by y-axis in both directions" do
          (subject.by[0]..subject.by[1]).each do |y|
            expect(subject[0, y, 0]).to eq(Node.new(0, y, 0, false, nil))
          end
        end
      end

      describe '#extend_x' do
        before { subject.extend_x(-1); subject.extend_x(-1) }
        it "Checking extending by x-axis in both directions" do
          (subject.bx[0]..subject.bx[1]).each do |x|
            expect(subject[0, 0, x]).to eq(Node.new(0, 0, x, false, nil))
          end
        end
      end

      describe '#front_100' do

      end
    end

  end
end
