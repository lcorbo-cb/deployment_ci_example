import hudson.security.Permission
import jenkins.model.Jenkins
import nectar.plugins.rbac.strategy.RoleMatrixAuthorizationStrategyImpl


def authz_strategy = Class.forName("nectar.plugins.rbac.strategy.RoleMatrixAuthorizationStrategyImpl").newInstance()
Jenkins.instance.authorizationStrategy = authz_strategy
Jenkins.instance.save()
