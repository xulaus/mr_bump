# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require_relative 'spec_helper.rb'
require 'mr_bump/change'

describe MrBump::Change do
  let(:config) do
    {
      'markdown_template' => ' * {{branch_type}} - {{dev_id}} - {{first_comment_line}}' \
                             "{{#comment_body}}\n  {{.}}{{/comment_body}}"
    }
  end

  let(:change) { described_class.new(config, merge_str, ['Line 1', 'Line 2']) }

  context 'when given a merge string in the default PR format for a feature' do
    let(:merge_str) { 'Merge pull request #555 from AGithubUsername/feature/DEV-1_Stuff' }

    it 'extracts the correct PR Number' do
      expect(change.pr_number).to eq('555')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Feature')
    end

    it 'extracts the correct dev ID' do
      expect(change.dev_id).to eq('DEV-1')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Feature - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default PR format for a feature' do
    let(:merge_str) { 'Merge pull request #555 from AGithubUsername/feature/Stuff' }

    it 'extracts the correct PR Number' do
      expect(change.pr_number).to eq('555')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Feature')
    end

    it 'defaults the dev ID to UNKNOWN' do
      expect(change.dev_id).to eq('UNKNOWN')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Feature - UNKNOWN - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default PR format for a bugfix' do
    let(:merge_str) { 'Merge pull request #555 from AGithubUsername/bugfix/DEV-1_Stuff' }

    it 'extracts the correct PR Number' do
      expect(change.pr_number).to eq('555')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Bugfix')
    end

    it 'extracts the correct dev ID' do
      expect(change.dev_id).to eq('DEV-1')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Bugfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default PR format for a bugfix' do
    let(:merge_str) { 'Merge pull request #555 from AGithubUsername/bugfix/Stuff' }

    it 'extracts the correct PR Number' do
      expect(change.pr_number).to eq('555')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Bugfix')
    end

    it 'defaults the dev ID to UNKNOWN' do
      expect(change.dev_id).to eq('UNKNOWN')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Bugfix - UNKNOWN - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default PR format for a hotfix' do
    let(:merge_str) { 'Merge pull request #555 from AGithubUsername/hotfix/DEV-1_Stuff' }

    it 'extracts the correct PR Number' do
      expect(change.pr_number).to eq('555')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Hotfix')
    end

    it 'extracts the correct dev ID' do
      expect(change.dev_id).to eq('DEV-1')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default PR format for a hotfix' do
    let(:merge_str) { 'Merge pull request #555 from AGithubUsername/hotfix/Stuff' }

    it 'extracts the correct PR Number' do
      expect(change.pr_number).to eq('555')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Hotfix')
    end

    it 'defaults the dev ID to UNKNOWN' do
      expect(change.dev_id).to eq('UNKNOWN')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - UNKNOWN - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default manual format for a feature' do
    let(:merge_str) { "Merge branch 'feature/DEV-1_Stuff'" }

    it 'defaults PR Number to a blank string' do
      expect(change.pr_number).to eq('')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Feature')
    end

    it 'extracts the correct dev ID' do
      expect(change.dev_id).to eq('DEV-1')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Feature - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default PR format for a feature' do
    let(:merge_str) { "Merge branch 'feature/Stuff'" }

    it 'defaults PR Number to a blank string' do
      expect(change.pr_number).to eq('')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Feature')
    end

    it 'defaults the dev ID to UNKNOWN' do
      expect(change.dev_id).to eq('UNKNOWN')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Feature - UNKNOWN - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default manual format for a bugfix' do
    let(:merge_str) { "Merge branch 'bugfix/DEV-1_Stuff'" }

    it 'defaults PR Number to a blank string' do
      expect(change.pr_number).to eq('')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Bugfix')
    end

    it 'extracts the correct dev ID' do
      expect(change.dev_id).to eq('DEV-1')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Bugfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default PR format for a bugfix' do
    let(:merge_str) { "Merge branch 'bugfix/Stuff'" }

    it 'defaults PR Number to a blank string' do
      expect(change.pr_number).to eq('')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Bugfix')
    end

    it 'defaults the dev ID to UNKNOWN' do
      expect(change.dev_id).to eq('UNKNOWN')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Bugfix - UNKNOWN - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default manual format for a hotfix' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }

    it 'defaults PR Number to a blank string' do
      expect(change.pr_number).to eq('')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Hotfix')
    end

    it 'extracts the correct dev ID' do
      expect(change.dev_id).to eq('DEV-1')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a merge string in the default PR format for a hotfix' do
    let(:merge_str) { "Merge branch 'hotfix/Stuff'" }

    it 'defaults PR Number to a blank string' do
      expect(change.pr_number).to eq('')
    end

    it 'extracts the correct branch type' do
      expect(change.branch_type).to eq('Hotfix')
    end

    it 'defaults the dev ID to UNKNOWN' do
      expect(change.dev_id).to eq('UNKNOWN')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - UNKNOWN - Line 1\n  Line 2")
    end
  end

  context 'when no merge type given' do
    let(:merge_str) { 'Merge pull request #1224 from Xulaus/gem_bump' }
    it 'extracts the correct PR Number' do
      expect(change.pr_number).to eq('1224')
    end

    it 'defaults the branch type to "Task"' do
      expect(change.branch_type).to eq('Task')
    end

    it 'defaults the dev ID to UNKNOWN' do
      expect(change.dev_id).to eq('UNKNOWN')
    end

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(" * Task - UNKNOWN - Line 1\n  Line 2")
    end
  end
end
