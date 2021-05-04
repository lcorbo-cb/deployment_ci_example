terraform {
  required_providers {
    jenkins = {
      source  = "taiidani/jenkins"
      version = "0.7.0-beta3"
    }
  }
}

module "Team01" {

  source = "./modules/performance_test_template"

  name = "team01"

  providers = {
    jenkins = jenkins.team01
  }
}

module "Team02" {

  source = "./modules/performance_test_template"

  name = "team02"

  providers = {
    jenkins = jenkins.team02
  }
}
