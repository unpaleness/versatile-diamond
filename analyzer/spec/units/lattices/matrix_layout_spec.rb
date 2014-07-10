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

      describe '#extend_front_100_all' do
        before { subject.extend_front_100_all }
        it "Checking extending in front_100 for both directions" do
          (subject.bz[0]..subject.bz[1]).each do |z|
            (subject.by[0]..subject.by[1]).each do |y|
              (subject.bx[0]..subject.bx[1]).each do |x|
                expect(subject[z, y, x]).to eq(Node.new(z, y, x, false, nil))
              end
            end
          end
        end
      end

      describe '#extend_cross_100_all' do
        before { subject.extend_cross_100_all }
        it "Checking extending in cross_100 for both directions" do
          (subject.bz[0]..subject.bz[1]).each do |z|
            (subject.by[0]..subject.by[1]).each do |y|
              (subject.bx[0]..subject.bx[1]).each do |x|
                expect(subject[z, y, x]).to eq(Node.new(z, y, x, false, nil))
              end
            end
          end
        end
      end

      describe '#extend_front_110' do
        before { subject.extend_front_110 }
        it "Checking extending in front_110" do
          (subject.bz[0]..subject.bz[1]).each do |z|
            (subject.by[0]..subject.by[1]).each do |y|
              (subject.bx[0]..subject.bx[1]).each do |x|
                expect(subject[z, y, x]).to eq(Node.new(z, y, x, false, nil))
              end
            end
          end
        end
      end

      describe '#extend_cross_110' do
        before { subject.extend_cross_110 }
        it "Checking extending in cross_110" do
          (subject.bz[0]..subject.bz[1]).each do |z|
            (subject.by[0]..subject.by[1]).each do |y|
              (subject.bx[0]..subject.bx[1]).each do |x|
                expect(subject[z, y, x]).to eq(Node.new(z, y, x, false, nil))
              end
            end
          end
        end
      end
    end

  end
end
