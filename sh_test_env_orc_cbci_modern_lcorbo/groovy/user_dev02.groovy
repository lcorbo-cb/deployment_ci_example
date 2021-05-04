import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("dev01","welcome")
instance.setSecurityRealm(hudsonRealm)
instance.save()
