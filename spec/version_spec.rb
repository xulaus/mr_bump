# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require_relative 'spec_helper.rb'
require 'mr_bump/version'

describe MrBump::Version do
  context 'when doing comparisions' do
    it 'correctly returns  1.0.3 == 1.0.3' do
      expect(MrBump::Version.new('1.0.3')).to eq(MrBump::Version.new('1.0.3'))
    end

    it 'correctly returns  1.0.0 < 1.0.3' do
      a = MrBump::Version.new('1.0.0')
      b = MrBump::Version.new('1.0.3')
      expect(a).to be < b
      expect(a).not_to be > b
      expect(a).not_to eq(b)
      expect(b).to be > a
      expect(b).not_to be < a
      expect(b).not_to eq(a)
    end

    it 'correctly returns  8.0.100 < 8.1.9' do
      a = MrBump::Version.new('8.0.100')
      b = MrBump::Version.new('8.1.9')
      expect(a).to be < b
      expect(a).not_to be > b
      expect(a).not_to eq(b)
      expect(b).to be > a
      expect(b).not_to be < a
      expect(b).not_to eq(a)
    end

    it 'correctly returns  3.72.100 < 4.0.0' do
      a = MrBump::Version.new('3.72.100')
      b = MrBump::Version.new('4.0.0')
      expect(a).to be < b
      expect(a).not_to be > b
      expect(a).not_to eq(b)
      expect(b).to be > a
      expect(b).not_to be < a
      expect(b).not_to eq(a)
    end
  end

  context 'when using version string "0"' do
    let(:version) { MrBump::Version.new('0') }

    it 'is equal to 0.0.0' do
      expect(version).to eq(MrBump::Version.new('0.0.0'))
    end

    it 'converts to string "0.0.0"' do
      expect(version.to_s).to eq('0.0.0')
    end

    it 'patch bumps to version 0.0.1' do
      expect(version.bump_patch).to eq(MrBump::Version.new('0.0.1'))
    end

    it 'minor bumps to version 0.1.0' do
      expect(version.bump_minor).to eq(MrBump::Version.new('0.1.0'))
    end

    it 'major bumps to version 1.0.0' do
      expect(version.bump_major).to eq(MrBump::Version.new('1.0.0'))
    end
  end

  context 'when using version string "8.2"' do
    let(:version) { MrBump::Version.new('8.2') }

    it 'is equal to 8.2.0' do
      expect(version).to eq(MrBump::Version.new('8.2.0'))
    end

    it 'converts to string "8.2.0"' do
      expect(version.to_s).to eq('8.2.0')
    end

    it 'patch bumps to version 8.2.1' do
      expect(version.bump_patch).to eq(MrBump::Version.new('8.2.1'))
    end

    it 'minor bumps to version 8.3.0' do
      expect(version.bump_minor).to eq(MrBump::Version.new('8.3.0'))
    end

    it 'major bumps to version 9.0.0' do
      expect(version.bump_major).to eq(MrBump::Version.new('9.0.0'))
    end
  end

  context 'when using version string "4.3.2"' do
    let(:version) { MrBump::Version.new('4.3.2') }

    it 'patch bumps to version 4.3.3' do
      expect(version.bump_patch).to eq(MrBump::Version.new('4.3.3'))
    end

    it 'converts to string "4.3.2"' do
      expect(version.to_s).to eq('4.3.2')
    end

    it 'minor bumps to version 4.4.0' do
      expect(version.bump_minor).to eq(MrBump::Version.new('4.4.0'))
    end

    it 'major bumps to version 5.0.0' do
      expect(version.bump_major).to eq(MrBump::Version.new('5.0.0'))
    end
  end
end
