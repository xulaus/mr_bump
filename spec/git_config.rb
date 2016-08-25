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
  end
end
