TEMPLATE = app
CONFIG -= app_bundle
CONFIG -= qt

#QMAKE_CXXFLAGS += -D_GLIBCXX_DEBUG_PEDANTIC
#QMAKE_CXXFLAGS += -DNDEBUG
#QMAKE_CXXFLAGS += -DPRINT

QMAKE_CXXFLAGS += -std=c++11
QMAKE_CXXFLAGS += -DTHREADS_NUM=1

#QMAKE_CXXFLAGS += -fopenmp -DPARALLEL -DTHREADS_NUM=3
#LIBS += -fopenmp -lstdc++

#QMAKE_CXXFLAGS += -openmp -DPARALLEL -DTHREADS_NUM=3
#LIBS += -L/opt/intel/lib/intel64/ -liomp5 -openmp

SOURCES += main.cpp \
    atoms/atom.cpp \
    atoms/lattice.cpp \
    generations/atoms/specified_atom.cpp \
    generations/finder.cpp \
    generations/handbook.cpp \
    generations/phases/diamond.cpp \
    generations/phases/diamond_relations.cpp \
    generations/phases/phase_boundary.cpp \
    generations/reactions/lateral/dimer_formation_at_end.cpp \
    generations/reactions/lateral/dimer_formation_in_middle.cpp \
    generations/reactions/typical/ads_methyl_to_dimer.cpp \
    generations/reactions/typical/des_methyl_from_bridge.cpp \
    generations/reactions/typical/dimer_drop.cpp \
    generations/reactions/typical/dimer_formation.cpp \
    generations/reactions/typical/dimer_formation_near_bridge.cpp \
    generations/reactions/typical/high_bridge_stand_to_one_bridge.cpp \
    generations/reactions/typical/high_bridge_to_two_bridges.cpp \
    generations/reactions/typical/methyl_on_dimer_hydrogen_migration.cpp \
    generations/reactions/typical/methyl_to_high_bridge.cpp \
    generations/reactions/typical/next_level_bridge_to_high_bridge.cpp \
    generations/reactions/ubiquitous/surface_activation.cpp \
    generations/reactions/ubiquitous/surface_deactivation.cpp \
    generations/species/base/bridge.cpp \
    generations/species/base/methyl_on_bridge.cpp \
    generations/species/base/methyl_on_dimer.cpp \
    generations/species/sidepiece/dimer.cpp \
    generations/species/specific/bridge_crs.cpp \
    generations/species/specific/bridge_crs_cti_cli.cpp \
    generations/species/specific/bridge_ctsi.cpp \
    generations/species/specific/dimer_cri_cli.cpp \
    generations/species/specific/dimer_crs.cpp \
    generations/species/specific/high_bridge.cpp \
    generations/species/specific/methyl_on_bridge_cbi_cmu.cpp \
    generations/species/specific/methyl_on_dimer_cls_cmu.cpp \
    generations/species/specific/methyl_on_dimer_cmsu.cpp \
    generations/species/specific/methyl_on_dimer_cmu.cpp \
    mc/base_events_container.cpp \
    mc/common_mc_data.cpp \
    mc/counter.cpp \
    mc/events_container.cpp \
    mc/multi_events_container.cpp \
    mc/random_generator.cpp \
    phases/amorph.cpp \
    phases/crystal.cpp \
    reactions/lateral_reaction.cpp \
    reactions/ubiquitous_reaction.cpp \
    species/base_spec.cpp \
    species/lateral_spec.cpp \
    species/parent_spec.cpp \
    species/specific_spec.cpp \
    tests/support/open_diamond.cpp \
    tools/common.cpp \
    tools/lockable.cpp \
    tools/scavenger.cpp \
    generations/reactions/lateral/dimer_drop_at_end.cpp \
    generations/reactions/lateral/dimer_drop_in_middle.cpp \
    generations/species/base/two_bridges.cpp \
    generations/species/specific/two_bridges_cbrs.cpp \
    generations/reactions/typical/two_bridges_to_high_bridge.cpp \
    species/components_keeper.cpp \
    generations/species/base/bridge_with_dimer.cpp \
    generations/reactions/typical/dimer_drop_near_bridge.cpp \
    generations/reactions/typical/bridge_with_dimer_to_high_bridge_and_dimer.cpp \
    generations/reactions/typical/high_bridge_stand_to_dimer.cpp \
    generations/species/specific/dimer_crs_cli.cpp \
    generations/reactions/typical/high_bridge_to_methyl.cpp \
    generations/reactions/typical/migration_down_at_dimer.cpp \
    generations/species/specific/methyl_on_bridge_cbi_cmsu.cpp \
    generations/reactions/typical/migration_down_in_gap.cpp \
    generations/species/specific/methyl_on_bridge_cbi_cmssu.cpp \
    generations/species/specific/bridge_with_dimer_cdli.cpp \
    generations/species/specific/bridge_with_dimer_cbti_cbrs_cdli.cpp \
    generations/reactions/typical/des_methyl_from_111.cpp \
    generations/species/specific/methyl_on_111_cmu.cpp \
    generations/species/specific/methyl_on_111_cmsu.cpp \
    generations/reactions/typical/migration_down_at_dimer_from_111.cpp \
    generations/reactions/typical/migration_down_in_gap_from_111.cpp \
    generations/species/specific/methyl_on_111_cmssu.cpp \
    generations/species/specific/methyl_on_bridge_cbs_cmsu.cpp \
    generations/reactions/typical/form_two_bond.cpp \
    generations/reactions/typical/migration_down_at_dimer_from_high_bridge.cpp \
    generations/species/specific/high_bridge_cms.cpp \
    generations/reactions/typical/migration_down_in_gap_from_high_bridge.cpp \
    generations/reactions/typical/des_methyl_from_dimer.cpp \
    generations/reactions/typical/ads_methyl_to_111.cpp \
    generations/reactions/typical/migration_down_at_dimer_from_dimer.cpp \
    generations/species/specific/methyl_on_dimer_cmssu.cpp \
    generations/reactions/typical/migration_down_in_gap_from_dimer.cpp \
    tools/saver/mol_saver.cpp \
    tools/saver/mol_accumulator.cpp \
    tools/saver/atom_info.cpp \
    tools/saver/bond_info.cpp \
    generations/atoms/c.cpp \
    tools/saver/sdf_saver.cpp \
    tools/saver/volume_saver_factory.cpp

