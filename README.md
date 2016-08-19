# mr_bump

Mr Bump is a small utility for helping to version and changelog Git Flow projects.

It requires a develop branch (where most of your developing goes), a release branch in the form `release/\d+.\d+.\d+`, and a master branch.

You will need ruby installed and a Linux or Mac system.

## Naming Conventions

mr_bump will update the changelog with entries in the following format:
```
# 11.16.3
 * Bugfix - DA-31 - Some minor bug description
```

It takes this information form the branch name and pull request title and comments.

Branches should take the form:
```
bugfix/DA-31_some_description
```

The pull request title should just contain a description of the work undertaken.

It is possible to have a different title, this can be done by changing the comment on the merge commit.

## Running mr_bump

Add the following to your Gemfile:
```
gem 'mr_bump', git: git@github.com:xulaus/mr_bump, require: false
```

Then run `bundle install`.

When you're ready to bump, switch to either the `release` or `master` branch and run `mr_bump` when you're in the repositry root.

The output will look something like:
```
Changelog:
----------
# 11.16.3
 * Bugfix - DA-31 - Some minor bug description
 * Bugfix - ML-31 - Some minor bug description
----------
[A]ccept these changes / Manually [E]dit / [C]ancel Release :
```

You can now review the changes. If you are happy with the changes type <kbd>a</kbd> and press <kbd>Enter</kbd>.

If you wish to make manual changes to the output, type <kbd>e</kbd> and press <kbd>Enter</kbd>. This will update your `CHANGELOG.md` and drop you into a nano editor to make modifications to the `CHANGELOG.md`. Make the required modifications and exit nano using the usual commands.

When you have finished editing you will see the following options:
```
[A]ccept modified changes / [C]ancel Release :
```

To accept the changes press <kbd>a</kbd> then press <kbd>Enter</kbd>, alternatively you can abandon the bump by pressing <kbd>c</kbd> then <kbd>Enter</kbd>.

When you submit the changes, the `CHANGELOG.md` will be updated, commited and pushed and the commit will be tagged.

## Config File

The config file should be stored in the root direcotry of the respotitory under the name `.mr_bump`. The config file is a yaml file which constains configurations for Mr Bump.

## Slack Intergration

Mr Bump includes slack intergration with a custom name and icon. To enable Slack integration add the follwoing to your `.mr_bump` config file:
```
slack:
  webhook_url: "https://hooks.slack.com/services/some_custom_webhook"
  username: "Mr Bump"
  icon: "https://path_to_image.png"
```

If you do not wish to use Slack intergration, remove the Slack section from your config file.
