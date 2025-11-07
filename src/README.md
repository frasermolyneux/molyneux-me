# Molyneux.me - Personal Blog

This is a Jekyll-based static website deployed to Azure Static Web Apps.

## Project Structure

The project has been restructured to follow best practices:

- `/src/` - Contains all Jekyll source files
  - `_config.yml` - Jekyll configuration
  - `_posts/` - Blog posts
  - `Gemfile` - Ruby dependencies
  - `404.html`, `about.markdown`, `index.markdown` - Site pages
  - `staticwebapp.config.json` - Azure Static Web Apps configuration
- `/terraform/` - Infrastructure as Code
- `/.github/workflows/` - CI/CD pipelines

## Local Development

To run the site locally:

1. Navigate to the `src` directory:
   ```bash
   cd src
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Start the development server:
   ```bash
   bundle exec jekyll serve
   ```

The site will be available at `http://localhost:4000`.

## Deployment

The site is automatically deployed to Azure Static Web Apps when changes are pushed to the main branch. The GitHub Actions workflow:

1. Builds the Terraform infrastructure (dev and prod environments)
2. Builds the Jekyll site from the `src` directory
3. Deploys the generated `_site` folder to Azure Static Web Apps

## Changes Made

This restructure moves all Jekyll source files into a `/src` directory to match the pattern used in other projects and provides better organization between source code and infrastructure code.