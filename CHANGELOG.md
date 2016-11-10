# 0.3.4
* Strip DevIDs from the beginning of change log comments - [PR](https://github.com/xulaus/mr_bump/pull/64)

# 0.3.3
* Fix crash when there is only a single merge item and no comment - [PR](https://github.com/xulaus/mr_bump/pull/62), [Issue](https://github.com/xulaus/mr_bump/issues/60)

# 0.3.2
* Fix bug where multiple post bump commands would fail to execute - [PR](https://github.com/xulaus/mr_bump/pull/58)
* Update gemspec to remain ruby 1.9.3 compatabile - [PR](https://github.com/xulaus/mr_bump/pull/57)

# 0.3.1
* Fix small bug where new release branches are not pushed after cutting new release - [PR](https://github.com/xulaus/mr_bump/pull/54)
* Use Git Editor for editing changelogs when set in either config or environment variable - [PR](https://github.com/xulaus/mr_bump/pull/55)

# 0.3.0
* Allow mr_bump to cut new releases - [PR](https://github.com/xulaus/mr_bump/pull/51)
* Add warning for stale release branch - [PR](https://github.com/xulaus/mr_bump/pull/49), [Issue](https://github.com/xulaus/mr_bump/issues/42)
* Better Test Coverage - [PR](https://github.com/xulaus/mr_bump/pull/50)

# 0.2.2
* Fix documentation bug - [PR](https://github.com/xulaus/mr_bump/pull/47), [Issue](https://github.com/xulaus/mr_bump/issues/36)
* Exit bump process if commit fails - [PR](https://github.com/xulaus/mr_bump/pull/46), [Issue](https://github.com/xulaus/mr_bump/issues/18)
* Clearly show version being bumped from and to - [PR](https://github.com/xulaus/mr_bump/pull/46), [Issue](https://github.com/xulaus/mr_bump/issues/32)
* Show user what the post bump command before running it - [PR](https://github.com/xulaus/mr_bump/pull/46), [Issue](https://github.com/xulaus/mr_bump/issues/33)
* Add feature that ignores GitFlow branches - [PR](https://github.com/xulaus/mr_bump/pull/44), [Issue](https://github.com/xulaus/mr_bump/issues/43)
* Do not update tags in dry run mode - [PR](https://github.com/xulaus/mr_bump/pull/35), [Issue](https://github.com/xulaus/mr_bump/issues/34)
* Add warning when HEAD tag is detected - [PR](https://github.com/xulaus/mr_bump/pull/45), [Issue](https://github.com/xulaus/mr_bump/issues/41)
* Improve testing and coverage - [PR 1](https://github.com/xulaus/mr_bump/pull/40), [PR 2](https://github.com/xulaus/mr_bump/pull/39)

# 0.2.1
* Fix crash when attempting to send Slack message - [PR](https://github.com/xulaus/mr_bump/pull/#37)

# 0.2.0
* Fix error when trying to use `git merge-base` - [PR](https://github.com/xulaus/mr_bump/pull/28)
* Add error when master version cannot be detected - [PR](https://github.com/xulaus/mr_bump/pull/29)
* Fix error on PR list load - [PR](https://github.com/xulaus/mr_bump/pull/30) [Issue](https://github.com/xulaus/mr_bump/pull/24) 
* Make release branch name configurable - [PR](https://github.com/xulaus/mr_bump/pull/25)
* Code Cleanup - [PR](https://github.com/xulaus/mr_bump/pull/15)

# 0.1.0
* Move GitHub API key to a real config file - [PR](https://github.com/xulaus/mr_bump/pull/23)
* Add dry run option - [PR](https://github.com/xulaus/mr_bump/pull/22)
* Better tests for MrBump module - [PR](https://github.com/xulaus/mr_bump/pull/14), [Issue](https://github.com/xulaus/mr_bump/issues/8)
* Find CHANGELOG via absolute path rather than relative - [PR](https://github.com/xulaus/mr_bump/pull/16)
* Write to intermediate files rather than the CHANGLOG for intermediate states - [PR](https://github.com/xulaus/mr_bump/pull/13)
* Customisation of individual changes using Mustache templates - [PR](https://github.com/xulaus/mr_bump/pull/6)
* Rename specs so RSpec can run without file specification - [PR](https://github.com/xulaus/mr_bump/pull/11)
* Add access to github API for reviewing and closing PR - - [PR](https://github.com/xulaus/mr_bump/pull/10)
* Start using MPL 2.0 license - [PR](https://github.com/xulaus/mr_bump/pull/9)


# 0.0.10
* Fix formatting issue with slack integration [Commit](https://github.com/xulaus/mr_bump/commit/f33452d5fded9810166e5e41bfc87f1fc228218c)

# 0.0.9
* Allow `git remote get-url origin` to return more URL formats [PR](https://github.com/xulaus/mr_bump/pull/7)

# 0.0.8
* Fixed issue where editing a single line changelog would crash on editor exit [Commit](https://github.com/xulaus/mr_bump/commit/cb3fb068c1906ef52771b5859e5c51363c3976a2)

# 0.0.7
* Upgrade slack integration to include Jira IDs and Git Merges - [PR](https://github.com/xulaus/mr_bump/pull/5)

# 0.0.6
* Fixes bug to help deal with manual merges - [PR](https://github.com/xulaus/mr_bump/pull/3)

# 0.0.5
* Fixes bug relating to formatting of changes

# 0.0.4
* Added ability to execute post bump commands - [PR](https://github.com/xulaus/mr_bump/pull/2)

# 0.0.3
* Added slack integration - [PR](https://github.com/xulaus/mr_bump/pull/1)

# 0.0.2
* Stop Mr Bump running git pull

# 0.0.1
* Initial commit
