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

It takes this information from the branch name and pull request title and comments.

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

When you're ready to bump, switch to either the `release` or `master` branch and run `mr_bump` when you're in the repository root.

You will initially be asked if your PR has been recently closed. You will be prompted with a Yes/No option. If you select no, mr_bump will desplay the 10 most recent PRs in your repository and ask for the PR ID for the PR you wish to close, the output will look something like this:

```
Here are the 10 most recent PRs in your repo:
#1234 - Most recent pull request title
#1235 - Another pull request title
#1236 - Final pull request title
Enter the PR number to merge : 1234
```

If you see `404 - Not Found` it is likely that your access token is invalid.

Type the number of the PR you wish to merge and press <kbd>Enter</kbd>. Git Hub API errors are usually well explained and you will see an error like `405 - Pull Request is not mergeable` if Git is unable to close your PR. This will exit mr_bump.

You will now be able to view your changes, the output will look something like:

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

When you have finished editing you will be able to review your changes and be presented with the following options:

```
[A]ccept modified changes / [C]ancel Release :
```

To accept the changes press <kbd>a</kbd> then press <kbd>Enter</kbd>, alternatively you can abandon the bump by pressing <kbd>c</kbd> then <kbd>Enter</kbd>.

When you submit the changes, the `CHANGELOG.md` will be updated, commited and pushed and the commit will be tagged.

If you wish to see what `mr_bump` would do without actually changing anything, you can use
```
mr_bump --dry-run
```

## Config File

The config file should be stored in the root directory of the repository under the name `.mr_bump`. The config file is a yaml file which contains configurations for Mr Bump.

Users can customise their own defaults by putting the relevent config option in a file called `~/.mr_bump.yml`. Project level configuration will overide these options.

### Slack Integration

Mr Bump includes slack integration with a custom name and icon. To enable Slack integration add the following to your `.mr_bump` config file:

```
slack:
  webhook_url: "https://hooks.slack.com/services/some_custom_webhook"
  username: "Mr Bump"
  icon: "https://path_to_image.png"
```

If you do not wish to use Slack integration, remove the Slack section from your config file.

#### JIRA for Slack

Mr Bump can attatch Jira links to Slack posts. To enable this feature, simply add a Jira URL to the Mr Bump config file under `jira_url`:

```
slack:
  webhook_url: "https://hooks.slack.com/services/some_custom_webhook"
  username: "Mr Bump"
  icon: "https://path_to_image.png"
  jira_url: "https://some_team.atlassian.net"
```

### Post bump commands

Mr Bump allows post bump system commands for actions like deploys. These have to be included in your `.mr_bump` config file in the following format:

```
post_bump:
  release: "release deploy command"
  master: "master deploy command"
```

If you have post bump commands in your config then once you have pushed your changelog and tagged, you will be prompted as follows:

```
Would you like to execute post bump commands?
[Y]es execute / [N]o Im done : y
```

Pressing <kbd>Y</kbd> will execute commands as listed in the config. Pressing <kbd>N</kbd> will complete the bump without executing any further commands.

If you do not include anything under the `post_bump` key in your `.mr_bump` config, you will not be prompted and mr_bump will simply exit after pushing the tags and changelog.

### Customising the changlog format

Your changelog can be customized by using the `markdown_template` configuration option. The template is in mustache format. The allowed parameters are
 * `branch_type`: Bugfix / Feature / Hotfix
 * `dev_id`: The development ID for this feature
 * `comment_lines`: Array of all lines in commit comment
 * `first_commit_line`: The first line of the commit comment
 * `comment_body`: The rest of the lines in the comment

The default is:
```
markdown_template: " * {{branch_type}} - {{dev_id}} - {{first_comment_line}}{{#comment_body}}\n  {{.}}{{/comment_body}}"
```

##Git token

Mr Bump uses the Git Hub API. To do this you require a access token. The token should be stored in `~/.mr_bump.yml`.

To generate your token follow the guide here: https://help.github.com/articles/creating-an-access-token-for-command-line-use/

The git_token file should only contain the token and no new lines or additional text, eg:

```
>> cat ~/.mr_bump.yml
github_api_token: 0d51e8dbc4802d27eebc913bc1e6844a57773076
```
