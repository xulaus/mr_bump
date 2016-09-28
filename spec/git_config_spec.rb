# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'mr_bump/git_config'

describe MrBump::GitConfig do
  let(:config) { described_class.from_origin(origin, 'Someone') }

  context 'Given https origin with no username' do
    let(:origin) { 'https://github.com/xulaus/mr_bump' }
    it 'correctly extracts the repository name' do
      expect(config.repo_name).to eq('mr_bump')
    end

    it 'correctly constructs github url' do
      expect(config.repo_url).to eq('https://github.com/xulaus/mr_bump/')
    end

    it "doesn't extract a username" do
      expect(config.username.nil?)
    end

    it 'extracts correct host' do
      expect(config.host).to eq('https://github.com')
    end

    it 'extracts the correct path' do
      expect(config.path).to eq('xulaus/mr_bump')
    end
  end

  context 'Given https origin with username' do
    let(:origin) { 'https://xulaus@github.com/xulaus/mr_bump.git' }
    it 'correctly extracts the repository name' do
      expect(config.repo_name).to eq('mr_bump')
    end
    it 'correctly constructs github url' do
      expect(config.repo_url).to eq('https://github.com/xulaus/mr_bump/')
    end

    it 'correctly extracts the username' do
      expect(config.username).to eq('xulaus')
    end

    it 'extracts correct host' do
      expect(config.host).to eq('https://github.com')
    end

    it 'extracts the correct path' do
      expect(config.path).to eq('xulaus/mr_bump')
    end
  end

  context 'Given git origin' do
    let(:origin) { 'git@github.com:xulaus/mr_bump.git' }
    it 'correctly extracts the repository name' do
      expect(config.repo_name).to eq('mr_bump')
    end
    it 'correctly constructs github url' do
      expect(config.repo_url).to eq('https://github.com/xulaus/mr_bump/')
    end

    it "doesn't extract a username" do
      expect(config.username.nil?)
    end

    it 'extracts correct host' do
      expect(config.host).to eq('https://github.com')
    end

    it 'extracts the correct path' do
      expect(config.path).to eq('xulaus/mr_bump')
    end
  end
end
