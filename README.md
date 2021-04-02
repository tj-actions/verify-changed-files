[![CI](https://github.com/tj-actions/verify-changed-files/workflows/CI/badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3ACI)
[![Update release version.](https://github.com/tj-actions/verify-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3A%22Update+release+version.%22)

# verify-changed-files
A github action to verify that certian files did or did not change during a workflow execution.

> NOTE: :warning:
> * This action only detects files that have pending uncommited changes during the workflow execution, for running a specific step when a file changes relative to the default branch see: https://github.com/tj-actions/changed-files


```yaml
...

jobs:
  node-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Change text file
        run: |
          echo "Modified" > new.txt
      - name: Change file in directory
        run: |
          echo "Changed" > test_directory/new.txt
      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v5.5
        id: changed_files
        with:
          files: |
             new.txt
             test_directory
             .(py|jpeg)$
             .(sql)$
             ^(mynewfile|custom)
      - name: Display changed files
        if: steps.changed_files.outputs.files_changed == 'true'
        run: |
          echo "Changed files: ${{ steps.changed_files.outputs.changed_files }}"  # Outputs: test_directory/new.txt
      - name: Perform action when files change.
        if: steps.changed_files.outputs.files_changed == 'true'
        run: |
          echo "Do something when files have changed."
```


#### Using the [`contains`](https://docs.github.com/en/actions/reference/context-and-expression-syntax-for-github-actions#contains) function. 

```yaml
...
      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v5.5
        id: changed_files
        with:
          files: |
             new.txt
             test_directory
      - name: Perform action when test_directory changes
        if: contains(steps.changed_files.outputs.changed_files, 'test_directory')
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
| files_changed |  `boolean`  |  `true`       | Indicates that there are outstanding changes |
| changed_files |  `array`    |  `[example.txt, ...]`      | List of file(s)/directory names <br/> that changed <br/> during the workflow execution |
