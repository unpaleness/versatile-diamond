require 'spec_helper'

module VersatileDiamond
  module Generators
    module Formula

      describe Atom do
        subject { Atom.new('some_atom') }
        let(:round_lambda) { -> i {i.round(6) } }

      end

    end
  end
end
