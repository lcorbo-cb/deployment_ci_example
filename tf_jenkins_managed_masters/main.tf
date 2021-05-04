terraform {
  required_providers {
    jenkins = {
      source  = "taiidani/jenkins"
      version = "0.7.0-beta3"
    }
  }
}

module "Master01" {

  source = "./modules/performance_test_template"

  providers = {
    jenkins = jenkins.master01
  }
}

module "Master02" {

  source = "./modules/performance_test_template"

  providers = {
    jenkins = jenkins.master02
  }
}
