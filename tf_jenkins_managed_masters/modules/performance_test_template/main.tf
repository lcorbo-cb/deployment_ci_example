terraform {
  required_providers {
    jenkins = {
      source  = "taiidani/jenkins"
      version = "0.7.0-beta2"
    }
  }
}

resource "jenkins_folder" "test_jobs" {
  name        = "test_jobs"
  description = "Jobs to test performance."
}

resource "jenkins_job" "test_job" {
  name     = "test_job01"
  folder   = jenkins_folder.test_jobs.id
  template = file("${path.module}/jobs/test_job.xml")

  parameters = {
    credentialsId = "inital test job"
    repoOwner     = "lcorbo-cb"
    repository    = "gitops-app2-example"
    repositoryUrl = "https://github.com/lcorbo-cb/gitops-app2-example.git"
  }
}
