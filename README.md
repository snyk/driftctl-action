# GitHub Action for driftctl

`driftctl-action` runs a full driftctl scan in your GitHub Actions workflow.

## Inputs

### `version`

The version of driftctl to install. Default to `latest`.

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
