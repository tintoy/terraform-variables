# terraform-variables

A quick proof-of-concept: dump all variables in a Terraform configuration as JSON.

Useful for tooling (e.g. generate a UI for entering variable values).

## Usage

1. `go get -u github.com/tintoy/terraform-variables`
2. `cd config-dir`
3. `terraform-variables`

Add `--required` to only dump variables with no default.