HEADERS += \
    atoms/atom.h \
    atoms/lattice.h \
    atoms/neighbours.h \
    generations/atoms/c.h \
    generations/atoms/specified_atom.h \
    generations/builders/atom_builder.h \
    generations/finder.h \
    generations/handbook.h \
    generations/names.h \
    generations/phases/diamond.h \
    generations/phases/diamond_atoms_iterator.h \
    generations/phases/diamond_relations.h \
    generations/phases/phase_boundary.h \
    generations/reactions/concretizable_role.h \
    generations/reactions/laterable_role.h \
    generations/reactions/lateral.h \
    generations/reactions/lateral/dimer_formation_at_end.h \
    generations/reactions/lateral/dimer_formation_in_middle.h \
    generations/reactions/local.h \
    generations/reactions/registrator.h \
    generations/reactions/typical.h \
    generations/reactions/typical/ads_methyl_to_dimer.h \
    generations/reactions/typical/des_methyl_from_bridge.h \
    generations/reactions/typical/dimer_drop.h \
    generations/reactions/typical/dimer_formation.h \
    generations/reactions/typical/dimer_formation_near_bridge.h \
    generations/reactions/typical/high_bridge_stand_to_one_bridge.h \
    generations/reactions/typical/high_bridge_to_two_bridges.h \
    generations/reactions/typical/methyl_on_dimer_hydrogen_migration.h \
    generations/reactions/typical/methyl_to_high_bridge.h \
    generations/reactions/typical/next_level_bridge_to_high_bridge.h \
    generations/reactions/ubiquitous.h \
    generations/reactions/ubiquitous/data/activation_data.h \
    generations/reactions/ubiquitous/data/deactivation_data.h \
    generations/reactions/ubiquitous/surface_activation.h \
    generations/reactions/ubiquitous/surface_deactivation.h \
    generations/species/base.h \
    generations/species/base/bridge.h \
    generations/species/base/methyl_on_bridge.h \
    generations/species/base/methyl_on_dimer.h \
    generations/species/sidepiece.h \
    generations/species/sidepiece/dimer.h \
    generations/species/specific/bridge_crs.h \
    generations/species/specific/bridge_crs_cti_cli.h \
    generations/species/specific/bridge_ctsi.h \
    generations/species/specific/dimer_cri_cli.h \
    generations/species/specific/dimer_crs.h \
    generations/species/specific/high_bridge.h \
    generations/species/specific/methyl_on_bridge_cbi_cmu.h \
    generations/species/specific/methyl_on_dimer_cls_cmu.h \
    generations/species/specific/methyl_on_dimer_cmsu.h \
    generations/species/specific/methyl_on_dimer_cmu.h \
    mc/base_events_container.h \
    mc/common_mc_data.h \
    mc/counter.h \
    mc/events_container.h \
    mc/mc.h \
    mc/multi_events_container.h \
    mc/random_generator.h \
    phases/amorph.h \
    phases/crystal.h \
    phases/crystal_atoms_iterator.h \
    reactions/concrete_lateral_reaction.h \
    reactions/concrete_typical_reaction.h \
    reactions/lateral_reaction.h \
    reactions/reaction.h \
    reactions/spec_reaction.h \
    reactions/targets.h \
    reactions/typical_reaction.h \
    reactions/ubiquitous_reaction.h \
    species/additional_atoms_wrapper.h \
    species/atom_shift_wrapper.h \
    species/atoms_swap_wrapper.h \
    species/base_spec.h \
    species/dependent_spec.h \
    species/lateral_spec.h \
    species/multi_inheritance_dispatcher.h \
    species/parent_spec.h \
    species/reactant.h \
    species/source_spec.h \
    species/spec_class_builder.h \
    species/specific_spec.h \
    tests/support/open_diamond.h \
    tools/collector.h \
    tools/common.h \
    tools/creator.h \
    tools/debug_print.h \
    tools/lockable.h \
    tools/scavenger.h \
    tools/typed.h \
    tools/vector3d.h \
    generations/reactions/lateral/dimer_drop_at_end.h \
    generations/reactions/lateral/dimer_drop_in_middle.h \
    generations/species/base/two_bridges.h \
    generations/species/specific/two_bridges_cbrs.h \
    generations/reactions/typical/two_bridges_to_high_bridge.h \
    species/reactants_keeper.h \
    species/components_keeper.h \
    species/component_spec.h \
    generations/species/overall.h \
    generations/species/base/bridge_with_dimer.h \
    generations/reactions/typical/dimer_drop_near_bridge.h \
    generations/reactions/typical/bridge_with_dimer_to_high_bridge_and_dimer.h \
    generations/species/specific_role.h \
    generations/species/base_specific.h \
    generations/reactions/typical/high_bridge_stand_to_dimer.h \
    generations/species/specific/dimer_crs_cli.h \
    generations/reactions/typical/high_bridge_to_methyl.h \
    generations/reactions/typical/migration_down_at_dimer.h \
    generations/species/specific/methyl_on_bridge_cbi_cmsu.h \
    generations/species/empty_dependent.h \
    generations/species/empty_specific.h \
    generations/species/base/shifted_dimer.h \
    generations/reactions/typical/migration_down_in_gap.h \
    generations/species/specific/methyl_on_bridge_cbi_cmssu.h \
    generations/species/specific/bridge_with_dimer_cdli.h \
    generations/species/specific/bridge_with_dimer_cbti_cbrs_cdli.h \
    generations/reactions/typical/des_methyl_from_111.h \
    generations/species/specific/methyl_on_111_cmu.h \
    generations/species/specific/methyl_on_111_cmsu.h \
    generations/reactions/typical/migration_down_at_dimer_from_111.h \
    generations/reactions/typical/lookers/near_methyl_on_bridge.h \
    generations/reactions/typical/lookers/near_methyl_on_bridge_cbi.h \
    generations/reactions/typical/lookers/near_methyl_on_111.h \
    generations/reactions/typical/migration_down_in_gap_from_111.h \
    generations/species/specific/methyl_on_111_cmssu.h \
    generations/reactions/typical/lookers/near_gap.h \
    generations/reactions/typical/lookers/near_part_of_gap.h \
    generations/reactions/typical/lookers/near_activated_dimer.h \
    generations/species/specific/methyl_on_bridge_cbs_cmsu.h \
    generations/reactions/typical/form_two_bond.h \
    generations/reactions/typical/migration_down_at_dimer_from_high_bridge.h \
    generations/reactions/typical/lookers/near_high_bridge.h \
    generations/species/specific/high_bridge_cms.h \
    generations/reactions/typical/migration_down_in_gap_from_high_bridge.h \
    generations/reactions/ubiquitous/local/methyl_on_bridge_activation.h \
    generations/reactions/ubiquitous/local/methyl_on_bridge_deactivation.h \
    generations/reactions/typical/des_methyl_from_dimer.h \
    generations/reactions/typical/ads_methyl_to_111.h \
    generations/reactions/typical/migration_down_at_dimer_from_dimer.h \
    generations/reactions/typical/lookers/near_methyl_on_dimer.h \
    generations/species/specific/methyl_on_dimer_cmssu.h \
    generations/reactions/typical/migration_down_in_gap_from_dimer.h \
    tools/saver/mol_saver.h \
    tools/saver/mol_accumulator.h \
    tools/saver/atom_info.h \
    tools/saver/bond_info.h \
    tools/saver/sdf_saver.h \
    tools/factory.h \
    tools/saver/volume_saver_factory.h
