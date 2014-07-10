# Provides relation rules between atom for diamond crystal lattice (Fd3m space
# group). See example of lattice at http://en.wikipedia.org/wiki/Diamond_cubic
# Current diamond crystal lattice is directed upwards by face 100
class Diamond < VersatileDiamond::Lattices::Base

  # Each lattice class should have relations source file and crystal properties source
  # file in common templates directory which located at
  # /analyzer/lib/generators/code/templates/phases

  # Describes relations which belongs to major diamond crystal carbon atom
  # @return [Hash] the information about crystal carbon
  def major_crystal_atom
    crystal_atom.merge({
      relations: [bond_front_110, bond_front_110, bond_cross_110, bond_cross_110]
    })
  end

  # Describes relations and dangling bonds which belongs to surface diamond crystal
  # carbon atom
  #
  # @return [Hash] the information about surface carbon
  def surface_crystal_atom
    crystal_atom.merge({
      relations: [bond_cross_110, bond_cross_110],
      danglings: [ActiveBond.property]
    })
  end

private

  Node = VersatileDiamond::Lattice::Node

  # Detects opposite relation on same lattice
  # @param [Concepts::Bond] the relation between atoms in lattice
  # @raise [UndefinedRelation] if relation is invalid for current lattice
  # @return [Concepts::Bond] the reverse relation
  def same_lattice_opposite_relation(relation)
    if relation.face == 110
      relation.cross
    elsif relation.face == 100
      relation.class[face: 100, dir: relation.dir]
    else
      raise UndefinedRelation, relation
    end
  end

  # No have rules described relations with another lattice
  # @raise [UndefinedRelation]
  def other_lattice(relation)
    raise UndefinedRelation, relation
  end

  # Provides compositions of inference rules for found position relations in
  # current crystal lattice
  #
  # @return [Hash] the keys of hash keys are lists of relations by which to
  #   search for a new relation, and values is result relationship
  def inference_rules
    {
      [front_110, cross_110] => position_front_100,
      [cross_110, front_110] => position_cross_100,
      # [front_110, front_110] => position_111,
      # [cross_110, cross_110] => position_111,
    }
  end

  # Provides information on the maximum possible number of relations of diamond crystal
  # lattice for each individual atom
  #
  # @return [Hash] the hash where keys are relation options and values are maximum
  #   numbers of correspond relations
  def crystal_relations_limit
    {
      front_110 => 2,
      cross_110 => 2,
      front_100 => 2,
      cross_100 => 2,
    }
  end

  # Gets faces of crystal along that direction does not change
  # @return [Array] the array of faces that are flatten
  def flatten_faces
    [100]
  end

  # Gets the default height of surface in atom layers
  # For diamond should be at least three layers for bond between each one the all atoms
  # @return [Integer] the number of atomic layers
  def default_surface_height
    3
  end

  # Setups common crystal atom of diamond lattice. Atom should presents in config file
  # (or need to use internal periodic table).
  #
  # @return [Hash] the hash of properties of crystal atom
  def crystal_atom
    {
      atom_name: :C,
      valence: 4
    }
  end

  # @return [Float] a length of bond o_O
  def bond_length
    1.54e-10
  end

  # @return [Float] a shift along x-axis
  def dx
    bond_length * Math::sqrt(8.0 / 3.0)
  end

  # @return [Float] a shift along y-axis
  def dy
    bond_length * Math::sqrt(8.0 / 3.0)
  end

  # @return [Float] a shift along z-axis
  def dz
    bond_length * Math::sqrt(1.0 / 3.0)
  end

public

  # Lets us to count coordinates of atom on MatrixLayout
  def coords(matrix_layout, atom)
    node = matrix_layout[atom]
    node.atom.z = node.z * dz
    node.atom.y = dy * (node.y + (node.z / 2.0).truncate)
    node.atom.x = dx * (node.x + (node.z / 2.0).truncate)
    if node.z % 2 == 1
      node.atom.y -= dx / 2 if node.z < 0
      node.atom.x += dy / 2 if node.z > 0
    end
  end

end
