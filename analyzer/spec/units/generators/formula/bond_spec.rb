require 'spec_helper'

module VersatileDiamond
  module Generators
    module Formula

      describe Bond do
        let(:atom_begin) { Formula::Atom.new(1) }
        let(:atom_end) { Formula::Atom.new(2) }
        subject { Bond.new(atom_begin, atom_end, bond_100_front) }

        describe '#to_s' do
          let(:awaited) {
            'from: 1, to: 2, order = 1, face: 100, dir: front, is bond? - true' }
          let(:returned) { subject.to_s }
          it { expect(returned).to eq(awaited) }
        end
      end

    end
  end
end
