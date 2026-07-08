resource "kubernetes_deployment" "refund_processor" {
  metadata {
    name = "payments-api-refund_processor"
    labels = {
      app       = "payments-api"
      component = "refund_processor"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "refund_processor"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "refund_processor"
        }
      }

      spec {
        container {
          name    = "refund_processor"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.refund_processor"]

          # Runtime env from the service-level aggregate ConfigMap + ExternalSecret
          # (managed by MergeProof's aggregate_env_wiring); names are static.
          env_from {
            config_map_ref {
              name = "payments-api-runtime-config"
            }
          }

          env_from {
            secret_ref {
              name = "payments-api-runtime-secrets"
            }
          }
        }
      }
    }
  }
}
