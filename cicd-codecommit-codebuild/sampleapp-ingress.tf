resource "kubernetes_ingress" "sampleapp_ingress" {
  metadata {
    annotations = {"kubernetes.io/ingress.class" = "alb", "alb.ingress.kubernetes.io/scheme" = "internet-facing", "alb.ingress.kubernetes.io/target-type" = "ip", "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP","alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]","alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm:ap-southeast-2:996104769930:certificate/1c52f3c2-142b-437e-8f43-5e73d88fe06e","alb.ingress.kubernetes.io/ssl-redirect" = "443" }
    name        = "sampleapp-ingress"
    namespace   = "sampleapp"
  }

  spec {

    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = "sampleapp-service"
            service_port = "80"
          }
        }
      }
    }
  }
}
