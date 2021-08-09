# GitHub Action to postpone on NewRelic Driftctl summary

`driftctl-newrelic-action` runs a full driftctl scan in your GitHub Actions workflow and create a custom event on Newrelic based on summary output

## Input 

| Input                                             | Description                                        |
|------------------------------------------------------|-----------------------------------------------|
| `new_relic_licence_key`  | {{ SECRET.NEW_RELIC_API_KEY}}    |
| `version`   | driftctl version    |
| `env`   | custom event type name    |
| `filter`   | Is filter is required  (true/false)  |
| `tag_key`   | filter is based on a value from tag key    |
| `tag_value`   | custom event type name    |
| `new_relic_licence_key`   | New Relic Licence key    |
| `event_type_name`   | DriftDeployEvent by default    |
| `tfstate_s3_path`   | s3 tfstate path    |
| `aws_access_key_id`   | AWS access key    |
| `aws_secret_access_key`   | AWS Secret Access Key    |
| `aws_region`   | AWS region    |
| `env`   | environment    |
| `github_repository`   | "{{ github.repository}}"    |
| `github_run_id`   | "{{ github.run_id }}"    |
```
