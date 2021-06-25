[![CI](https://github.com/tj-actions/verify-changed-files/workflows/CI/badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3ACI)
[![Update release version.](https://github.com/tj-actions/verify-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3A%22Update+release+version.%22)
[![Public workflows that use this action.](https://img.shields.io/endpoint?url=https%3A%2F%2Fapi-tj-actions1.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3Dtj-actions%2Fverify-changed-files%26badge%3Dtrue)](https://github.com/search?o=desc\&q=tj-actions+verify-changed-files+path%3A.github%2Fworkflows+language%3AYAML\&s=\&type=Code)

# verify-changed-files

Verify that certain files did or did not change during the workflow execution.

## Features

*   Boolean output indicating that there are uncommited changes.
*   List all files that changed during the workflow execution.
*   Restrict change detection to a subset of files.
    *   [Regex pattern](https://www.gnu.org/software/grep/manual/grep.html#Regular-Expressions) matching on a subset of files.

## Supported Platforms

*   [`ubuntu-*`](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
*   [`macos-*`](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
*   [`windows-*`](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)

## Usage

> NOTE: :warning:
>
> *   This action only detects files that have pending uncommited changes generated during the workflow execution, for running a specific step when a file changes relative to the default branch or previous commit
>
>     See: https://github.com/tj-actions/changed-files
> *   Detects files that were `Added`, `Copied`, `Modified`, `Unmerged`, `Unknown`, `Type changed`, `Unstaged` and `Renamed`.

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
        uses: tj-actions/verify-changed-files@v7.1
        id: verify-changed-files
        with:
          files: |
             new.txt
             test_directory
             .(py|jpeg)$
             .(sql)$
             ^(mynewfile|custom)

      - name: Display changed files
        if: steps.verify-changed-files.outputs.files_changed == 'true'
        run: |
          echo "Changed files: ${{ steps.verify_changed_files.outputs.changed_files }}"
        # Outputs: "Changed files: new.txt test_directory/new.txt"

      - name: Perform action when files change.
        if: steps.verify-changed-files.outputs.files_changed == 'true'
        run: |
          echo "Do something when files have changed."
```

#### Using the [`contains`](https://docs.github.com/en/actions/reference/context-and-expression-syntax-for-github-actions#contains) function.

```yaml
...
      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v7.1
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

## Inputs

|   Input       |    type     |  required      |  default                      |  description               |
|:-------------:|:-----------:|:--------------:|:-----------------------------:|:--------------------------:|
| token         |  `string`   |    `true`     | `${{ github.token }}`  <br/>  | github action default token or PAT token |
| files         |  `array`   |    `true`     |                               | List of file(s)/directory names <br/> (regex optional) to check for changes <br/> during workflow execution |

## Outputs

|   Input       |    type     |  example      |  description               |
|:-------------:|:-----------:|:-------------:|:--------------------------:|
| files_changed |  `string`  |  `true` OR `false`       | Indicates that there are outstanding changes |
| changed_files |  `string`    |  `example.txt ...`      | List of file(s)/directory names <br/> that changed <br/> during the workflow execution |

*   Free software: [MIT license](LICENSE)

If you feel generous and want to show some extra appreciation:

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[buymeacoffee]: https://www.buymeacoffee.com/jackton1

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png
