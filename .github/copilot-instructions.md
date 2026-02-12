# Copilot Instructions

- Stack: Jekyll 4.3 with minima theme; all source lives under [src](src) (posts in [src/_posts](src/_posts), config in [src/_config.yml](src/_config.yml), Static Web Apps routing in [src/staticwebapp.config.json](src/staticwebapp.config.json)). Never edit the generated [src/_site](src/_site) output.
- Local dev: `cd src && bundle install && bundle exec jekyll serve` builds to `_site` and serves on port 4000; `bundle exec jekyll build` runs a production build for CI parity.
- Terraform: infra under [terraform](terraform) provisions the Static Web App and CNAME binding using Free SKU; custom domain validated via CNAME delegation. Backends in [terraform/backends](terraform/backends) and vars in [terraform/tfvars](terraform/tfvars) pair with OIDC-enabled remote states for platform workload/monitoring (`platform_workloads_state`, `platform_monitoring_state`). No resource group is created here—RGs come from platform remote state.
- Key variables: set `subscription_id`, `dns` object (subscription, RG, domain, subdomain), and remote state coordinates per environment. Names derive from `workload_name`, `environment`, `location` into `stapp-{workload}-{environment}-{location}` and storage account `sa{random_id}`.
- GitHub Actions workflows (see [ .github/workflows](.github/workflows)):
  - `build-and-test`: feature/bugfix/hotfix pushes; installs Ruby 3.3 and runs Jekyll build.
  - `pr-verify`: all PRs; always build, does dev TF plan, optional dev apply+deploy when labeled `deploy-dev`, optional prd plan when labeled `run-prd-plan`; skips TF for drafts/dependabot.
  - `deploy-dev`: manual dev plan/apply + deploy; `deploy-prd`: main pushes + weekly schedule -> dev apply/deploy then prd apply/deploy.
  - `codequality`: weekly + PR/main for SonarCloud + CodeQL; `destroy-*` workflows are manual cleanups; `dependabot-automerge` manages bot updates.
- Azure auth: workflows rely on GitHub environment OIDC vars (`AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`). Static Web App deploy pulls API key via `az staticwebapp secrets list` in workflows.
- Docs: [docs/development-workflows.md](docs/development-workflows.md) documents branch/label rules, concurrency guards, and quick reference for pipelines.
- Patterns: keep markdown/front matter in posts; exclude infra/editor folders via `_config.yml` `exclude` list. Static site assets stay under `src`; infra under `terraform` to mirror other platform static sites.
