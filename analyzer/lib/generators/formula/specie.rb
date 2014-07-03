module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Specie' for formula
      class Specie

        include Stereo
        
        attr_reader :spec, :atoms_amount, :bonds_amount, :atoms, :bonds

        BOND_LENGTH = 140

        def initialize(spec)
          @spec = spec
          @atoms_amount = collect_atoms
          @bonds_amount = collect_bonds
          count_coordinates
          # binding.pry
        end

        # Collects all atoms to appropriate hash
        # @return [Integer] total amount of atoms in current specie
        def collect_atoms
          @atoms = {}
          atom_index = 0
          # process every record in this hash
          @spec.links.each do |key, pairs|
            # id of current atom
            id_atom = key.object_id
            # adding an atom to hash with object.id as a key
            @atoms[id_atom] = Formula::Atom.new(key)
            atom_index += 1
          end
          atom_index
        end

        # Collects all bonds to appropriate array
        # @return [Inreger] total amount of bonds in current specie
        def collect_bonds
          @bonds = []
          bond_index = 0
          # process every record in this hash
          @spec.links.each do |key, pairs|
            id_atom = key.object_id
            # adding bonds to array of bonds
            (0...(pairs.count)).each do |i|
              # firstly candidate bond marked as not created
              already_created = false
              # checking for bond to be identical to someone previous
              # if so add +1 to its order
              (0...bond_index).each do |j|
                # checking implements throuth comparision of begin and end atoms of
                # bonds
                if @bonds[j].id_atom_begin == id_atom &&
                  @bonds[j].id_atom_end == pairs[i][0].object_id
                  @bonds[j].order += 1
                  # mark candidate bond as created
                  already_created = true
                end
              end
              # create a new candidate bond if it was not created
              if !already_created(@bonds, pairs, bond_index, i, id_atom)
                @bonds[bond_index] =
                  Formula::Bond.new(id_atom, pairs[i][0].object_id, pairs[i][1])
                bond_index += 1
              end
            end
          end
          bond_index
        end

        # Checks wheather bond was created or not and adds 'order' parameter to bond
        # in case of duplication
        # Reverse bonds are going to be removed completely!!!
        # @return [Logical] true/false value
        def already_created(bonds, pairs, bond_index, pair_index, id_atom)
          # firstly candidate bond marked as not created
          is_created = false
          # checking for bond to be identical to someone previous
          # if so add +1 to its order
          (0...bond_index).each do |j|
            # checking implements throuth comparision of begin and end atoms of
            # bonds
            if @bonds[j].id_atom_begin == id_atom &&
              @bonds[j].id_atom_end == pairs[pair_index][0].object_id
              @bonds[j].order += 1
              # mark candidate bond as created
              is_created = true
            end
            # checking for reverse to some bond; if so just mark bond as already
            # created without incrementing order
            if @bonds[j].id_atom_begin == pairs[pair_index][0].object_id &&
              @bonds[j].id_atom_end == id_atom
              # mark candidate bond as created
              is_created = true
            end
          end
          is_created
        end

        # Counts coordinates of every atom in current specie
        def count_coordinates
          
        end

        # Procedure of drawing a specie.
        # Must be initialized:
        #  - XML stream
        #  - current index of specie (or 'molecule' in GChemPaint)
        def draw(xml, specie_index)
          xml.molecule('id' => specie_index) do
            @atoms.each do |id, atom|
              xml.atom('id' => atom.id, 'element' => atom.name) do
                xml.position('x' => 100, 'y' => 100)
              end
            end
            (0...@bonds_amount).each do |i|
              xml.bond('id' => "b#{i}", 'order' => @bonds[i].order,
                'begin' => @bonds[i].id_atom_begin, 'end' => @bonds[i].id_atom_end)
            end
          end
        end
      end

    end
  end
end
