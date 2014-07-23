module VersatileDiamond
  module Generators
    module Formula

      # Creates class 'Specie' for formula
      class Specie

        # include Stereo
        include VersatileDiamond::Lattice

        attr_reader :spec, :atoms_amount, :bonds_amount, :atoms, :bonds, :geom

        def initialize(spec)
          @spec = spec
          collect_atoms
          collect_bonds
          bind_bonds_and_atoms
          @matlay = MatrixLayout.new
          @matlay[0, 0, 0].atom = @atoms.first[1]
          spread(@atoms.first[1], 20)
          @geom = SpecieStereo.new(self)
          # binding.pry
        end

        # Collects all atoms to appropriate hash
        # @return [Integer] total amount of atoms in current specie
        def collect_atoms
          pairs = @spec.links.keys.map { |atom| [atom, Formula::Atom.new(atom)] }
          @atoms = Hash[pairs]
        end

        # Collects all bonds to appropriate array
        # @return [Inreger] total amount of bonds in current specie
        def collect_bonds
          @bonds = []
          # process every record in this hash
          @spec.links.each do |key, pairs|
            # adding bonds to array of bonds
            pairs.each do |a, rel|
              # create a new candidate bond if it was not created
              if !already_created(key, a)
                @bonds << Formula::Bond.new(@atoms[key], @atoms[a], rel)
              end
            end
          end
          @bonds.size
        end

        # Adds references to bonds to every atom
        def bind_bonds_and_atoms
          @atoms.each do |atom, atom_wide|
            @bonds.each do |bond|
              # if current atom id as equal to atom id of begin of bond
              if atom_wide.id == bond.atom_begin.id
                atom_wide.bonds[bond.atom_end] = bond
              end
            end
          end
        end

        # Checks wheather bond was created or not and adds 'order' parameter to bond
        # in case of duplication
        # Reverse bonds are going to be removed completely!!!
        # @return [Logical] true/false value
        def already_created(from, to)
          target = @bonds.find do |bond|
            bond.atom_begin == @atoms[from] && bond.atom_end == @atoms[to]
          end
          target && (target.order += 1)
        end

        # Translates info about spec into string
        # @return [String]
        def to_s
          @atoms.reduce("#{@spec.name}\n") do |acc, (_, atom)|
            acc << " #{atom.to_s}"
          end
        end

        # Recursively locates atoms' positions on the lattice
        # @param [Atom, Atom, Integer] previous atom, considarating atom and
        # iteration limit
        # @return [Boolean] either was spreading successful or not
        def spread(atom, iter)
          # Debugging info
          # (0...(20-iter)).each { |i| print ' ' }
          # puts "\033[33miteration #{iter}\033[0m; #{@matlay[atom].coords}; atom_id = #{atom.id}{"
          # atom.bonds.each do |at, bond|
          #   (0...(21-iter)).each { |i| print ' ' }
          #   print "#{bond.bond.face}"
          #   bond.bond? ? print('--') : print('::')
          #   puts "#{bond.bond.dir} to #{at.id}"
          # end
          #
          # Telling depth to node
          @matlay[atom].depth = iter
          # When iteration limit is reached
          return false if iter == 0
          # Otherwise, we assume that spreading will implement correct
          result = true
          # enumerate all bonds of current atom
          atom.bonds.each do |atom_end, bond|
            # shows wheather our journey is successful
            loop_success = false
            # if destination atom belongs to lattice
            if atom_end.atom.lattice
              # shows either there are some free nodes or not
              are_free_nodes = false
              # check for free nodes and if there is desired atom_end in lattice
              @matlay.public_send("#{bond.bond.dir}_#{bond.bond.face}", @matlay[atom]).each do |node|
                loop_success = true if node.atom == atom_end
                are_free_nodes = true if node.atom == nil
              end
              # if loop is not closed and there are some free nodes try it
              if loop_success == false && are_free_nodes == true
                # for every destination of bond
                @matlay.public_send("#{bond.bond.dir}_#{bond.bond.face}", @matlay[atom]).each do |node|
                  # if node is free
                  unless node.atom
                    # assumption that atom should be here
                    node.atom = atom_end
                    # checking this assumption
                    if @matlay.unique? && spread(atom_end, iter - 1)
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
          # In case of success we should count atoms' coordinates
          if result
            if atom.atom.lattice
              atom.atom.lattice.instance.class.coords(@matlay, atom)
            else
              # Cybertrash!!!
              # atom.set_coords(0.0, 0.0, 0.0)
              # if atom has a single undirected bond
              if atom.bonds.count == 1

              # otherwise
              else
              end
            end
          # Otherwise we shoule remove all nodes below this iteration
          else
            @matlay.each do |node|
              node.atom = nil if node.depth < iter
            end
          end
          # Debugging info
          # (0...(20-iter)).each { |i| print ' ' }
          # print '}, '
          # result ? print("\033[32m") : print("\033[31m")
          # puts "result = #{result}\033[0m"
          #
          result
        end

        # Draws a specie
        # @param [XML::Builder, Integer, Float, Float] xml-stream, index of specie,
        # x alignment, y position from the very top
        def draw(xml, specie_index, x_shift, y_position)
          xml.molecule('id' => specie_index) do
            @atoms.each do |atom, atom_wide|
              xml.atom('id' => atom_wide.id, 'element' => atom.name) do
                # A very armored concrete. Holy inquisition is on the way.
                # if atom.lattice != nil
                #   puts "(#{atom_wide.z / atom.lattice.instance.class.dz}; "\
                #     "#{atom_wide.y / atom.lattice.instance.class.dy}; "\
                #     "#{atom_wide.x / atom.lattice.instance.class.dx})"
                # end
                xml.position('x' => SpecieStereo::to_p(atom_wide.x) + x_shift,
                  'y' => SpecieStereo::to_p(atom_wide.y) + y_position)
              end
            end

            @bonds.each_with_index do |bond, i|
              if bond.bond?
                xml.bond('id' => "b#{i}", 'order' => bond.order,
                  'begin' => bond.atom_begin.id, 'end' => bond.atom_end.id)
              end
            end
          end
        end
      end

    end
  end
end
