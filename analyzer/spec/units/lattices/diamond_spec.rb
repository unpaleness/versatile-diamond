require 'spec_helper'

describe Diamond do

  Node = VersatileDiamond::Lattice::Node
  MatrixLayout = VersatileDiamond::Lattice::MatrixLayout
  Atom = VersatileDiamond::Generators::Formula::Atom

  subject(:diamond) { described_class.new }
  def rounding(x)
    x.round(14)
  end

  describe '#opposite_relation' do
    describe 'same lattice' do
      describe 'bonds' do
        it { expect { diamond.opposite_relation(diamond, free_bond) }.
          to raise_error undefined_relation }

        it { expect(diamond.opposite_relation(diamond, bond_100_cross)).
          to eq(bond_100_cross) }
        it { expect(diamond.opposite_relation(diamond, bond_100_front)).
          to eq(bond_100_front) }
        it { expect(diamond.opposite_relation(diamond, bond_110_front)).
          to eq(bond_110_cross) }
        it { expect(diamond.opposite_relation(diamond, bond_110_cross)).
          to eq(bond_110_front) }
      end

      describe 'positions' do
        it { expect(diamond.opposite_relation(diamond, position_100_front)).
          to eq(position_100_front) }
        it { expect(diamond.opposite_relation(diamond, position_100_cross)).
          to eq(position_100_cross) }
      end
    end

    describe 'other lattice' do
      describe 'bonds' do
        it { expect(diamond.opposite_relation(nil, free_bond)).
          to eq(free_bond) }

        it { expect { diamond.opposite_relation(nil, bond_100_front) }.
          to raise_error undefined_relation }
        it { expect { diamond.opposite_relation(nil, bond_100_cross) }.
          to raise_error undefined_relation }
        it { expect { diamond.opposite_relation(nil, bond_110_front) }.
          to raise_error undefined_relation }
        it { expect { diamond.opposite_relation(nil, bond_110_cross) }.
          to raise_error undefined_relation }
      end

      describe 'positions' do
        it { expect { diamond.opposite_relation(nil, position_100_front) }.
          to raise_error undefined_relation }
        it { expect { diamond.opposite_relation(nil, position_100_cross) }.
          to raise_error undefined_relation }
      end
    end
  end

  describe '#positions_between' do
    describe 'position 100 front' do
      let(:poss) { [position_100_front, position_100_front] }
      let(:links) do {
        cd0 => [[cd1, bond_110_front]],
        cd1 => [[cd0, bond_110_cross], [cd2, bond_110_cross]],
        cd2 => [[cd1, bond_110_front]]
      } end

      it { expect(diamond.positions_between(cd0, cd2, links)).to match_array(poss) }
      it { expect(diamond.positions_between(cd2, cd0, links)).to match_array(poss) }

      describe 'in three bridges' do
        let(:links) { three_bridges_base.links }
        let(:a1) { three_bridges_base.atom(:cc) }
        let(:a2) { three_bridges_base.atom(:ct) }

        it { expect(diamond.positions_between(a1, a2, links)).to match_array(poss) }
        it { expect(diamond.positions_between(a2, a1, links)).to match_array(poss) }
      end
    end

    describe 'position 100 cross' do
      describe 'inverted bridge' do
        let(:links) do {
          cd0 => [[cd1, bond_110_cross]],
          cd1 => [[cd0, bond_110_front], [cd2, bond_110_front]],
          cd2 => [[cd1, bond_110_cross]]
        } end

        it { expect(diamond.positions_between(cd0, cd2, links)).
          to match_array([position_100_cross, position_100_cross]) }
      end

      describe 'not found positions in dimer fondation because ambiguity' do
        3.times do |i|
          let(:"cd#{i + 3}") { cd.dup }
        end

        let(:links) do {
          cd0 => [[cd1, bond_110_front], [cd3, position_100_cross]],
          cd1 => [[cd0, bond_110_cross], [cd2, bond_110_cross], [cd4, bond_100_front]],
          cd2 => [[cd1, bond_110_front]],
          cd3 => [[cd4, bond_110_front], [cd3, position_100_cross]],
          cd4 => [[cd3, bond_110_cross], [cd5, bond_110_cross], [cd1, bond_100_front]],
          cd5 => [[cd4, bond_110_front]],
        } end

        it { expect(diamond.positions_between(cd2, cd4, links)).to be_nil }
      end
    end
  end

  describe '#{bond_length}' do
    it { expect(rounding(subject.class.send(:bond_length))).to eq(1.54e-10) }
  end

  describe '#{dx}' do
    it { expect(rounding(subject.class.send(:dx))).to eq(2.5148e-10) }
  end

  describe '#{dy}' do
    it { expect(rounding(subject.class.send(:dy))).to eq(2.5148e-10) }
  end

  describe '#{dz}' do
    it { expect(rounding(subject.class.send(:dz))).to eq(8.891e-11) }
  end

  describe '#{coords}' do
    let(:ml) { MatrixLayout.new }
    let(:atoms) { {} }
    let(:sample_atom) { Atom.new(333) }
    before do
      (-3..3).each do |z|
        atoms[z] = {}
        (-3..3).each do |y|
          atoms[z][y] = {}
          (-3..3).each do |x|
            atoms[z][y][x] = Atom.new(z * 100 + y * 10 + x)
            ml[z, y, x] = atoms[z][y][x]
            subject.class.coords(ml, atoms[z][y][x])
            puts "#{z}#{y}#{x} - (#{atoms[z][y][x].p[0] / subject.class.dz}; "\
              "#{atoms[z][y][x].p[1] / subject.class.dy}; "\
              "#{atoms[z][y][x].p[2] / subject.class.dx})"
            atoms[z][y][x].p[0] = rounding(atoms[z][y][x].p[0])
            atoms[z][y][x].p[1] = rounding(atoms[z][y][x].p[1])
            atoms[z][y][x].p[2] = rounding(atoms[z][y][x].p[2])
            # puts ml[z, y, x]
          end
        end
      end
      sample_atom.p[0] = rounding(subject.class.dz * 3.0)
      sample_atom.p[1] = rounding(subject.class.dy * 4.0)
      sample_atom.p[2] = rounding(subject.class.dx * 3.5)
    end

    it { expect(atoms[3][3][3]).to eq(sample_atom) }
  end

end
