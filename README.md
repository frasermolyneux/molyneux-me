# molyneux-me

[![Build and Test](https://github.com/frasermolyneux/molyneux-me/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/build-and-test.yml)
[![Code Quality](https://github.com/frasermolyneux/molyneux-me/actions/workflows/codequality.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/codequality.yml)
[![Copilot Setup Steps](https://github.com/frasermolyneux/molyneux-me/actions/workflows/copilot-setup-steps.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/copilot-setup-steps.yml)
[![Dependabot Automerge](https://github.com/frasermolyneux/molyneux-me/actions/workflows/dependabot-automerge.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/dependabot-automerge.yml)
[![Deploy Dev](https://github.com/frasermolyneux/molyneux-me/actions/workflows/deploy-dev.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/deploy-dev.yml)
[![Deploy Prd](https://github.com/frasermolyneux/molyneux-me/actions/workflows/deploy-prd.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/deploy-prd.yml)
[![Destroy Development](https://github.com/frasermolyneux/molyneux-me/actions/workflows/destroy-development.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/destroy-development.yml)
[![Destroy Environment](https://github.com/frasermolyneux/molyneux-me/actions/workflows/destroy-environment.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/destroy-environment.yml)
[![PR Verify](https://github.com/frasermolyneux/molyneux-me/actions/workflows/pr-verify.yml/badge.svg)](https://github.com/frasermolyneux/molyneux-me/actions/workflows/pr-verify.yml)

## Documentation

* [Development Workflows](docs/development-workflows.md) - Branch strategy, CI/CD triggers, and development flows

## Overview

Personal Jekyll site for molyneux.me deployed to Azure Static Web Apps, with Terraform defining DNS and Static Web App resources and GitHub Actions handling build/plan/deploy pipelines. Jekyll sources live under `src` with Terraform in `terraform`, matching the static-site pattern used across the platform. Workflows support feature validation, labeled PR deployments to dev, and automated promotion to production with remote-state dependencies on shared platform stacks.

## Contributing

Please read the [contributing](CONTRIBUTING.md) guidance; this is a learning and development project.

## Security

Please read the [security](SECURITY.md) guidance; I am always open to security feedback through email or opening an issue.

## Local dev: MCP wire-up

This repo is wired to the shared `frasermolyneux-copilot` MCP server (pinned to `frasermolyneux/.github-copilot@v0.1.0`). The setup workflow (`.github/workflows/copilot-setup-steps.yml`) checks the shared catalog into `.github-copilot/`, installs Node 20.x, and builds the server; the Copilot coding agent loads it via `.github/copilot/mcp_config.json`. See [`.github-copilot/mcp-server/README.md`](https://github.com/frasermolyneux/.github-copilot/blob/v0.1.0/mcp-server/README.md) for the tool contract, content-root resolution, and per-client wire-up snippets.

