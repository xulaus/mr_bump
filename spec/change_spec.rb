# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require_relative 'spec_helper.rb'
require 'mr_bump/change'

describe MrBump::Change do
  let(:config) do
    {
      'markdown_template' => ' * {{branch_type}}{{#dev_id}} - {{.}}{{/dev_id}}' \
                             "{{#first_comment_line}} - {{.}}{{/first_comment_line}}{{#comment_body}}\n  {{.}}{{/comment_body}}"
    }
  end

  context 'when loading from git log message' do
    let(:comment_lines) { ['Line 1', 'Line 2'] }
    subject(:change) { described_class.from_gitlog(config, merge_str, comment_lines) }

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

      it { should_not have_no_detail }
    end

    context 'when given a merge string in the default PR format for a feature' do
      let(:merge_str) { 'Merge pull request #555 from AGithubUsername/feature/Stuff' }

      it 'extracts the correct PR Number' do
        expect(change.pr_number).to eq('555')
      end

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Feature')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(" * Feature - Line 1\n  Line 2")
      end

      it { should_not have_no_detail }
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

      it { should_not have_no_detail }
    end

    context 'when given a merge string in the default PR format for a bugfix' do
      let(:merge_str) { 'Merge pull request #555 from AGithubUsername/bugfix/Stuff' }

      it 'extracts the correct PR Number' do
        expect(change.pr_number).to eq('555')
      end

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Bugfix')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(" * Bugfix - Line 1\n  Line 2")
      end

      it { should_not have_no_detail }
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

      it { should_not have_no_detail }
    end

    context 'when given a merge string in the default PR format for a hotfix' do
      let(:merge_str) { 'Merge pull request #555 from AGithubUsername/hotfix/Stuff' }

      it 'extracts the correct PR Number' do
        expect(change.pr_number).to eq('555')
      end

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Hotfix')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(" * Hotfix - Line 1\n  Line 2")
      end

      it { should_not have_no_detail }
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

      it { should_not have_no_detail }
    end

    context 'when given a merge string in the default PR format for a feature' do
      let(:merge_str) { "Merge branch 'feature/Stuff'" }

      it 'defaults PR Number to a blank string' do
        expect(change.pr_number).to eq('')
      end

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Feature')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(" * Feature - Line 1\n  Line 2")
      end

      it { should_not have_no_detail }
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

      it { should_not have_no_detail }
    end

    context 'when given a merge string in the default PR format for a bugfix' do
      let(:merge_str) { "Merge branch 'bugfix/Stuff'" }

      it 'defaults PR Number to a blank string' do
        expect(change.pr_number).to eq('')
      end

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Bugfix')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(" * Bugfix - Line 1\n  Line 2")
      end

      it { should_not have_no_detail }
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

      it { should_not have_no_detail }
    end

    context 'when given a merge string in the default PR format for a hotfix' do
      let(:merge_str) { "Merge branch 'hotfix/Stuff'" }

      it 'defaults PR Number to a blank string' do
        expect(change.pr_number).to eq('')
      end

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Hotfix')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(" * Hotfix - Line 1\n  Line 2")
      end

      it { should_not have_no_detail }
    end

    context 'when no merge type given' do
      let(:merge_str) { 'Merge pull request #1224 from Xulaus/gem_bump' }
      it 'extracts the correct PR Number' do
        expect(change.pr_number).to eq('1224')
      end

      it 'defaults the branch type to "Task"' do
        expect(change.branch_type).to eq('Task')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(" * Task - Line 1\n  Line 2")
      end

      it { should_not have_no_detail }
    end

    context 'with no comment' do
      let(:comment_lines) { [] }

      context 'when given a merge string in the default PR format for a hotfix' do
        let(:merge_str) { "Merge branch 'hotfix/Stuff'" }

        it 'defaults PR Number to a blank string' do
          expect(change.pr_number).to eq('')
        end

        it 'extracts the correct branch type' do
          expect(change.branch_type).to eq('Hotfix')
        end

        it 'fails to extract dev ID' do
          expect(change.dev_id).to be_nil
        end

        it 'renders to markdown correctly' do
          expect(change.to_md).to eq(" * Hotfix")
        end

        it { should have_no_detail }
      end

      context 'when given a merge string in the default PR format for a bugfix' do
        let(:merge_str) { "Merge branch 'bugfix/Stuff'" }

        it 'defaults PR Number to a blank string' do
          expect(change.pr_number).to eq('')
        end

        it 'extracts the correct branch type' do
          expect(change.branch_type).to eq('Bugfix')
        end

        it 'fails to extract dev ID' do
          expect(change.dev_id).to be_nil
        end

        it 'renders to markdown correctly' do
          expect(change.to_md).to eq(" * Bugfix")
        end

        it { should have_no_detail }
      end

      context 'when given a merge string in the default PR format for a feature' do
        let(:merge_str) { "Merge branch 'feature/Stuff'" }

        it 'defaults PR Number to a blank string' do
          expect(change.pr_number).to eq('')
        end

        it 'extracts the correct branch type' do
          expect(change.branch_type).to eq('Feature')
        end

        it 'fails to extract dev ID' do
          expect(change.dev_id).to be_nil
        end

        it 'renders to markdown correctly' do
          expect(change.to_md).to eq(" * Feature")
        end

        it { should have_no_detail }
      end

      context 'when no merge type given' do
        let(:merge_str) { 'Merge pull request #1224 from Xulaus/gem_bump' }
        it 'extracts the correct PR Number' do
          expect(change.pr_number).to eq('1224')
        end

        it 'defaults the branch type to "Task"' do
          expect(change.branch_type).to eq('Task')
        end

        it 'fails to extract dev ID' do
          expect(change.dev_id).to be_nil
        end

        it 'renders to markdown correctly' do
          expect(change.to_md).to eq(" * Task")
        end

        it { should have_no_detail }
      end
    end
  end

  context 'when loading from markdown' do
    subject(:change) { described_class.from_md(config, md_str) }

    context 'with bugfix and no DevID given' do
      let(:md_str) { " * Bugfix - Line 1\n  Line 2\n  Line 3" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Bugfix')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with feature and no DevID given' do
      let(:md_str) { " * Feature - Line 1\n  Line 2\n  Line 3" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Feature')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with hotfix and no DevID given' do
      let(:md_str) { " * Hotfix - Line 1\n  Line 2\n  Line 3" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Hotfix')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with task and no DevID given' do
      let(:md_str) { " * Task - Line 1\n  Line 2\n  Line 3" }

      it 'defaults the branch type to "Task"' do
        expect(change.branch_type).to eq('Task')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with bugfix and no DevID given, and no second line' do
      let(:md_str) { " * Bugfix - Line 1" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Bugfix')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with feature and no DevID given, and no second line' do
      let(:md_str) { " * Feature - Line 1" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Feature')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with hotfix and no DevID given, and no second line' do
      let(:md_str) { " * Hotfix - Line 1" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Hotfix')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with task and no DevID given, and no second line' do
      let(:md_str) { " * Task - Line 1" }

      it 'defaults the branch type to "Task"' do
        expect(change.branch_type).to eq('Task')
      end

      it 'fails to extract dev ID' do
        expect(change.dev_id).to be_nil
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with bugfix and DevID given' do
      let(:md_str) { " * Bugfix - ASDASD-123123 - Line 1\n  Line 2\n  Line 3" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Bugfix')
      end

      it 'extracts the correct dev ID' do
        expect(change.dev_id).to eq('ASDASD-123123')
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with feature and DevID given' do
      let(:md_str) { " * Feature - WHUT00 - Line 1\n  Line 2\n  Line 3" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Feature')
      end

      it 'extracts the correct dev ID' do
        expect(change.dev_id).to eq('WHUT00')
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with hotfix and DevID given' do
      let(:md_str) { " * Hotfix - WJNASD-123 - Line 1\n  Line 2\n  Line 3" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Hotfix')
      end

      it 'extracts the correct dev ID' do
        expect(change.dev_id).to eq('WJNASD-123')
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with task and DevID given' do
      let(:md_str) { " * Task - lqiwhuweh213 - Line 1\n  Line 2\n  Line 3" }

      it 'defaults the branch type to "Task"' do
        expect(change.branch_type).to eq('Task')
      end

      it 'extracts the correct dev ID' do
        expect(change.dev_id).to eq('lqiwhuweh213')
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with bugfix and DevID given, and no second line' do
      let(:md_str) { " * Bugfix - DEV-123 - Line 1" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Bugfix')
      end

      it 'extracts the correct dev ID' do
        expect(change.dev_id).to eq('DEV-123')
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with feature and DevID given, and no second line' do
      let(:md_str) { " * Feature - SAMBA-123 - Line 1" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Feature')
      end

      it 'extracts the correct dev ID' do
        expect(change.dev_id).to eq('SAMBA-123')
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with hotfix and DevID given, and no second line' do
      let(:md_str) { " * Hotfix - asf1 - Line 1" }

      it 'extracts the correct branch type' do
        expect(change.branch_type).to eq('Hotfix')
      end

      it 'extracts the correct dev ID' do
        expect(change.dev_id).to eq('asf1')
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end

    context 'with task and DevID given, and no second line' do
      let(:md_str) { " * Task - JBAJSDB0123 - Line 1" }

      it 'defaults the branch type to "Task"' do
        expect(change.branch_type).to eq('Task')
      end

      it 'extracts the correct dev ID' do
        expect(change.dev_id).to eq('JBAJSDB0123')
      end

      it 'renders to markdown correctly' do
        expect(change.to_md).to eq(md_str)
      end

      it { should_not have_no_detail }
    end
  end

  context 'when given a change prefixed with a DevID seperated with a colon' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }
    let(:change) { described_class.from_gitlog(config, merge_str, ['DEV-1: Line 1', 'Line 2']) }

    it 'removes the DevID and renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a change prefixed with a DevID seperated with a dash' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }
    let(:change) { described_class.from_gitlog(config, merge_str, ['DEV-1 - Line 1', 'Line 2']) }

    it 'removes the DevID and renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a change prefixed with a DevID seperated with a dash, and in square braces' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }
    let(:change) { described_class.from_gitlog(config, merge_str, ['[DEV-1] - Line 1', 'Line 2']) }

    it 'removes the DevID and renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a change prefixed with a DevID in square braces' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }
    let(:change) { described_class.from_gitlog(config, merge_str, ['[DEV-1] Line 1', 'Line 2']) }

    it 'removes the DevID and renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a change prefixed with a DevID in round braces' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }
    let(:change) { described_class.from_gitlog(config, merge_str, ['(DEV-1) Line 1', 'Line 2']) }

    it 'removes the DevID and renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a change prefixed with a DevID seperated by space only' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }
    let(:change) { described_class.from_gitlog(config, merge_str, ['DEV-1 Line 1', 'Line 2']) }

    it 'leaves the DevID and renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1\n  Line 2")
    end
  end

  context 'when given a change postfixed with a DevID in round braces' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }
    let(:change) { described_class.from_gitlog(config, merge_str, ['Line 1 (DEV-1)', 'Line 2']) }

    it 'leaves the DevID and renders to markdown correctly' do
      expect(change.to_md).to eq(" * Hotfix - DEV-1 - Line 1 (DEV-1)\n  Line 2")
    end
  end

  context 'when given a change with no description' do
    let(:merge_str) { "Merge branch 'hotfix/DEV-1_Stuff'" }
    let(:change) { described_class.from_gitlog(config, merge_str, []) }

    it 'renders to markdown correctly' do
      expect(change.to_md).to eq(' * Hotfix - DEV-1')
    end
  end
end
