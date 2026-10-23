# Platform Terraform Modules

Reusable Terraform modules for AWS platform infrastructure, shared across application projects.

## Usage

Reference a module by its Git source and pin it to a released version tag:

```hcl
module "example" {
  source = "git::ssh://git@github.com/dragana1986/platform-terraform-modules.git//<module-name>?ref=v1.0.0"

  # module inputs
}
```

Always pin `ref` to a version tag. Never reference a branch, so every project uses a tested, known version.

## Module structure

Each module lives in its own folder and follows the same layout:

| File | Purpose |
|---|---|
| `main.tf` | Resources the module creates |
| `variables.tf` | Inputs the module accepts |
| `outputs.tf` | Values the module exposes to the calling project |
| `versions.tf` | Required Terraform and provider versions |
| `README.md` | What the module does, its inputs, and its outputs |

## Versioning

Releases follow semantic versioning (`MAJOR.MINOR.PATCH`):

| Change | Version |
|---|---|
| Bug fix with no change to inputs or outputs | PATCH, for example `v1.0.1` |
| New, backward-compatible input, output, or feature | MINOR, for example `v1.1.0` |
| Breaking change to existing inputs, outputs, or behavior | MAJOR, for example `v2.0.0` |

## Contributing

1. Create a feature branch from `main`.
2. Run `terraform fmt -recursive` and `terraform validate`.
3. Open a pull request describing the change and its version impact.
4. After merging, create a version tag on `main` to release the change.

