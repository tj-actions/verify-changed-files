![CI](https://github.com/tj-actions/verify-changed-files/workflows/CI/badge.svg)
![Update release version.](https://github.com/tj-actions/verify-changed-files/workflows/Update%20release%20version./badge.svg)

# verify-changed-files
A github action to verify that certian files changed during the workflow execution.

```yaml
on:
  pull_request:
    branches:
      - master
  
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
        uses: tj-actions/verify-changed-files@v5
        id: changed_files
        with:
          files: |
             new.txt
             test_directory
      - name: Perform action when files change.
        if: steps.changed_files.outputs.files_changed == 'true'
        run: |
          echo "Do something when files have changed."

```


## Inputs

|   Input       |    type     |  required      |  default                      |  description               |
|:-------------:|:-----------:|:--------------:|:-----------------------------:|:--------------------------:|
| token         |  `string`   |    `true`     | `${{ github.token }}`  <br/>  | github action default token or PAT token |
| files         |  `array`   |    `true`     |                               | List of <br/> file(s)/directory names to check for changes <br/> during workflow execution |
