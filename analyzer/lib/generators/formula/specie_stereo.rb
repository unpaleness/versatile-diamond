module VersatileDiamond
  module Generators
    module Formula

      # Takes responsibility for all geometry of specie
      class SpecieStereo

        SIZE_MULTI = 10e11
        BOND_UNDIRECTED = 1.7e-10

        # Provides conersion from angstrem to pixels
        # @param [Float] some value in angstrems
        def self.to_p(figure)
          figure * SIZE_MULTI
        end

        # @param [Specie] current specie
        def initialize(specie)
          @specie = specie
          centering
          rotate(-Math::PI * 3 / 8, 0.0, Math::PI * 4 / 10)
          @z_max, @z_min, @y_max, @y_min, @x_max, @x_min = *measures
        end

        # Provides information about y measure of specie
        # @return [Float] y-size
        def y_size
          @y_max - @y_min
        end

        # Provides information about x measure of specie
        # @return [Float] x-size
        def x_size
          @x_max - @x_min
        end

        # Locates center of the spec
        # @return [Float, Float, Float] coordinates of spec's center
        def center
          z = y = x = 0.0
          @specie.atoms.each do |key, atom|
            z, y, x = z + atom.p[0], y + atom.p[1], x + atom.p[2]
          end
          amount = @specie.atoms.size
          [z / amount, y / amount, x / amount]
        end

        # Moves center and other atom in the way where center should be (0; 0; 0)
        def centering
          dz, dy, dx = center
          @specie.atoms.each do |key, atom|
            atom.p[0] -= dz
            atom.p[1] -= dy
            atom.p[2] -= dx
          end
        end

        # Counts 3-dimentional measures of the specie
        # @return [Float, Float, Float] z-size, y-size, x-size
        def measures
          z_max = z_min = y_max = y_min = x_max = x_min = 0.0
          @specie.atoms.each do |key, atom|
            z_max = atom.p[0] if atom.p[0] > z_max
            z_min = atom.p[0] if atom.p[0] < z_min
            y_max = atom.p[1] if atom.p[1] > y_max
            y_min = atom.p[1] if atom.p[1] < y_min
            x_max = atom.p[2] if atom.p[2] > x_max
            x_min = atom.p[2] if atom.p[2] < x_min
          end
          [z_max, z_min, y_max, y_min, x_max, x_min]
        end

        # Rotates the spec on some degree by axises: Oz, Oy and Ox
        # @param [Float] phi
        # @param [Float] etha
        # @param [Float] psi
        def rotate(phi, etha, psi)
          @specie.atoms.each do |key, atom|
            atom.p[0], atom.p[1], atom.p[2] =
              *Stereo::rotate(atom.p[0], atom.p[1], atom.p[2], phi, etha, psi)
          end
        end

        # Counts coordinates of the third point with known first and second and
        # distance from second to third
        # @param [Array] z, y, x coordinates of first point
        # @param [Array] z, y, x coordinates of second point
        # @param [Float] distance from second to third point
        def third_point(first, second, length23)
          dcoord = [nil, nil, nil]
          dcoord.each_with_index do |_, index|
            dcoord[index] = second[index] - first[index]
          end
          length12 = dcoord.inject(0.0) do |acc, dif|
            acc + dif * dif
          end
          length12 = length12 ** (1.0 / 2)
          length13 = length12 + length23
          sim_coef = length13 / length12
          [first[0] + dcoord[0] * sim_coef, first[1] + dcoord[1] * sim_coef,
            first[2] + dcoord[2] * sim_coef]
        end

        # Lets us count atom's coordinates with known one or two neighbours of atom
        # connected with current
        # @overload count_atom_by_one_or_two_atoms(A)
        #  @param [Atom] a single neighbour of parent
        #  @param [Atom] parent atom
        # @overload count_atom_by_one_or_two_atoms(A, B)
        #  @param [Atom] first neighbour of parent
        #  @param [Atom] second neighbour of parent
        #  @param [Atom] parent atom
        # @return [Float, Float, Float] coordinates of current atom
        def count_atom_by_one_or_two_atoms(atom_parent_neighbours, atom_parent)
          # neighbours_center ----- parent ----- sought-for atom
          neighbours_center = [nil, nil, nil]
          result = [nil, nil, nil]
          # finding center of neighbours
          if atom_parent_neighbours.size == 1
            neighbours_center = atom_parent_neighbours[0].p
          elsif atom_parent_neighbours.size == 2
            neighbours_center.each_with_index do |coord, index|
              neighbours_center[index] = (atom_parent_neighbours[0].p[index] +
                atom_parent_neighbours[1].p[index]) / 2
            end
          else
            raise ArgumentExeption, 'Wrong number of neighbours (must be 1 or 2)'
          end
          #
          puts atom_parent_neighbours.size
          third_point(neighbours_center, atom_parent.p, BOND_UNDIRECTED)
        end

        # Leads triangle of atoms to plane XOY, one vertex must be on O(0; 0; 0), one
        # edge must lie on OX
        # @param [Atom] first neighbour of parent, it should be led to O(0; 0; 0),
        # @param [Atom] second neighbour of parent, should be led to somewhere on xOy,
        # @param [Atom] third neighbour of parent, should be led to Ox
        # @param [Atom] parent atom
        # @return [Float, Float, Float] z, y, x - coordinates of sought for atom
        def count_atom_by_triangle(atomA, atomB, atomC, parent)
          # recording old values of coordinates of atom A
          z, y, x = atomA.p
          z, y, x = -z, -y, -x
          result_atom = Formula::Atom.new(nil)
          atoms = [atomA, atomB, atomC, parent, result_atom]
          # moving all coordinates by the values of A-coordinates
          atoms.each do |atom|
            atom.inc_coords(z, y, x)
          end
          # moving backwards
          z, y, x = -z, -y, -x
          atoms.each do |atom|
            atom.inc_coords(z, y, x)
          end
          # counting angle phi to rotate around Oz
          puts atoms.size
          result_atom.p
        end

        # Counts coordinates of atom with undirected bonds
        # @param [Atom] atom
        def undirected_atom_coordinates(atom)
          # if atom has one undirected bond
          puts @specie.spec.name
          if atom.bonds.count == 1
            atom_parent = atom.bonds.first[0]
            atom_parent_neighbours = []
            # recording all crystalic neighbours of parent to array
            atom_parent.bonds.each do |at, bond|
              if bond.bond? && bond.bond.face && bond.bond.dir
                atom_parent_neighbours << at
              end
            end
            # if bonded atom has one or two other bonds (current + others)
            if atom_parent_neighbours.count < 3
              atom.set_coords(
                count_atom_by_one_or_two_atoms(atom_parent_neighbours, atom_parent))
            # if we have three or more bonds take first three and then make
            # caclulations
            else
              atom.set_coords(
                count_atom_by_triangle(*atom_parent_neighbours[0..2], atom_parent))
            end
          # if atom has 2 undirected bonds
          elsif atom.bonds.count == 2
          # if atom has more then 2 undirected bonds
          else
          end
            #
        end

        # Counts coordinates of all undirected atoms
        def count_undirected_atoms_coordinates
          @specie.atoms.each do |_, atom|
            undirected = true
            atom.bonds.each do |_, bond|
              if bond.bond? && bond.bond.face && bond.bond.dir
                undirected = false
              end
            end
            undirected_atom_coordinates(atom) if undirected
          end
        end
      end

    end
  end
end
