resource "kubernetes_deployment" "settlement_worker" {
  metadata {
    name = "payments-api-settlement_worker"
    labels = {
      app       = "payments-api"
      component = "settlement_worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "settlement_worker"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "settlement_worker"
        }
      }

      spec {
        container {
          name    = "settlement_worker"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.settlement_worker"]
        }
      }
    }
  }
}
