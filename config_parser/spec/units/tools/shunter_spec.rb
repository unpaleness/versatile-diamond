require 'spec_helper'

module VersatileDiamond
  module Tools

    describe Shunter do
      let(:keyname_error) { Chest::KeyNameError }

      describe "#organize_dependecies!" do
        def store_and_organize_reactions
          Config.gas_concentration(hydrogen_ion, 1, 'mol/l')
          Config.gas_temperature(1000, 'K')
          Config.surface_temperature(500, 'K')

          surface_activation.rate = 0.1
          surface_activation.activation = 0
          surface_deactivation.rate = 0.2
          surface_deactivation.activation = 0

          methyl_activation.rate = 0.3
          methyl_activation.activation = 0
          methyl_deactivation.rate = 0.4
          methyl_deactivation.activation = 0

          methyl_desorption.rate = 1
          methyl_desorption.activation = 0

          hydrogen_migration.rate = 2
          hydrogen_migration.activation = 0
          hydrogen_migration.reverse.rate = 3
          hydrogen_migration.reverse.activation = 1e3

          dimer_formation.rate = 4
          dimer_formation.activation = 0
          dimer_formation.reverse.rate = 5
          dimer_formation.reverse.activation = 2e3

          [
            surface_activation, surface_deactivation,
            methyl_activation, methyl_deactivation, methyl_desorption,
            methyl_desorption.reverse, # synthetics
            hydrogen_migration, hydrogen_migration.reverse,
            dimer_formation, dimer_formation.reverse
          ].each { |reaction| Chest.store(reaction) }

          Shunter.organize_dependecies!
        end

        describe "#organize_specs_dependencies!" do
          before(:each) do
            [
              methane_base, bridge_base, dimer_base, high_bridge_base,
              methyl_on_bridge_base, methyl_on_dimer_base
            ].each { |spec| Chest.store(spec) }

            Shunter.organize_dependecies!
          end

          it { methane_base.parent.should be_nil }
          it { bridge_base.parent.should be_nil }
          it { dimer_base.parent.should == bridge_base }
          it { methyl_on_bridge_base.parent.should == bridge_base }
          it { high_bridge_base.parent.should == methyl_on_bridge_base }
          it { methyl_on_dimer_base.parent.should == dimer_base }
        end

        describe "#organize_specific_spec_dependencies!" do
          before(:each) { store_and_organize_reactions }

          describe "#purge_null_rate_reactions!" do
            it { expect { Chest.reaction('forward methyl desorption') }.
              not_to raise_error }
            it { expect { Chest.reaction('reverse methyl desorption') }.
              to raise_error keyname_error }
          end

          describe "#collect_specific_specs!" do
            describe "surface activation" do
              it { Chest.atomic_spec(:H).should be_a(Concepts::AtomicSpec) }
              it { Chest.specific_spec(:'hydrogen(h: *)').
                should be_a(Concepts::SpecificSpec) }
            end

            describe "surface deactivation" do
              it { Chest.active_bond(:*).should be_a(Concepts::ActiveBond) }
            end

            describe "methyl activation" do
              it { Chest.specific_spec(:'methyl_on_bridge()').
                should be_a(Concepts::SpecificSpec) }
            end

            describe "methyl deactivation" do
              it { Chest.specific_spec(:'methyl_on_bridge(cm: *)').
                should be_a(Concepts::SpecificSpec) }
            end

            describe "surface deactivation" do
              it { Chest.active_bond(:*).should be_a(Concepts::ActiveBond) }
            end

            describe "methyl desorption" do
              it { Chest.specific_spec(:'methyl_on_bridge(cm: i, cm: u)').
                should be_a(Concepts::SpecificSpec) }
            end

            describe "forward hydrogen migration" do
              it { Chest.specific_spec(:'dimer(cr: *)').
                should be_a(Concepts::SpecificSpec) }
              it { Chest.specific_spec(:'methyl_on_dimer()').
                should be_a(Concepts::SpecificSpec) }
            end

            describe "reverse hydrogen migration" do
              it { Chest.specific_spec(:'dimer()').
                should be_a(Concepts::SpecificSpec) }
              it { Chest.specific_spec(:'methyl_on_dimer(cm: *)').
                should be_a(Concepts::SpecificSpec) }
            end

            describe "forward dimer formation" do
              it { Chest.specific_spec(:'bridge(ct: *)').
                should be_a(Concepts::SpecificSpec) }
              it { Chest.specific_spec(:'bridge(ct: *, ct: i)').
                should be_a(Concepts::SpecificSpec) }
            end

            describe "reverse dimer formation" do
              it { Chest.specific_spec(:'dimer(cl: i)').
                should be_a(Concepts::SpecificSpec) }
            end
          end

          describe "specific spec dependencies" do
            it { Chest.specific_spec(:'bridge(ct: *)').parent.
              should be_nil }
            it { Chest.specific_spec(:'bridge(ct: *, ct: i)').parent.
              should == Chest.specific_spec(:'bridge(ct: *)') }

            it { Chest.specific_spec(:'dimer()').parent.should be_nil }
            it { Chest.specific_spec(:'dimer(cr: *)').parent.
              should == Chest.specific_spec(:'dimer()') }
            it { Chest.specific_spec(:'dimer(cl: i)').parent.
              should == Chest.specific_spec(:'dimer()') }

            it { Chest.specific_spec(:'methyl_on_bridge()').
              parent.should be_nil }
            it { Chest.specific_spec(:'methyl_on_bridge(cm: i, cm: u)').
              parent.should == Chest.specific_spec(:'methyl_on_bridge()') }

            it { Chest.specific_spec(:'methyl_on_dimer()').parent.should be_nil }
            it { Chest.specific_spec(:'methyl_on_dimer(cm: *)').
              parent.should == Chest.specific_spec(:'methyl_on_dimer()') }
          end

          describe "swapping reaction specs" do
            let(:same) { Chest.specific_spec(:'hydrogen(h: *)') }

            it { surface_activation.source.should include(same) }
            it { surface_deactivation.source.should include(same) }
            it { methyl_activation.source.should include(same) }
            it { methyl_deactivation.source.should include(same) }
          end
        end

        describe "#check_reactions_for_duplicates" do
          let(:reaction_duplicate) { Shunter::ReactionDuplicate }

          shared_examples_for "duplicate or not" do
            before(:each) do
              Config.gas_temperature(1000, 'K')
              Config.surface_temperature(500, 'C')
            end

            describe "duplicate" do
              before do
                Chest.store(reaction)
                Chest.store(same)
              end

              it { expect { Shunter.organize_dependecies! }.
                to raise_error reaction_duplicate }
            end

            describe "not duplicate" do
              before do
                reaction.reverse.rate = reaction.rate
                reaction.reverse.activation = reaction.activation

                Chest.store(reaction)
                Chest.store(reaction.reverse) # synthetics
              end

              it { expect { Shunter.organize_dependecies! }.not_to raise_error }
            end
          end

          it_behaves_like "duplicate or not" do
            let(:reaction) { surface_deactivation }
            let(:same) do
              Concepts::UbiquitousReaction.new(
                :forward, 'duplicate', sd_source.shuffle, sd_product)
            end

            before(:each) do
              Config.gas_concentration(hydrogen_ion, 1, 'mol/l')
              reaction.rate = 1
              same.rate = 10
              reaction.activation = same.activation = 0
            end
          end

          it_behaves_like "duplicate or not" do
            let(:reaction) { dimer_formation }
            let(:same) { reaction.duplicate('same') }

            before(:each) do
              reaction.rate = 2
              reaction.activation = 0
              # need before setup reaction properties and same later, because
              # same is child of reaction and not it's not instanced
              same.rate = 20
              same.activation = 1
            end
          end

          it_behaves_like "duplicate or not" do
            let(:same) { dimer_formation.lateral_duplicate('same', [on_end]) }
            let(:reaction) do
              dimer_formation.lateral_duplicate('lateral', [on_end])
            end

            before(:each) do
              reaction; same # creates children of dimer formation
              dimer_formation.rate = 3
              dimer_formation.activation = 0
            end
          end
        end

        describe "#purge_unused_specs!" do
          before(:each) do
            [
              methane_base, bridge_base, methyl_on_bridge_base, dimer_base,
              methyl_on_dimer_base, ethylene_base, chloride_bridge_base,
              high_bridge_base
            ].each { |spec| Chest.store(spec) }
            store_and_organize_reactions
          end

          it { expect { Chest.spec(:methane) }.to raise_error keyname_error }
          it { expect { Chest.spec(:ethylene) }.to raise_error keyname_error }
          it { expect { Chest.spec(:chloride_bridge) }.
            to raise_error keyname_error }
          it { expect { Chest.spec(:high_bridge) }.
            to raise_error keyname_error }

          it { expect { Chest.spec(:bridge) }.not_to raise_error }
          it { expect { Chest.spec(:methyl_on_bridge) }.not_to raise_error }
          it { expect { Chest.spec(:dimer) }.not_to raise_error }
          it { expect { Chest.spec(:methyl_on_dimer) }.not_to raise_error }
        end
      end
    end

  end
end