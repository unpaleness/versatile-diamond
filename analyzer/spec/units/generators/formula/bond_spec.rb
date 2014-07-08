require 'spec_helper'

module VersatileDiamond
  module Generators
    module Formula

      describe Bond do
        # parameters for constructor
        def bond_params
          id_begin = 1
          id_end = 2
          bond = double('bond')
          allow(bond).to receive('face').and_return('100')
          allow(bond).to receive('dir').and_return('front')
          allow(bond).to receive('class').
            and_return('VersatileDiamond::Concepts::Bond')
          [id_begin, id_end, bond]
        end
        subject { Bond.new(*bond_params) }

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
