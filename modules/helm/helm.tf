resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  create_namespace = var.create_namespace
  values = [
    file("${var.values}")
  ]

  #TODO - Add a section to add sensitive values
}
