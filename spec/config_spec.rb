# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'mr_bump/config'

describe MrBump::Config do
  context 'when given default, user and project level configuration' do
    let(:default) { { 'a' => 'a', 'b' => 'a', 'c' => 'a' } }
    let(:user_level) { { 'c' => 'b', 'b' => 'b' } }
    let(:project_level) { { 'c' => 'c' } }
    let(:expected_result) { { 'a' => 'a', 'b' => 'b', 'c' => 'c' } }
    let(:config) do
      config = described_class.new
      allow(config).to receive(:default_config).and_return(default)
      allow(config).to receive(:user_config).and_return(user_level)
      allow(config).to receive(:project_config).and_return(project_level)
      config.config
    end
    it 'correctly prefers more specific configuration' do
      expect(config).to eq(expected_result)
    end
  end
end
