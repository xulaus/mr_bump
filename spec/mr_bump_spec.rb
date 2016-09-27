# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'mr_bump/version'
require 'mr_bump'

describe MrBump do
  describe '#all_tagged_versions' do
    before(:each) { allow(MrBump).to receive(:all_tags).and_return(tag_list) }

    context 'when given a mixed list of tags' do
      let(:tag_list) do
        [
          'safbdhasgbd',
          '',
          '9.1.32',
          '21.1',
          '132',
          'Not.A Version'
        ]
      end
      it 'parses into versions where possible' do
        expect(MrBump.all_tagged_versions).to match_array(
          [
            MrBump::Version.new('9.1.32'),
            MrBump::Version.new('21.1'),
            MrBump::Version.new('132')
          ]
        )
      end
    end
  end

  describe '#current_uat' do
    before(:each) do
      allow(MrBump).to receive(:all_tags).and_return(tag_list)
      allow(MrBump).to receive(:current_uat_major).and_return(MrBump::Version.new(next_version))
    end

    context 'when the next release is a minor bump' do
      let(:next_version) { '1.2.0' }
      let(:tag_list) do
        [
          'safbdhasgbd',
          '',
          'Not.A Version',
          '1.2.3',
          '1.2.2',
          '1.1.1',
          '1.1.9'
        ]
      end
      it 'returns the maximum tagged version with the same major and minor numbers' do
        expect(MrBump.current_uat).to eq(MrBump::Version.new('1.2.3'))
      end
    end

    context 'when the next release is a major bump' do
      let(:next_version) { '2.0.0' }
      let(:tag_list) do
        [
          'safbdhasgbd',
          '',
          'Not.A Version',
          '1.2.3',
          '1.2.2',
          '1.1.1',
          '1.0.9',
          '2.0.0',
          '2.0.1',
          '2.0.9'
        ]
      end
      it 'returns the maximum tagged version with the same major and minor numbers' do
        expect(MrBump.current_uat).to eq(MrBump::Version.new('2.0.9'))
      end
    end
  end

  describe '#current_master' do
    before(:each) do
      allow(MrBump).to receive(:all_tags).and_return(tag_list)
      allow(MrBump).to receive(:current_uat_major).and_return(MrBump::Version.new(next_version))
    end

    context 'when the next release is a minor bump' do
      let(:next_version) { '1.2.0' }
      let(:tag_list) do
        [
          'safbdhasgbd',
          '',
          'Not.A Version',
          '1.2.3',
          '1.2.2',
          '1.1.1',
          '1.1.9'
        ]
      end
      it 'returns the maximum tagged version below the UAT version' do
        expect(MrBump.current_master).to eq(MrBump::Version.new('1.1.9'))
      end
    end

    context 'when the next release is a major bump' do
      let(:next_version) { '2.0.0' }
      let(:tag_list) do
        [
          'safbdhasgbd',
          '',
          'Not.A Version',
          '1.2.3',
          '1.2.2',
          '1.1.1',
          '1.0.9',
          '2.0.0',
          '2.0.1',
          '2.0.9'
        ]
      end
      it 'returns the maximum tagged version below the UAT version' do
        expect(MrBump.current_master).to eq(MrBump::Version.new('1.2.3'))
      end
    end
  end

  describe '#latest_release_from_list' do
    context 'With many release branches and using slash separator' do
      it 'extracts the highest version' do
        branch_list = [
          'origin/release/10.16.0',
          'origin/release/10.15.9',
          'origin/release/10.1.0',
          'origin/release/10.15.0',
          'origin/rse/10.16.0',
          'origin/master',
          ''
        ]
        expect(MrBump.latest_release_from_list(branch_list)).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With a single release branch and using slash separator' do
      it 'extracts the version' do
        branch_list = [
          'origin/release/10.16.9',
          'origin/rse/1.2.0',
          'origin/master',
          ''
        ]
        expect(MrBump.latest_release_from_list(branch_list)).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With many release branches and minor versions and using slash separator' do
      it 'extracts the highest version with patch version set to 0' do
        branch_list = [
          'origin/release/10.16.0',
          'origin/release/10.15.9',
          'origin/release/10.1.0',
          'origin/release/10.15.0',
          'origin/release/10.16.9',
          'origin/rse/10.16.0',
          'origin/master',
          ''
        ]
        expect(MrBump.latest_release_from_list(branch_list)).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With a single release branch with a patch number and using slash separator' do
      it 'extracts the version with patch version set to 0' do
        branch_list = [
          'origin/release/10.16.9',
          'origin/rse/1.2.0',
          'origin/master',
          ''
        ]
        expect(MrBump.latest_release_from_list(branch_list)).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With many release branches and using dash separator' do
      it 'extracts the highest version' do
        branch_list = [
          'origin/release-10.16.0',
          'origin/release-10.15.9',
          'origin/release-10.1.0',
          'origin/release-10.15.0',
          'origin/rse-10.16.0',
          'origin/master',
          ''
        ]
        expect(MrBump.latest_release_from_list(branch_list)).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With a single release branch and using dash separator' do
      it 'extracts the version' do
        branch_list = [
          'origin/release-10.16.9',
          'origin/rse-1.2.0',
          'origin/master',
          ''
        ]
        expect(MrBump.latest_release_from_list(branch_list)).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With many release branches and minor versions and using dash separator' do
      it 'extracts the highest version with patch version set to 0' do
        branch_list = [
          'origin/release-10.16.0',
          'origin/release-10.15.9',
          'origin/release-10.1.0',
          'origin/release-10.15.0',
          'origin/release-10.16.9',
          'origin/rse-10.16.0',
          'origin/master',
          ''
        ]
        expect(MrBump.latest_release_from_list(branch_list)).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With a single release branch with a patch number and using dash separator' do
      it 'extracts the version with patch version set to 0' do
        branch_list = [
          'origin/release-10.16.9',
          'origin/rse-1.2.0',
          'origin/master',
          ''
        ]
        expect(MrBump.latest_release_from_list(branch_list)).to eq(MrBump::Version.new('10.16.0'))
      end
    end
  end
end
