resource "kubernetes_deployment" "payout_settlement_worker" {
  metadata {
    name = "payments-api-payout_settlement_worker"
    labels = {
      app       = "payments-api"
      component = "payout_settlement_worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "payout_settlement_worker"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "payout_settlement_worker"
        }
      }

      spec {
        container {
          name    = "payout_settlement_worker"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.payout_settlement_worker"]

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
