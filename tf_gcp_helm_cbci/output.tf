output "url" {
  value = "https://${trimsuffix(module.cbci.url.name, ".")}"
}
