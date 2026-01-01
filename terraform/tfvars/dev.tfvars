environment = "dev"
location    = "westeurope"

subscription_id = "ef3cc6c2-159e-4890-9193-13673dded835"

dns = {
  subscription_id     = "db34f572-8b71-40d6-8f99-f29a27612144"
  resource_group_name = "rg-platform-dns-prd-uksouth-01"
  domain              = "molyneux.me"
  subdomain           = "www.dev"
}

platform_monitoring_state = {
  resource_group_name  = "rg-tf-platform-monitoring-dev-uksouth-01"
  storage_account_name = "sa9d99036f14d5"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
  subscription_id      = "7760848c-794d-4a19-8cb2-52f71a21ac2b"
  tenant_id            = "e56a6947-bb9a-4a6e-846a-1f118d1c3a14"
}

platform_workloads_state = {
  resource_group_name  = "rg-tf-platform-workloads-prd-uksouth-01"
  storage_account_name = "sadz9ita659lj9xb3"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
  subscription_id      = "7760848c-794d-4a19-8cb2-52f71a21ac2b"
  tenant_id            = "e56a6947-bb9a-4a6e-846a-1f118d1c3a14"
}

tags = {
  Environment = "dev",
  Workload    = "molyneux-me",
  DeployedBy  = "GitHub-Terraform",
  Git         = "https://github.com/frasermolyneux/molyneux-me"
}
