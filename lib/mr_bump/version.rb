# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module MrBump
  # This class enables comparison and bumping of sementic versions and
  # conversion to and from strings
  class Version
    include Comparable
    attr_reader :major, :minor, :patch
    def initialize(version_str)
      regex = Regexp.new('^([0-9]+)(\.([0-9]+)(\.([0-9]*))?)?')
      numbers = version_str.match(regex).captures
      @major = numbers[0].to_i
      @minor = (numbers.size > 2) ? numbers[2].to_i : 0
      @patch = (numbers.size > 4) ? numbers[4].to_i : 0
    end

    def <=>(other)
      major_com = major <=> other.major
      minor_com = (major_com == 0) ? minor <=> other.minor : major_com
      (minor_com == 0) ? patch <=> other.patch : minor_com
    end

    def to_s
      "#{major}.#{minor}.#{patch}"
    end

    def bump_major
      dup.bump_major!
    end

    def bump_major!
      @major += 1
      @minor = 0
      @patch = 0
      self
    end

    def bump_minor
      dup.bump_minor!
    end

    def bump_minor!
      @minor += 1
      @patch = 0
      self
    end

    def bump_patch
      dup.bump_patch!
    end

    def bump_patch!
      @patch += 1
      self
    end
  end
end
