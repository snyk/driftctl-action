## This project is now in maintenance mode. We cannot promise to review contributions. Please feel free to fork the project to apply any changes you might want to make.

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
          version: 0.38.2
```

## Example usage for scan job with Git comment

> **❗Important❗** `continue-on-error` needs to be set as true so the comment job can complete

```yml
  driftctl:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3    
      - name: driftctl Scan
        id: driftctl
        uses: driftctl-action@v1.2.1
        continue-on-error: true
        
      - name: driftctl Scan Comment
        uses: actions/github-script@v6
        if: github.event_name == 'pull_request'
        env:
          DFCTL_SCAN: "#### driftctl Scan 🔎 ${{ steps.driftctl.outputs.SCAN_OUTPUT }}"
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            const output = `#### driftctl Scan 🔎\`${{ steps.driftctl.outcome }}\`
            <details><summary>Show Scan</summary>
            \n
            ${process.env.DFCTL_SCAN}
            \n
            </details>`;
              github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })
```

### How to Contribute

Should you wish to make a contribution please open a pull request against this repository with a clear description of the change with tests demonstrating the functionality.
You will also need to agree to the [Contributor Agreement](https://gist.github.com/snyksec/201fc2fd188b4a68973998ec30b57686) before the code can be accepted and merged.
