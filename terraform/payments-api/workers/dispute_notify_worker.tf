resource "kubernetes_deployment" "dispute_notify_worker" {
  metadata {
    name = "payments-api-dispute_notify_worker"
    labels = {
      app       = "payments-api"
      component = "dispute_notify_worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "dispute_notify_worker"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "dispute_notify_worker"
        }
      }

      spec {
        container {
          name    = "dispute_notify_worker"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.dispute_notify_worker"]

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
