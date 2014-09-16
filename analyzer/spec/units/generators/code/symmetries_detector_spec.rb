require 'spec_helper'

module VersatileDiamond
  module Generators
    module Code

      describe SymmetriesDetector, use: :engine_generator do
        shared_examples_for :check_symmetry do
          let(:detector) { generator.detectors_cacher.get(subject) }
          let(:generator) do
            stub_generator(base_specs: bases, specific_specs: specifics)
          end
          let(:symmetry_classes_names) do
            detector.symmetry_classes.map(&:base_class_name)
          end

          before { generator }

          it { expect(symmetry_classes_names).to match_array(symmetry_classes) }
          it 'check keynames of symmetric atoms' do
            concept = subject.spec
            atoms = concept.links.keys
            symmetric_atoms = atoms.select { |a| detector.symmetric_atom?(a) }
            keynames = symmetric_atoms.map { |a| concept.keyname(a) }
            expect(keynames).to match_array(symmetric_keynames)
          end
        end

        it_behaves_like :check_symmetry do
          subject { dept_bridge_base }
          let(:bases) do
            [
              dept_bridge_base,
              dept_dimer_base,
              dept_methyl_on_bridge_base,
              dept_methyl_on_dimer_base
            ]
          end
          let(:specifics) { [dept_activated_bridge] }
          let(:symmetry_classes) { [] }
          let(:symmetric_keynames) { [] }
        end

        it_behaves_like :check_symmetry do
          subject { dept_methyl_on_bridge_base }
          let(:bases) { [dept_bridge_base, dept_methyl_on_bridge_base] }
          let(:specifics) { [dept_activated_methyl_on_bridge] }
          let(:symmetry_classes) { [] }
          let(:symmetric_keynames) { [] }
        end

        it_behaves_like :check_symmetry do
          subject { dept_methyl_on_dimer_base }
          let(:bases) do
            [dept_bridge_base, dept_methyl_on_dimer_base, dept_methyl_on_bridge_base]
          end
          let(:specifics) { [dept_activated_methyl_on_dimer] }
          let(:symmetry_classes) { [] }
          let(:symmetric_keynames) { [] }
        end

        describe 'symmetric dimers' do
          subject { dept_dimer_base }
          let(:bases) { [dept_bridge_base, dept_dimer_base] }

          it_behaves_like :check_symmetry do
            let(:specifics) { [dept_twise_incoherent_dimer] }
            let(:symmetry_classes) { [] }
            let(:symmetric_keynames) { [] }
          end

          it_behaves_like :check_symmetry do
            let(:specifics) { [dept_activated_dimer, dept_twise_incoherent_dimer] }
            let(:symmetry_classes) do
              ['ParentsSwapWrapper<Empty<DIMER>, OriginalDimer, 0, 1>']
            end
            let(:symmetric_keynames) { [:cr, :cl] }
          end

          it_behaves_like :check_symmetry do
            let(:specifics) do
              [dept_twise_incoherent_dimer, dept_activated_incoherent_dimer]
            end
            let(:symmetry_classes) do
              ['ParentsSwapWrapper<Empty<DIMER>, OriginalDimer, 0, 1>']
            end
            let(:symmetric_keynames) { [:cr, :cl] }
          end

          it_behaves_like :check_symmetry do
            let(:specifics) { [dept_bottom_hydrogenated_activated_dimer] }
            let(:symmetry_classes) do
              [
                'AtomsSwapWrapper<Empty<DIMER>, 1, 2>',
                'ParentsSwapWrapper<Empty<DIMER>, OriginalDimer, 0, 1>',
                'AtomsSwapWrapper<ParentsSwapWrapper<Empty<DIMER>, OriginalDimer, 0, 1>, 1, 2>'
              ]
            end
            let(:symmetric_keynames) { [:cr, :cl, :crb, :clb, :_cr0, :_cr1] }
          end
        end

        describe 'dimer children' do
          let(:bases) { [dept_bridge_base, dept_dimer_base] }

          describe 'incoherent dimer' do
            let(:specifics) do
              [dept_activated_incoherent_dimer, dept_twise_incoherent_dimer]
            end

            it_behaves_like :check_symmetry do
              subject { dept_twise_incoherent_dimer }
              let(:symmetry_classes) do
                ['ParentProxy<OriginalDimer, SymmetricDimer, DIMER_CLi_CRi>']
              end
              let(:symmetric_keynames) { [:cr, :cl] }
            end

            it_behaves_like :check_symmetry do
              subject { dept_activated_incoherent_dimer }
              let(:symmetry_classes) { [] }
              let(:symmetric_keynames) { [] }
            end
          end

          describe 'activated dimer' do
            subject { dept_activated_dimer }
            let(:specifics) { [dept_activated_dimer, specific] }
            let(:use_parent_symmetry) { true }

            it_behaves_like :check_symmetry do
              let(:specific) { dept_bottom_hydrogenated_activated_dimer }
              let(:symmetry_classes) { ['AtomsSwapWrapper<Empty<DIMER_CRs>, 4, 5>'] }
              let(:symmetric_keynames) { [:_cr1, :clb] }
            end

            it_behaves_like :check_symmetry do
              let(:specific) { dept_right_bottom_hydrogenated_activated_dimer }
              let(:symmetry_classes) { ['AtomsSwapWrapper<Empty<DIMER_CRs>, 1, 2>'] }
              let(:symmetric_keynames) { [:_cr0, :crb] }
            end
          end
        end
      end

    end
  end
end
