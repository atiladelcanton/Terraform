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
  default = ""
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
