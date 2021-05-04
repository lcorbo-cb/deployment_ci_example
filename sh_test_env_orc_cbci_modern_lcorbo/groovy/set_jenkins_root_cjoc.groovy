import jenkins.model.JenkinsLocationConfiguration

println "Setting Jenkins Root URL ..."

jlc = JenkinsLocationConfiguration.get()
jlc.setUrl("https://cbci.cloudbees.demo/cjoc")
jlc.save()

println "... Jenkins Root URL Complete"
