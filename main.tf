// Configure Google Cloud provider
provider "google" {
 credentials = file("/home/t/Desktop/Devops/ground-up-app-6b5dc65808cd.json")
 project     = var.project
 region      = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 3
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = var.zone

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

metadata = {
   ssh-keys = "tolu.o@autochek.africa:${file("/home/t/.ssh/toluo-ssh-key.pub")}"
 }


// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; sudo apt install git; pip install flask; pip install flask-migrate; pip install flask-script"
 tags=["all-in", "http" , "ssh"]

 network_interface {
    network = google_compute_network.vpc_network.name

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${var.project}-fw-allow-internal"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["all-in"] 

}
resource "google_compute_firewall" "allow-http" {
  name    = "${var.project}-fw-allow-http"
  network = "${google_compute_network.vpc_network.name}"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"] 
}
resource "google_compute_firewall" "allow-bastion" {
  name    = "${var.project}-fw-allow-bastion"
  network = "${google_compute_network.vpc_network.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
  }


