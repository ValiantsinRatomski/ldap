provider "google" {
  credentials = file("terraform-admin.json")
  project     = var.project
  region      = var.region
}

resource "google_compute_instance" "ldap-server" {
  name         = "${var.name}-server"
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

  metadata_startup_script = file("server.sh")
}

resource "google_compute_instance" "ldap-client" {
  name         = "${var.name}-client"
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

  depends_on = [google_compute_instance.ldap-server]
  metadata_startup_script = templatefile("client.sh", {int_ip = google_compute_instance.ldap-server.network_interface.0.network_ip})
}

