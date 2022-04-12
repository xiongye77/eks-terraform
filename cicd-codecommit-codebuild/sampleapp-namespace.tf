resource "kubernetes_namespace" "sampleapp" {
  metadata {
    name = "sampleapp"
  }

  timeouts {
    delete = "20m"
  }
}
