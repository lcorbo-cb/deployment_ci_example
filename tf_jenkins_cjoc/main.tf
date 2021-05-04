resource "jenkins_folder" "maintenance_job" {
  name        = "maintenance_job"
  description = "A top-level folder"
}

resource "jenkins_folder" "red" {
  name        = "Red"
  description = "Folder for Red Masters."
}

resource "jenkins_folder" "blue" {
  name        = "Blue"
  description = "Folder for Blue Masters."
}

resource "jenkins_job" "backup_cjoc" {
  name     = "backup_cjoc"
  folder   = jenkins_folder.maintenance_job.id
  template = file("${path.module}/jobs/backup_cjoc.xml")

  parameters = {
    description = "Backs up cjoc master"
  }
}

resource "jenkins_credential_username" "example" {
  scope       = "GLOBAL"
  name        = "github_token"
  username    = "lcorbo-cb"
  password    = var.token
  description = "This is token to access github."
}
