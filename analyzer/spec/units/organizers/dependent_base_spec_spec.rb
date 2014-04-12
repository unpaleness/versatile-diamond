require 'spec_helper'

module VersatileDiamond
  module Organizers

    describe DependentBaseSpec do
      def wrap(spec)
        described_class.new(spec)
      end

      describe '#parents' do
        it { expect(wrap(bridge_base).parents).to be_empty }
      end

      describe 'parents <-> children' do
        let(:parent) { wrap(bridge_base) }
        let(:child) { wrap(methyl_on_bridge_base) }

        it_behaves_like :multi_parents
        it_behaves_like :multi_children
      end

      it_behaves_like :minuend do
        subject { wrap(bridge_base) }
      end

      describe '#rest' do
        it { expect(wrap(bridge_base).rest).to be_nil }
      end

      describe '#store_rest' do
        subject { wrap(methyl_on_bridge_base) }
        let(:rest) { subject - wrap(bridge_base) }
        before { subject.store_rest(rest) }
        it { expect(subject.rest).to eq(rest) }
      end

      describe '#same?' do
        describe 'bridge_base' do
          let(:same_bridge) { wrap(bridge_base_dup) }
          subject { wrap(bridge_base) }

          it { expect(subject.same?(same_bridge)).to be_true }
          it { expect(same_bridge.same?(subject)).to be_true }

          it { expect(subject.same?(wrap(dimer_base))).to be_false }
        end

        describe 'methyl_on_bridge_base' do
          let(:other) { wrap(high_bridge_base) }
          subject { wrap(methyl_on_bridge_base) }

          it { expect(subject.same?(other)).to be_false }
          it { expect(other.same?(subject)).to be_false }
        end
      end

      describe '#residual' do
        subject { wrap(methyl_on_bridge_base)- wrap(bridge_base) }
        it { should be_a(SpecResidual) }
        it { expect(subject.links_size).to eq(2) }

        it_behaves_like :swap_to_atom_reference do
          let(:atoms_num) { 1 }
          let(:refs_num) { 1 }
        end
      end

      describe '#organize_dependencies!' do
        let(:specs) do
          [
            bridge_base,
            dimer_base,
            high_bridge_base,
            methyl_on_bridge_base,
            methyl_on_dimer_base,
            extended_bridge_base,
            extended_dimer_base,
            methyl_on_extended_bridge_base,
          ]
        end

        let(:wrapped_specs) { specs.map { |spec| wrap(spec) } }
        let(:cache) { Hash[wrapped_specs.map(&:name).zip(wrapped_specs)] }
        let(:table) { BaseSpeciesTable.new(wrapped_specs) }

        describe 'bridge' do
          subject { cache[:bridge] }
          before { subject.organize_dependencies!(table) }

          describe '#rest' do
            it { expect(subject.rest).to be_nil }
          end

          describe '#parents' do
            it { expect(subject.parents).to be_empty }
          end
        end

        describe 'methyl_on_bridge' do
          subject { cache[:methyl_on_bridge] }
          before { subject.organize_dependencies!(table) }

          describe '#rest' do
            it { expect(subject.rest.links_size).to eq(2) }
          end

          describe '#parents' do
            it { expect(subject.parents).to eq([cache[:bridge]]) }
          end
        end
      end

      describe '#specific?' do
        it { expect(wrap(methyl_on_dimer_base).specific?).to be_false }
      end

      describe '#excess?' do
          let(:wrapped_bridge) { wrap(bridge_base) }

        describe 'default behavior' do
          it { expect(wrapped_bridge.excess?).to be_false }
        end

        describe 'source behavior' do
          let(:wrapped_activated_bridge) do
            DependentSpecificSpec.new(activated_bridge)
          end

          before { wrapped_bridge.store_child(wrapped_activated_bridge) }
          it { expect(wrapped_bridge.excess?).to be_false }
        end

        describe 'intermediated behavior' do
          let(:wrapped_methyl_on_bridge) { described_class.new(methyl_on_bridge_base) }
          let(:wrapped_methyl_on_dimer) { described_class.new(methyl_on_dimer_base) }

          before do
            wrapped_methyl_on_bridge.store_parent(wrapped_bridge)
            wrapped_methyl_on_bridge.store_child(wrapped_methyl_on_dimer)
          end

          it { expect(wrapped_methyl_on_bridge.excess?).to be_false }
        end

        describe 'border behavior' do
          let(:wrapped_dimer) { wrap(dimer_base) }
          let(:wrapped_activated_dimer) do
            DependentSpecificSpec.new(activated_dimer)
          end

          before do
            wrapped_dimer.store_parent(wrapped_bridge)
            wrapped_dimer.store_parent(wrapped_bridge)
            wrapped_dimer.store_child(wrapped_activated_dimer)
          end

          it { expect(wrapped_dimer.excess?).to be_false }
        end

        describe 'excess behavior' do
          let(:wrapped_methyl_on_bridge) { wrap(methyl_on_bridge_base) }
          let(:wrapped_activated_methyl_on_dimer) do
            DependentSpecificSpec.new(activated_methyl_on_dimer)
          end

          before do
            wrapped_methyl_on_bridge.store_parent(wrapped_bridge)
            wrapped_methyl_on_bridge.store_child(wrapped_activated_methyl_on_dimer)
          end

          it { expect(wrapped_methyl_on_bridge.excess?).to be_true }
        end
      end

      describe '#exclude' do
        let(:left) { wrap(bridge_base) }
        let(:middle) { wrap(methyl_on_bridge_base) }
        let(:right) { DependentSpecificSpec.new(activated_methyl_on_bridge) }
        let(:rest) { middle - left }

        before do
          middle.store_rest(rest)
          middle.store_parent(left)
          right.store_parent(middle)
          middle.exclude
        end

        it { expect(left.children).to eq([right]) }
        it { expect(right.parent).to eq(left) }

        it { expect(left.rest).to be_nil }
        it { expect(right.rest).to eq(rest) }
      end
    end

  end
end
