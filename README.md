[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge\&logo=ubuntu\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Mac OS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge\&logo=macos\&logoColor=F0F0F0)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge\&logo=windows\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Public workflows that use this action.](https://img.shields.io/endpoint?style=for-the-badge\&url=https%3A%2F%2Fused-by.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3Dtj-actions%2Fverify-changed-files%26badge%3Dtrue)](https://github.com/search?o=desc\&q=tj-actions+verify-changed-files+language%3AYAML\&s=\&type=Code)

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ef128a4f001846f8a5a50316c8d3c5c3)](https://app.codacy.com/gh/tj-actions/verify-changed-files/dashboard?utm_source=gh\&utm_medium=referral\&utm_content=\&utm_campaign=Badge_grade)
[![CI](https://github.com/tj-actions/verify-changed-files/workflows/CI/badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3ACI)
[![Update release version.](https://github.com/tj-actions/verify-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3A%22Update+release+version.%22)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

# verify-changed-files

Verify that certain files or directories did or did not change during the workflow execution.

> \[!NOTE]
>
> *   This action only detects files that have pending uncommitted changes generated during the workflow execution, for running a specific step when a file changes in a pull request or based on a pushed commit
>
>     See: https://github.com/tj-actions/changed-files instead

## Features

*   Fast execution (0-2 seconds on average).
*   Easy to debug.
*   Scales to large repositories.
*   Supports all platforms (Linux, MacOS, Windows).
*   [GitHub-hosted runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners) support
*   [GitHub Enterprise Server](https://docs.github.com/en/enterprise-server@3.3/admin/github-actions/getting-started-with-github-actions-for-your-enterprise/getting-started-with-github-actions-for-github-enterprise-server) support.
*   [self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners) support.
*   Boolean output for detecting uncommitted changes.
*   List all files that changed during the workflow execution.
*   Detect changes to track and untracked files.
*   Restrict change detection to a subset of files:
    *   Using [Glob pattern](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#filter-pattern-cheat-sheet) matching.
        *   Supports Globstar.
        *   Supports brace expansion.
        *   Supports negation.

## Usage

```yaml
...
    steps:
      - uses: actions/checkout@v4

      - name: Change text file
        run: |
          echo "Modified" > new.txt

      - name: Change file in directory
        run: |
          echo "Changed" > test_directory/new.txt

      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v19
        id: verify-changed-files
        with:
          files: |
             *.txt
             test_directory
             action.yml
             **/*.{jpeg,py}
             !*.sql

      - name: Run step only when any of the above files change.
        if: steps.verify-changed-files.outputs.files_changed == 'true'
        env:
          CHANGED_FILES: ${{ steps.verify-changed-files.outputs.changed_files }}
        run: |
          echo "Changed files: $CHANGED_FILES"
        # Outputs: "Changed files: new.txt test_directory/new.txt"
```

### Using the [`contains`](https://docs.github.com/en/actions/learn-github-actions/expressions#contains) function.

```yaml
...
      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v19
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

### Get all unstaged (tracked/untracked) files

```yaml
...
      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v19
        id: verify-changed-files
      
      - name: List all changed tracked and untracked files
        env:
          CHANGED_FILES: ${{ steps.verify-changed-files.outputs.changed_files }}
        run: |
          echo "Changed files: $CHANGED_FILES"
```

If you feel generous and want to show some extra appreciation:

Support this project with a :star:

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[buymeacoffee]: https://www.buymeacoffee.com/jackton1

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->

```yaml
- uses: tj-actions/verify-changed-files@v19
  id: verify-changed-files
  with:
    # Indicates whether to fail if files have changed.
    # Type: boolean
    # Default: "false"
    fail-if-changed: ''

    # Message to display when files have changed and the 
    # `fail-if-changed` input is set to `true`. 
    # Type: string
    # Default: "Files have changed."
    fail-message: ''

    # File/Directory names to check for uncommited changes.
    # Type: string
    files: ''

    # Separator used to split the `files` input
    # Type: string
    # Default: "\n"
    files-separator: ''

    # Indicates whether to match files in `.gitignore`
    # Type: boolean
    # Default: "false"
    match-gitignore-files: ''

    # Relative path under GITHUB_WORKSPACE to the repository
    # Type: string
    # Default: "."
    path: ''

    # Use non-ASCII characters to match files and output the 
    # filenames completely verbatim by setting this to `false` 
    # Type: boolean
    # Default: "true"
    quotepath: ''

    # Apply sanitization to output filenames before being set as 
    # output. 
    # Type: boolean
    # Default: "true"
    safe_output: ''

    # Output string separator.
    # Type: string
    # Default: " "
    separator: ''

```

<!-- AUTO-DOC-INPUT:END -->

## Outputs

<!-- AUTO-DOC-OUTPUT:START - Do not remove or modify this section -->

|                                  OUTPUT                                   |  TYPE  |                   DESCRIPTION                    |
|---------------------------------------------------------------------------|--------|--------------------------------------------------|
| <a name="output_changed_files"></a>[changed\_files](#output_changed_files) | string |              List of changed files               |
| <a name="output_files_changed"></a>[files\_changed](#output_files_changed) | string | Boolean indicating that files have <br>changed.  |

<!-- AUTO-DOC-OUTPUT:END -->

*   Free software: [MIT license](LICENSE)

## Known Limitation

> \[!WARNING]
>
> *   Using characters like `\n`, `%`, `.` and `\r` as output string separators would be [URL encoded](https://www.w3schools.com/tags/ref_urlencode.asp)

## Report Bugs

Report bugs at https://github.com/tj-actions/verify-changed-files/issues.

If you are reporting a bug, please include:

*   Your operating system name and version.
*   Any details about your workflow that might be helpful in troubleshooting.
*   Detailed steps to reproduce the bug.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/max-kahnt-keylight"><img src="https://avatars.githubusercontent.com/u/79849575?v=4?s=100" width="100px;" alt="Max Kahnt"/><br /><sub><b>Max Kahnt</b></sub></a><br /><a href="https://github.com/tj-actions/verify-changed-files/commits?author=max-kahnt-keylight" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://wllm.no"><img src="https://avatars.githubusercontent.com/u/1223410?v=4?s=100" width="100px;" alt="William Killerud"/><br /><sub><b>William Killerud</b></sub></a><br /><a href="https://github.com/tj-actions/verify-changed-files/commits?author=wkillerud" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Minecraftschurli"><img src="https://avatars.githubusercontent.com/u/23388022?v=4?s=100" width="100px;" alt="Minecraftschurli"/><br /><sub><b>Minecraftschurli</b></sub></a><br /><a href="https://github.com/tj-actions/verify-changed-files/commits?author=Minecraftschurli" title="Code">💻</a> <a href="https://github.com/tj-actions/verify-changed-files/commits?author=Minecraftschurli" title="Documentation">📖</a> <a href="https://github.com/tj-actions/verify-changed-files/commits?author=Minecraftschurli" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://stefanhoth.com"><img src="https://avatars.githubusercontent.com/u/45467?v=4?s=100" width="100px;" alt="Stefan Hoth"/><br /><sub><b>Stefan Hoth</b></sub></a><br /><a href="https://github.com/tj-actions/verify-changed-files/commits?author=stefanhoth" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://home.boidol.dev/"><img src="https://avatars.githubusercontent.com/u/652404?v=4?s=100" width="100px;" alt="Raphael Boidol"/><br /><sub><b>Raphael Boidol</b></sub></a><br /><a href="https://github.com/tj-actions/verify-changed-files/commits?author=boidolr" title="Documentation">📖</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!