environment = "prd"
location    = "westeurope"

subscription_id = "3cc59319-eb1e-4b52-b19e-09a49f9db2e7"

dns = {
  subscription_id     = "db34f572-8b71-40d6-8f99-f29a27612144"
  resource_group_name = "rg-platform-dns-prd-uksouth-01"
  domain              = "molyneux.me"
  subdomain           = "www"
}

tags = {
  Environment = "prd",
  Workload    = "molyneux-me",
  DeployedBy  = "GitHub-Terraform",
  Git         = "https://github.com/frasermolyneux/molyneux-me"
}
