terraform {
  required_providers {
    jenkins = {
      source  = "taiidani/jenkins"
      version = "0.7.0-beta3"
    }
  }
}

# Configure the Jenkins Provider
provider "jenkins" {
  server_url = "https://cbci.cloudbees.demo/cjoc"    # Or use JENKINS_URL env var
  username   = "admin"                               # Or use JENKINS_USERNAME env var
  password   = "welcome"                             # Or use JENKINS_PASSWORD env var
  ca_cert    = "../../sh_secrets_ps/certs/ca/ca.pem" # Or use JENKINS_CA_CERT env var
}
