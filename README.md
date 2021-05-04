[![CI](https://github.com/tj-actions/verify-changed-files/workflows/CI/badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3ACI)
[![Update release version.](https://github.com/tj-actions/verify-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/verify-changed-files/actions?query=workflow%3A%22Update+release+version.%22) 
<a href="https://github.com/search?q=tj-actions+verify-changed-files+path%3A.github%2Fworkflows+language%3AYAML&type=code" target="_blank" title="Public workflows that use this action."><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fapi-git-master.endbug.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3Dtj-actions%2Fverify-changed-files%26badge%3Dtrue" alt="Public workflows that use this action."></a>

# verify-changed-files
A github action to verify that certain files did or did not change during the workflow execution.


> NOTE: :warning:
> * This action only detects files that have pending uncommited changes generated during the workflow execution, for running a specific step when a file changes relative to the default branch 
> 
>      See: https://github.com/tj-actions/changed-files
> * Detects files that were `Added`, `Copied`, `Modified`, `Unmerged`, `Unknown`, `Type changed`, `Unstaged` and `Renamed`.


```yaml
...

jobs:
  build:
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
        uses: tj-actions/verify-changed-files@v6
        id: verify_changed_files
        with:
          files: |
             new.txt
             test_directory
             .(py|jpeg)$
             .(sql)$
             ^(mynewfile|custom)
      - name: Display changed files
        if: steps.verify_changed_files.outputs.files_changed == 'true'
        run: |  # Outputs: "Changed files: new.txt test_directory/new.txt"
          echo "Changed files: ${{ steps.verify_changed_files.outputs.changed_files }}"
      - name: Perform action when files change.
        if: steps.verify_changed_files.outputs.files_changed == 'true'
        run: |
          echo "Do something when files have changed."
```


#### Using the [`contains`](https://docs.github.com/en/actions/reference/context-and-expression-syntax-for-github-actions#contains) function. 

```yaml
...
      - name: Verify Changed files
        uses: tj-actions/verify-changed-files@v6
        id: verify_changed_files
        with:
          files: |
             new.txt
             test_directory
      - name: Perform action when test_directory changes
        if: contains(steps.verify_changed_files.outputs.changed_files, 'test_directory')
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
