# verify-changed-files
A github action to verify that certian files changed during the pipeline execution.

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
      # .....................
      # Make changes to files
      # .....................
      - name: Find changed files.
        id: changed_files
        uses: tj-actions/verify-changed-files@v2
        with:
          files: "test.png, new.txt, test_directory"
      - name: Perform action when files change.
        if: steps.changed_files.outputs.files_changed == 'true'
        run: |
          echo "Do something when files have changed."

```


## Inputs

|   Input       |    type     |  required      |  default                      |  description               |
|:-------------:|:-----------:|:--------------:|:-----------------------------:|:--------------------------:|
| token         |  `string`   |    `false`     | `${{ github.token }}`         | github action or PAT token |
| files         |  `string`   |    `false`     |                               | Comma separated list of <br/> file/directory names to check for changes <br/> during workflow execution |
