[![Codacy Badge](https://api.codacy.com/project/badge/Grade/a3bbaf5dc7534b4a9bf9eaef49e41b34)](https://app.codacy.com/gh/tj-actions/verify-changed-files?utm_source=github.com\&utm_medium=referral\&utm_content=tj-actions/verify-changed-files\&utm_campaign=Badge_Grade_Settings)
[![CI](https://github.com/tj-actions/verify-changed-files/workflows/CI/badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3ACI)
[![Update release version.](https://github.com/tj-actions/verify-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3A%22Update+release+version.%22)
[![Public workflows that use this action.](https://img.shields.io/endpoint?url=https%3A%2F%2Fapi-tj-actions1.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3Dtj-actions%2Fverify-changed-files%26badge%3Dtrue)](https://github.com/search?o=desc\&q=tj-actions+verify-changed-files+language%3AYAML\&s=\&type=Code)

[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Mac OS](https://img.shields.io/badge/mac%20os-000000?logo=macos\&logoColor=F0F0F0)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Windows](https://img.shields.io/badge/Windows-0078D6?logo=windows\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

# verify-changed-files

Verify that certain files or directories did or did not change during the workflow execution.

## Features

*   Boolean output for detecting uncommited changes.
*   List all files that changed during the workflow execution.
*   Restrict change detection to a subset of files.
    *   [Regex pattern](https://www.gnu.org/software/grep/manual/grep.html#Regular-Expressions) matching on a subset of files.

## Usage

> NOTE: :warning:
>
> *   This action only detects files that have pending uncommited changes generated during the workflow execution, for running a specific step when a file changes relative to the default branch or previous commit
>
>     See: https://github.com/tj-actions/changed-files
>

```yaml
...
    steps:
      - uses: actions/checkout@v2

      - name: Change text file
        run: |
          echo "Modified" > new.txt

      - name: Change file in directory
        run: |
          echo "Changed" > test_directory/new.txt

      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v8.8
        id: verify-changed-files
        with:
          files: |
             new.txt
             test_directory
             .(py|jpeg)$
             \.sql$
             ^(mynewfile|custom)

      - name: Run step only when files change.
        if: steps.verify-changed-files.outputs.files_changed == 'true'
        run: |
          echo "Changed files: ${{ steps.verify-changed-files.outputs.changed_files }}"
        # Outputs: "Changed files: new.txt test_directory/new.txt"
```

#### Using the [`contains`](https://docs.github.com/en/actions/learn-github-actions/expressions#contains) function.

```yaml
...
      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v8.8
        id: verify-changed-files
        with:
          files: |
             new.txt
             test_directory

      - name: Perform action when test_directory changes
        if: contains(steps.verify-changed-files.outputs.changed_files, 'test_directory')
        run: |
          echo "test_directory has changed."
```

If you feel generous and want to show some extra appreciation:

Support this project with a :star:

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[buymeacoffee]: https://www.buymeacoffee.com/jackton1

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png

## Inputs

|   Input       |    type     |  required      |  default                      |  description               |
|:-------------:|:-----------:|:--------------:|:-----------------------------:|:--------------------------:|
| token         |  `string`   |    `true`     | `${{ github.token }}`  <br/>  | [GITHUB\_TOKEN](https://docs.github.com/en/free-pro-team@latest/actions/reference/authentication-in-a-workflow#using-the-github_token-in-a-workflow) <br /> or a repo scoped <br /> [Personal Access Token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) |
| files         |  `string[]` OR `string`     |    `true`     |                               |  Check for uncommited changes <br> using only <br> these list of file(s)  |
| autocrlf      |  `string`   |    `true`   |    `input`    |  Modify the [core.autocrlf](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration#_core_autocrlf) <br> setting possible values <br> (true, false, input).  |
| separator	    |  `string`   |	  `true`   |	`' '`	 |  Output string separator  |

## Outputs

|   Input       |    type     |  example      |  description               |
|:-------------:|:-----------:|:-------------:|:--------------------------:|
| files\_changed |  `string`  |  `true` OR `false`       | Indicates that there are outstanding changes |
| changed\_files |  `string`    |  `example.txt ...`      | List of file(s)/directory names <br/> that changed <br/> during the workflow execution |

*   Free software: [MIT license](LICENSE)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

<table>
  <tr>
    <td align="center"><a href="https://github.com/max-kahnt-keylight"><img src="https://avatars.githubusercontent.com/u/79849575?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Max Kahnt</b></sub></a><br /><a href="https://github.com/tj-actions/verify-changed-files/commits?author=max-kahnt-keylight" title="Documentation">📖</a></td>
    <td align="center"><a href="https://wllm.no"><img src="https://avatars.githubusercontent.com/u/1223410?v=4?s=100" width="100px;" alt=""/><br /><sub><b>William Killerud</b></sub></a><br /><a href="https://github.com/tj-actions/verify-changed-files/commits?author=wkillerud" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
