import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("dev02","welcome")
instance.setSecurityRealm(hudsonRealm)
instance.save()
