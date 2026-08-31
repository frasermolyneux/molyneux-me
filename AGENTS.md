# AGENTS.md — molyneux-me

Personal Jekyll static site for molyneux.me, deployed to Azure Static Web Apps. Terraform provisions DNS + Static Web App + storage; GitHub Actions builds, plans, and deploys.

This file is the brief for the **GitHub Copilot coding agent** (and any other agent that follows the [agents.md](https://agents.md) convention). `.github/copilot-instructions.md` has the same repo orientation for humans in an editor.

---

## Scope

- **Static site**: Jekyll 4.3 (minima theme) under [src](src) — posts in `src/_posts`, config in `src/_config.yml`, Static Web Apps routing in `src/staticwebapp.config.json`. Never edit the generated `src/_site` output.
- **Infrastructure**: Terraform under [terraform](terraform) is the only IaC root. Provisions the Static Web App (Free SKU) and a storage account (images container), plus the DNS CNAME + custom domain validation. The resource group and monitoring action groups are consumed read-only from platform remote state (`platform_workloads_state`, `platform_monitoring_state`) — not created here.
- No application runtime, backend, database, or auth in this repo — static content + infra only.

## Commands

```pwsh
# Jekyll (from src/)
cd src
bundle install
bundle exec jekyll serve   # local dev, serves on :4000
bundle exec jekyll build   # production build, matches CI

# Terraform (from repo root)
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend-config=backends/dev.backend.hcl
terraform -chdir=terraform validate
terraform -chdir=terraform plan -var-file=tfvars/dev.tfvars
```

## State & ownership boundaries

- `terraform/backends/{dev,prd}.backend.hcl` select the remote state backend; `terraform/tfvars/{dev,prd}.tfvars` supply environment variables.
- Remote state is read-only input: `platform_workloads_state` (resource group + admin unit lookup), `platform_monitoring_state` (action group ids). This repo does not own or modify those states.
- `.terraform.lock.hcl` is gitignored repo-wide and not tracked — provider versions are pinned directly in `terraform/providers.tf` (azurerm ~> 5.0.0, time ~> 0.9, terraform >= 1.15.6).
- Ecosystem lockfiles that ARE tracked and must stay: `src/Gemfile.lock` (Ruby bundler).

## Do NOT

- Introduce client secrets, connection strings, or hard-coded subscription IDs beyond what already exists in `terraform/tfvars/*.tfvars`. Auth is OIDC + managed identity only.
- Edit the generated `src/_site` output directly — it is build output, not source.
- Modify `.github/workflows/` or `.github/dependabot.yml` unless that is the explicit task.
- Change the Azure resource naming convention (`stapp-{workload}-{environment}-{location}`, `sa{random_id}`) or tags.
