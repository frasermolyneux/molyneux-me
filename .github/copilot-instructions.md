# Copilot Instructions

Molyneux.me is a Jekyll 4.3 static site deployed to Azure Static Web Apps, with Terraform-managed hosting and DNS.

## Layout and boundaries

- Maintained site source is under [`../src`](../src); posts are in [`../src/_posts`](../src/_posts) and site configuration is in [`../src/_config.yml`](../src/_config.yml).
- `../src/_site` is generated output. Change the source and rebuild rather than editing generated files.
- Terraform under [`../terraform`](../terraform) owns the Static Web App, storage, and CNAME binding. It consumes workload and monitoring remote state; it does not create the shared resource groups.
- Environment backend and variable files are paired under `terraform/backends` and `terraform/tfvars`.
- Authentication in workflows is OIDC-based. Do not introduce deployment credentials or hard-coded subscription identifiers.
- Commit each root's `.terraform-version` and `.terraform.lock.hcl`. Select the exact root CLI pin before invoking Terraform; normal initialization uses `-lockfile=readonly`. Regenerate provider selections only in a reviewed dependency-update PR; never commit state, plans, or `.terraform/`.

## Validation

- Site changes: `bundle exec jekyll build` from `src/`.
- Terraform formatting: `terraform -chdir=terraform fmt -check -recursive`.
- Use state-backed Terraform plans only for infrastructure changes with the required environment access.

See [`../docs/development-workflows.md`](../docs/development-workflows.md) for deployment workflow behavior and [`../AGENTS.md`](../AGENTS.md) for the portable execution brief.
