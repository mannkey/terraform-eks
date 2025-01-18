module "ecr" {
  source    = "./module/ecr"
  ecr_repos = ["repo1", "repo2", "repo3"]
}
