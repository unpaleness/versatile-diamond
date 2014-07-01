module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Specie' for formula
      class Specie

        BOND_LENGTH = 140

        def initialize(spec)
          @spec = spec
          collect_all
          # binding.pry
        end

        # Collects all atoms and bonds to appropriate arrays
        def collect_all
          @atoms = []
          @bonds = []
          atom_index = bond_index = 0
          @spec.links.each do |key, link|
            @atoms[atom_index] = Formula::Atom.new(key)
            # amount of bonds to current atom
            bonds_amount_inner = link.count
            (0...bonds_amount_inner).each do |i|
              @bonds[bond_index + i] = Formula::Bond.new(link)
            end
            bond_index += bonds_amount_inner
            atom_index += 1
          end
          @atoms_amount = atom_index
          @bonds_amount = bond_index / 2
          # binding.pry
        end

        # Procedure of drawing a specie.
        # Must be initialized:
        #  - XML stream
        #  - current index of specie (or 'molecule' in GChemPaint)
        #  - current index of atom (may unused in future)
        #  - current index of bond (may unused in future)
        def draw(xml, specie_index, atom_index, bond_index)
          # xml.molecule('id' => specie_index) do
          #   (0...@atoms_amount).each do |i|
          #     xml.atom('id' => "a#{atom_index + i}", 'element' => 'C') do
          #       xml.position('x' => 100, 'y' => 100)
          #     end
          #   end
          #   (0...@bonds_amount).each do |i|
          #     xml.bond('id' => "b#{bond_index + i}", 'order' => bonds[i].order,
          #       'begin' => bonds[i].id_atom_begin, 'end' => bonds[i].id_atom_end)
          #   end
          # end
          [@atoms_amount, @bonds_amount]
        end
      end

    end
  end
end
