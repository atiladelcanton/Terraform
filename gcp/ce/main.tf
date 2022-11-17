terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.43.1"
    }
  }
}
variable "gcp_credentials" {
  sensitive=true
  default = {"type":"service_account","project_id":"terraform-sonar-server","private_key_id":"afb2caa86a738e817b9e05a9cb6dcb2f229a2d69","private_key":"-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC0Y59ThC2KOABS\n9rgjKM4DJ/nk2XHnLcKjtflm8qJVZUPLiFdX3buJiD4Z74sKePHmlPPf/wctesjl\nH3EDRYYMxGjMojkU0BPq2jL2hMiyu5w35oJj2stcAel7xK7+GrQiLOg5eNfYoLFK\nqK0apoxWF5jE003OXYBOygguhmU1XbH7jfGPtt1BIdeUA2aXCimhuaCOqb5B+ZQL\nOnlaFP7dJ0KsWSEG3AsjMlOXfKyMua6mhng7WBX3m1ieVt/7r0he8bp0bHe3Lqfq\nxPgajT/zIISqYk61QOT2TBxi6Og4wPVQ/C5AwDcMwHiQkNonfu2NPCts1XVTU0Ly\n7cb5PvF3AgMBAAECggEAGB9MUohAk2pVYhgbsUPxzJ/qEw11kF22WLBrIgunOUvZ\n4DFNcMgLczhKCauBSIy6LcSpxMCfTph2nevG7+ePpfcWhpWDlEIWWm0EV00+uLv4\nMiImj0DWZJQy4KSsEU8z2xrDO9A/mPiKzM+NRRzpc6fN0OBALYJOYqWHU5AQSlg8\nKEbTeFHjyutJtpkfFrz2L4riifBBSesFo9c5jD05SOT4KRigL3ZU22iTiN86q2vI\n7Y56ee3pyUwMLASp0nmO1yVDS4vtXUpEGwtq+1s/TvuaOM/LHKCXMq3dyfqCWhTJ\nmOvgjvVV3q4XWjIIE5qJRu0gtcUSM+NPJGT2BMTBzQKBgQDhD64OOhoDWqGWfsHz\niI/Lojkx4VxkMRJx/2owbObth4pFfXkcTjKsIzmqMYX1u/Cnn+WE2zvv2YJPWk6Y\nd7Vd2vGeeW1QRxKZO0VqCeIG5HnUK9v+6FIQJjD0vHGPMLayEU4dW3ldxBgTM1DH\n6383AyVYdcySbmbzr0pD0j+DgwKBgQDNL9lVK47RH4rziT9a+yiI7uSoWrMXgje7\n7HvjTrZYjBvNSjGNeEo2QNnPzW+UAF8KNau7wq0DrTPI28iBupvuKnm9mH2nm/nN\nAp4LqMw2O0183wmHk4hIFgpEWsRbkfNhY2uY1+a3NDOXEW1IJ2Mi01ai5X673pz4\nxjuo/4fT/QKBgGh0j5MY0lP2L4Max8fQ/PRFEYieEPSLdgUkx1M8aB2cR8eiyaAi\nhxAvtSbRn1wC41nZM3xrCDF04S8VOd83yByMbpHfx6V3pyEpSjlB5v7N8eFQjeWM\nS/Ik15nvEEGmGVUiBQBJIVYsmgPnUDnJihytQBsDaXQY+31kQPKjVUkjAoGAf9+h\nF0Y1FDkPNKVFOaMq6OPQ1ubnk/AQYeqIbungFCEFNpRVe3AK9/LEi4/hSKBOmqNG\nKpaxkof/rN7j/41Xnj8Ubcc6EBnRvSUzb9q7odSlfvvVCYw1M4+gyGa01siHoBsA\ntFlhLK24tR4kOAJr8wk4hf52VAjxVMzd432UndUCgYApUN3l1CLfmqQR/DgSD2HN\nSR7wATOKmEejAN2Ci1U/wAQS/wfJb2E5Z2CMj34BRl6cna6Vz747owObO2KyUldf\nxAohcDt/zvIorl9LOA8oqqYhwvld/mWBtQ3KlNo0yIwQwCvqorsIkJ11jhVG912x\nAM6PVlMn0zuxe/TvCFr24w==\n-----END PRIVATE KEY-----\n","client_email":"terraform-sonar-server@terraform-sonar-server.iam.gserviceaccount.com","client_id":"102379691975241576538","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_x509_cert_url":"https://www.googleapis.com/robot/v1/metadata/x509/terraform-sonar-server%40terraform-sonar-server.iam.gserviceaccount.com"}
}
provider "google" {
  project     = "terraform-sonar-server"
  credentials = var.gcp_credentials
}
resource "google_compute_network" "vpc_network" {
  name                    = "vpc-sonar-server"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "vpc-sonar-server-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_instance" "default" {
  name         = "sonar-server"
  machine_type = "f1-micro"
  zone         = "us-west1-a"
  tags         = ["sonar-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}