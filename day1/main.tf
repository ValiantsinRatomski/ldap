provider "google" {
  credentials = file("terraform-admin.json")
  project     = var.project
  region      = var.region
}

resource "google_compute_instance" "ldap" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    access_config {
    }
  }

  metadata_startup_script = file("script.sh")
}

