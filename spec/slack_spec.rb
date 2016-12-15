# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require_relative 'spec_helper.rb'
require 'mr_bump/slack'

describe MrBump::Slack do
  let(:config) do
    {
      'slack' => {
        'webhook_url' => webhook_url,
        'username' => username,
        'icon' => icons
      }
    }
  end
  let(:git_config) { {} }
  let(:username) { nil }
  let(:icons) { nil }
  let(:webhook_url) { 'asdads' }

  let(:slack) { described_class.new(git_config, config) }

  context 'when not given a webhook url' do
    let(:webhook_url) { nil }
    it 'throws an error on construction' do
      expect { slack }.to raise_error(ArgumentError)
    end
  end

  context 'when given a valid config with no username' do
    context 'when not given an icon' do
      it 'defaults the name to "Mr Bump"' do
        expect(slack.username).to eq('Mr Bump')
      end
      it 'has no icon' do
        expect(slack.icon).to eq(nil)
      end
    end

    context 'with an array of icons to use' do
      let(:icons) { %w(a bc) }

      it 'defaults the name to "Mr Bump"' do
        expect(slack.username).to eq('Mr Bump')
      end
      it 'selects a single icon to use' do
        expect(icons.include?(slack.icon))
      end
    end

    context 'with an single icon to use' do
      let(:icons) { 'icon' }

      it 'defaults the name to "Mr Bump"' do
        expect(slack.username).to eq('Mr Bump')
      end
      it 'uses the single given icon' do
        expect(slack.icon).to eq(icons)
      end
    end
  end

  context 'when given a valid config with a username' do
    let(:username) { 'Sad Corporate Name' }

    context 'when not given an icon' do
      it 'uses the given username' do
        expect(slack.username).to eq(username)
      end
      it 'has no icon' do
        expect(slack.icon).to eq(nil)
      end
    end

    context 'with an array of icons to use' do
      let(:icons) { %w(a bc) }

      it 'uses the given username' do
        expect(slack.username).to eq(username)
      end
      it 'selects a single icon to use' do
        expect(icons.include?(slack.icon))
      end
    end

    context 'with an single icon to use' do
      let(:icons) { 'icon' }

      it 'uses the given username' do
        expect(slack.username).to eq(username)
      end
      it 'uses the single given icon' do
        expect(slack.icon).to eq(icons)
      end
    end
  end

  describe '#jira_ids' do
    let(:result) do
      described_class.new(
        {},
        'slack' => { 'webhook_url' => 'dummy' },
        'markdown_template' => ' * {{branch_type}} - {{dev_id}} - {{first_comment_line}}' \
                               "{{#comment_body}}\n  {{.}}{{/comment_body}}"
      ).jira_ids(changes)
    end

    context 'when fed mixed changes in the default format' do
      let(:changes) do
        <<-CHANGES
 * Task - HSDA-123 - jsldafbaksjdblkab
 * Feature - QUAD-213 - asdbasn
 * Bugfix - UKNO-17 - akssnjlsand;kajnsd
   asmdhakjsdhgkaadsdasdsaafssdfgadfa
 * Hotfix - Yo-421 - kjfnjdns
CHANGES
      end
      let(:devids) { ['HSDA-123', 'QUAD-213', 'UKNO-17', 'Yo-421'] }

      it "extracts the DevID's where possible" do
        expect(result).to eq(devids)
      end
    end

    context "when fed mixed changes without DevID's" do
      let(:changes) do
        <<-CHANGES
 * Task - HSDA-123 - jsldafbaksjdblkab
 * Feature - asd213
 * Bugfix - UKNO-17 - akssnjlsand;kajnsd
   asmdhakjsdhgkaadsdasdsaafssdfgadfa
 * Bugfix - akssnjlsand;kajnsd
   asmdhakjsdhgkaadsdasdsaafssdfgadfa
 * Hotfix - Yo-421 - kjfnjdns
CHANGES
      end
      let(:devids) { ['HSDA-123', 'UKNO-17', 'Yo-421'] }

      it "extracts the DevID's where possible" do
        expect(result).to eq(devids)
      end
    end
  end
end
