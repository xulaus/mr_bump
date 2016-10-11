# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require_relative 'spec_helper.rb'
require 'mr_bump/version'
require 'mr_bump/change'
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
    before(:each) { allow(MrBump).to receive(:config_file).and_return(config) }
    let(:result) { MrBump.latest_release_from_list(branch_list) }
    let(:config) do
      {
        'release_prefix' => "release#{separator}",
        'release_suffix' => suffix
      }
    end
    let(:suffix) { '' }
    let(:separator) { '/' }

    context 'With many release branches and using slash separator' do
      let(:branch_list) do
        [
          'origin/release/10.16.0',
          'origin/release/10.15.9',
          'origin/release/10.1.0',
          'origin/release/10.15.0',
          'origin/rse/10.16.0',
          'origin/master',
          ''
        ]
      end

      it 'extracts the highest version' do
        expect(result).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With a single release branch and using slash separator' do
      let(:branch_list) do
        [
          'origin/release/10.16.9',
          'origin/rse/1.2.0',
          'origin/master',
          ''
        ]
      end

      it 'extracts the version' do
        expect(result).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With many release branches and minor versions and using slash separator' do
      let(:branch_list) do
        [
          'origin/release/10.16.0',
          'origin/release/10.15.9',
          'origin/release/10.1.0',
          'origin/release/10.15.0',
          'origin/release/10.16.9',
          'origin/rse/10.16.0',
          'origin/master',
          ''
        ]
      end

      it 'extracts the highest version with patch version set to 0' do
        expect(result).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With a single release branch with a patch number and using slash separator' do
      let(:branch_list) do
        [
          'origin/release/10.16.9',
          'origin/rse/1.2.0',
          'origin/master',
          ''
        ]
      end

      it 'extracts the version with patch version set to 0' do
        expect(result).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With no release branches' do
      let(:branch_list) do
        [
        ]
      end

      it 'returns 0.0.0 as the version' do
        expect(result).to eq(MrBump::Version.new('0.0.0'))
      end
    end

    context 'With many release branches and changing the default prefix' do
      let(:branch_list) do
        [
          'origin/release?10.16.0',
          'origin/release/10.17.0',
          'origin/release?10.15.9',
          'origin/release/10.1.0',
          'origin/release/10.15.0',
          'origin/rse/10.16.0',
          'origin/master',
          ''
        ]
      end
      let(:separator) { '?' }

      it 'extracts the correct highest version, igoring branches with incorrect prefix' do
        expect(result).to eq(MrBump::Version.new('10.16.0'))
      end
    end

    context 'With many release branches and changing the default suffix' do
      let(:branch_list) do
        [
          'origin/release/10.16.0.',
          'origin/release/10.17.0.',
          'origin/release/10.15.9.',
          'origin/release/10.1.0.',
          'origin/release/10.15.0',
          'origin/release/10.18.0',
          'origin/rse/10.16.0',
          'origin/master',
          ''
        ]
      end
      let(:suffix) { '.' }

      it 'extracts the correct highest version, igoring branches with incorrect suffix' do
        expect(result).to eq(MrBump::Version.new('10.17.0'))
      end
    end

    context 'With many release branches and changing the default prefix' do
      let(:branch_list) do
        [
          'origin/release?10.16.0?',
          'origin/release/10.17.0?',
          'origin/release?10.15.9?',
          'origin/release/10.1.0?',
          'origin/release/10.15.0?',
          'origin/release/11.1.0',
          'origin/release/11.15.0',
          'origin/release?12.1.0',
          'origin/release?12.15.0',
          'origin/rse/10.16.0?',
          'origin/master',
          ''
        ]
      end
      let(:separator) { '?' }
      let(:suffix) { '?' }

      it 'extracts the correct highest version, igoring branches with incorrect prefix or suffix' do
        expect(result).to eq(MrBump::Version.new('10.16.0'))
      end
    end
  end

  describe '#on_master_branch?' do
    before(:each) { allow(MrBump).to receive(:current_branch).and_return(current_branch) }

    context 'when on a branch called master' do
      let(:current_branch) { 'master' }

      it 'returns true' do
        expect(MrBump.on_master_branch?).to eq(true)
      end
    end

    context 'when on a branch called master$' do
      let(:current_branch) { 'master$' }

      it 'returns false' do
        expect(MrBump.on_master_branch?).to eq(false)
      end
    end

    context 'when on a branch called ^master' do
      let(:current_branch) { '^master' }

      it 'returns false' do
        expect(MrBump.on_master_branch?).to eq(false)
      end
    end

    context 'when on a branch called release' do
      let(:current_branch) { 'release' }

      it 'returns false' do
        expect(MrBump.on_master_branch?).to eq(false)
      end
    end
  end

  describe '#on_release_branch?' do
    before(:each) { allow(MrBump).to receive(:current_branch).and_return(current_branch) }
    before(:each) { allow(MrBump).to receive(:config_file).and_return(config) }

    context 'with default config' do
      let(:config) do
        {
          'release_prefix' => 'release/',
          'release_suffix' => ''
        }
      end
      context 'when on a branch called master' do
        let(:current_branch) { 'master' }

        it 'returns false' do
          expect(MrBump.on_release_branch?).to eq(false)
        end
      end

      context 'when on a branch called release/' do
        let(:current_branch) { 'release/' }

        it 'returns false' do
          expect(MrBump.on_release_branch?).to eq(false)
        end
      end

      context 'when on a branch called release/0.0.0' do
        let(:current_branch) { 'release/0.0.0' }

        it 'returns true' do
          expect(MrBump.on_release_branch?).to eq(true)
        end
      end

      context 'when on a branch called release/0.0' do
        let(:current_branch) { 'release/0.0' }

        it 'returns true' do
          expect(MrBump.on_release_branch?).to eq(true)
        end
      end
    end

    context 'with altered config' do
      let(:config) do
        {
          'release_prefix' => '?v',
          'release_suffix' => '+'
        }
      end

      context 'branch with correct prefix and suffix' do
        let(:current_branch) { '?v0.0.0+' }

        it 'returns true' do
          expect(MrBump.on_release_branch?).to eq(true)
        end
      end

      context 'branch with correct prefix and suffix and missing patch version' do
        let(:current_branch) { '?v0.0+' }

        it 'returns true' do
          expect(MrBump.on_release_branch?).to eq(true)
        end
      end

      context 'on a branch which is valid  with default config' do
        let(:current_branch) { 'release/0.0.0' }

        it 'returns false' do
          expect(MrBump.on_release_branch?).to eq(false)
        end
      end
    end
  end

  describe '#uat_branch?' do
    before(:each) do
      allow(MrBump).to receive(:current_uat_major).and_return(MrBump::Version.new('0.0.0'))
    end
    before(:each) { allow(MrBump).to receive(:config_file).and_return(config) }

    context 'with default config' do
      let(:config) do
        {
          'release_prefix' => 'release/',
          'release_suffix' => ''
        }
      end

      it 'correctly constucts uat branch name' do
        expect(MrBump.uat_branch).to eq('release/0.0.0')
      end
    end

    context 'with altered config' do
      let(:config) do
        {
          'release_prefix' => '?v',
          'release_suffix' => '+'
        }
      end

      it 'correctly constucts uat branch name' do
        expect(MrBump.uat_branch).to eq('?v0.0.0+')
      end
    end
  end

  describe '#' do
    let(:log) do
      [
        'Merge pull request #4 from mr_bump/hotfix/DEV-1261',
        'Comment',
        'Merge pull request #1376 from mr_bump/release/10.19.0',
        'Comment',
        'Over several',
        'Lines',
        'Merge pull request #1365 from mr_bump/revert_contact_fixes',
        'Merge pull request #1365 from mr_bump/develop',
        'Merge pull request #233 from mr_bump/bugfix/master',
        'asdasd',
        'Merge pull request #1336 from mr_bump/MDV-1261',
        'wqefqfqefqwefqef'
      ]
    end
    before(:each) { allow(MrBump).to receive(:merge_logs).and_return(log) }

    context 'when given output from git log' do
      let(:changes) { MrBump.change_log_items_for_range('', '') }

      it 'converts raw git log ouput to changlog objects' do
        expect(changes).to all(be_a(MrBump::Change))
      end

      it 'filters out release and master branch merges' do
        expect(changes.map(&:branch_name)).to eq(['DEV-1261', 'revert_contact_fixes', 'MDV-1261'])
      end
    end
  end
end
