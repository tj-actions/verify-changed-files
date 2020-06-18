# verify-changed-files
A github action to verify changed files.

```yaml
...:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      # .....................
      # Make changes to files
      # .....................
      - name: Run Find changed files.
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
| files         |  `string`   |    `false`     |                               | Comma separated list of file/directory names to check for changes during workflow execution |
