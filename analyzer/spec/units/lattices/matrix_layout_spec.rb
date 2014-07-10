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

      describe '#extend_front_100' do
        before { subject.extend_front_100_all }
        it "Checking that every node has been initialized" do
          subject.each do |node|
            expect(node).to_not eq(nil)
          end
        end
      end

      describe '#extend_cross_100' do
        before { subject.extend_cross_100_all }
        it "Checking that every node has been initialized" do
          subject.each do |node|
            expect(node).to_not eq(nil)
          end
        end
      end

      #   describe '#extend_front_110' do
      #     let(:counted_node) { ml.nodes[1][0][-1] }
      #     let(:result_node) { Node.new(subject.dz, 0.0, - subject.dx / 2, false, nil) }
      #     before { subject.extend_front_110(ml) }
      #     it { expect(counted_node).to eq(result_node) }
      #   end

      #   describe '#extend_cross_110' do
      #     let(:counted_node) { ml.nodes[-1][-1][0] }
      #     let(:result_node) { Node.new(- subject.dz, - subject.dy / 2, 0.0, false, nil) }
      #     before { subject.extend_cross_110(ml) }
      #     it { expect(counted_node).to eq(result_node) }
      #   end
    end

  end
end
