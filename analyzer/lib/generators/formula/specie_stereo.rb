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
          rotate(Math::PI / 8, 0.0, Math::PI / 3)
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

        # Lets us count atom's coordinates with known one or two neighbours of atom
        # connected with current
        # @overload count_atom_by_one_or_two_atoms(A)
        #  @param [Atom] a single atom
        # @overload count_atom_by_one_or_two_atoms(A, B)
        #  @param [Atom] first atom
        #  @param [Atom] second atom
        # @return [Float, Float, Float] coordinates of current atom
        def count_atom_by_one_or_two_atoms(atoms)
          if atoms.size == 1
          elsif atoms.size == 2
          else
            raise ArgumentExeption, 'Wrong number of atoms (must be 1 or 2)'
          end

        end

        # Leads triangle of atoms to plane XOY, one vertex must be on O(0; 0; 0), one
        # edge must lie on OX
        # @param [Array]
        # 0 - first atom, it should be led to O(0; 0; 0),
        # 1 - second atom, should be led to somewhere on xOy,
        # 2 - third atom, should be led to Ox
        # @return [Float, Float, Float, Float, Float, Float] z, y, x - coordinates of
        # A before moving; phi, etha, psi - angles by which triangle was rotated
        def count_atom_by_triangle(atoms)
          # recording old values of coordinates of atom A
          z, y, x = Atoms[0].p
          z, y, x = -z, -y, -x
          # moving all coordinates by the values of A-coordinates
          Atoms.each do |atom|
            atom.inc_coords(z, y, x)
          end
          # counting angle phi to rotate around Oz

        end

        # Counts coordinates of atom with undirected bonds
        # @param [Atom] atom
        def undirected_atom_coordinates(atom)
          atoms = []
          # if atom has one undirected bond
          if atom.bonds.count == 1
            atom.bonds.each do |at, bond|
              unless bond.bond.face || bond.bond.dir
                atoms << at
              end
            end
            # if bonded atom has one or two other bonds (current + others)
            if atom.bonds.count < 4
              atom.set_coords = count_atom_by_one_or_two_atoms(atoms)
            # if we have three or more bonds take first three and then make
            # caclulations
            else
              atom.set_coords = count_atom_by_triangle(atoms[0..2])
            end
          # if atom has 2 undirected bonds
          elsif atom.bonds.count == 2
          # if atom has more then 2 undirected bonds
          else
          end
            #
          end
        end

        # Counts coordinates of all undirected atoms
        def count_undirected_atoms_coordinates
          @specie.atoms.each do |_, atom|
            undirected = true
            atom.bonds.each do |_, bond|
              if bond.bond.face && bond.bond.dir
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
