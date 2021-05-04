# Configure the Jenkins Provider
provider "jenkins" {
  alias      = "master01"
  server_url = "https://cbci.cloudbees.demo/master01/" # Or use JENKINS_URL env var
  username   = "admin"                                 # Or use JENKINS_USERNAME env var
  password   = "welcome"                               # Or use JENKINS_PASSWORD env var
  ca_cert    = "../../sh_secrets_ps/certs/ca/ca.pem"   # Or use JENKINS_CA_CERT env var
}

provider "jenkins" {
  alias      = "master02"
  server_url = "https://cbci.cloudbees.demo/master02/" # Or use JENKINS_URL env var
  username   = "admin"                                 # Or use JENKINS_USERNAME env var
  password   = "welcome"                               # Or use JENKINS_PASSWORD env var
  ca_cert    = "../../sh_secrets_ps/certs/ca/ca.pem"   # Or use JENKINS_CA_CERT env var
}
