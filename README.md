# GitHub Action for driftctl

`driftctl-action` runs a full driftctl scan in your GitHub Actions workflow.

## Inputs

### `version`

The version of driftctl to install. Default to `latest`.

### `args`

A single string containing any additional arguments or flags to supply to the `scan` command. Defaults to an empty string.

## Example usage

```yml
name: Test Workflow

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Run driftctl
        uses: snyk/driftctl-action@v1
        with:
          version: 0.6.0
```

### How to Contribute

Should you wish to make a contribution please open a pull request against this repository with a clear description of the change with tests demonstrating the functionality.
You will also need to agree to the [Contributor Agreement](https://gist.github.com/snyksec/201fc2fd188b4a68973998ec30b57686) before the code can be accepted and merged.
