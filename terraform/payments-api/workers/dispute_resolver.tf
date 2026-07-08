resource "kubernetes_deployment" "dispute_resolver" {
  metadata {
    name = "payments-api-dispute_resolver"
    labels = {
      app       = "payments-api"
      component = "dispute_resolver"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "dispute_resolver"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "dispute_resolver"
        }
      }

      spec {
        container {
          name    = "dispute_resolver"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.dispute_resolver"]

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
