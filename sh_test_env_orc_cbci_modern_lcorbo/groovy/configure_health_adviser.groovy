import com.cloudbees.jenkins.plugins.advisor.*

println "Configuration of Advisor ..."

def config = AdvisorGlobalConfiguration.instance

config.acceptToS = true
config.isValid = true
config.email = "lcorbo@cloudbees.com"
config.save()

println "Configuration of Advisor done."
