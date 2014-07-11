module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Specie' for formula
      class Specie

        include Stereo
        include VersatileDiamond::Lattice

        attr_reader :spec, :atoms_amount, :bonds_amount, :atoms, :bonds, :lattice

        BOND_LENGTH = 140

        def initialize(spec)
          @spec = spec
          @atoms_amount = collect_atoms
          @bonds_amount = collect_bonds
          bind_bonds_and_atoms
          @matlay = MatrixLayout.new
          @matlay[0, 0, 0].atom = @atoms.first[1]
          spread(@atoms.first[1], 10)
          # rotate(0.0, 0.0, 0.0, 0.0, 0.0)
          # binding.pry
        end

        # Collects all atoms to appropriate hash
        # @return [Integer] total amount of atoms in current specie
        def collect_atoms
          @atoms = {}
          atom_index = 0
          # process every record in this hash
          @spec.links.each do |key, pairs|
            # adding an atom to hash with object.id as a key
            @atoms[key] = Formula::Atom.new(key)
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
            # adding bonds to array of bonds
            (0...(pairs.count)).each do |i|
              # create a new candidate bond if it was not created
              if !already_created(@atoms, @bonds, pairs, bond_index, i, key)
                @bonds[bond_index] =
                  Formula::Bond.new(@atoms[key], @atoms[pairs[i][0]], pairs[i][1])
                bond_index += 1
              end
            end
          end
          bond_index
        end

        # Adds references to bonds to every atom
        def bind_bonds_and_atoms
          @atoms.each do |atom, atom_wide|
            @bonds.each do |bond|
              # if current atom id as equal to atom id of begin of bond
              if atom_wide.id == bond.atom_begin.id then
                atom_wide.bonds[bond.atom_end] = bond
              end
            end
          end
        end

        # Checks wheather bond was created or not and adds 'order' parameter to bond
        # in case of duplication
        # Reverse bonds are going to be removed completely!!!
        # @return [Logical] true/false value
        def already_created(atoms, bonds, pairs, bond_index, pair_index, atom)
          # firstly candidate bond marked as not created
          is_created = false
          # checking for bond to be identical to someone previous
          # if so add +1 to its order
          (0...bond_index).each do |j|
            # checking implements throuth comparision of begin and end atoms of
            # bonds
            if @bonds[j].atom_begin == atoms[atom] &&
              @bonds[j].atom_end == atoms[pairs[pair_index][0]]
              @bonds[j].order += 1
              # mark candidate bond as created
              is_created = true
            end
          end
          is_created
        end

        # Translates info about spec into string
        # @return [String]
        def to_s
          result = "#{@spec.name}\n"
          @atoms.each do |id_atom, atom|
            result << " #{atom.to_s}"
          end
          result
        end

        # Recursively locates atoms' positions on the lattice
        # @param [Atom, Integer] considarating atom and iteration limit
        # @return [Boolean] either was spreading successful or not
        def spread(atom, iter)
          return false if iter == 0
          result = true
          # enumerate all bonds of current atom
          atom.bonds.each do |atom_end, bond|
            # shows wheather our journey is successful
            loop_success = false
            # if destination atom belongs to lattice
            if atom_end.atom.lattice != nil
              # shows either there are some free nodes or not
              are_free_nodes = false
              # check for free nodes and if there is desired atom_end in lattice
              @matlay.send("#{bond.bond.dir}_#{bond.bond.face}", @matlay[atom]).each do |node|
                loop_success = true if node.atom == atom_end
                are_free_nodes = true if node.atom == nil
              end
              # if loop is not closed and there are som free nodes try it
              if loop_success == false && are_free_nodes == true
                # for every destination of bond
                @matlay.send("#{bond.bond.dir}_#{bond.bond.face}", @matlay[atom]).each do |node|
                  # if node is free
                  if node.atom == nil
                    # assumption that atom should be here
                    node.atom = atom_end
                    # checking this assumption
                    if spread(atom_end, iter - 1)
                      loop_success = true
                    else
                      # if assumption has not justified
                      node.atom = nil
                    end
                  end
                end
              end
            # otherwise, if destination is free-flying atom we should do something
            # another *__*
            else
              #
              # juicy code
              #
              loop_success = true
            end
            result = false if loop_success == false
          end
          VersatileDiamond::Lattices::Base::Diamond::coords(@matlay, atom) if result == true
          result
        end

        # Rotates all atoms relative point (x; y; z)
        # @param [Float, Float, Float, Float, Float] z, y, x, angles of rotation
        def rotate(z, y, x, dphi, detha)
          @atoms.each do |key, atom|
            atom.rotate(z, y, x, dphi, detha)
          end
        end

        # Draws a specie.
        # Input:
        #  - XML stream
        #  - current index of specie (or 'molecule' in GChemPaint)
        def draw(xml, specie_index, shift_y)
          xml.molecule('id' => specie_index) do
            @atoms.each do |atom, atom_wide|
              xml.atom('id' => atom_wide.id, 'element' => atom_wide.name) do
                # A very armored concrete. Holy inquisition is on the way.
                xml.position('x' => atom_wide.x * 10e11 + 200, 'y' => atom_wide.y * 10e11 + shift_y)
              end
            end
            (0...@bonds_amount).each do |i|
              if @bonds[i].is_bond?
                xml.bond('id' => "b#{i}", 'order' => @bonds[i].order,
                  'begin' => @bonds[i].atom_begin.id, 'end' => @bonds[i].atom_end.id)
              end
            end
          end
        end
      end

    end
  end
end
