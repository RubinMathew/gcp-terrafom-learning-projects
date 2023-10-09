# Configure the Google Cloud provider- for projetc my-first-project
# This is a terraform configuration file for creating s simple webserver in  apache in gcp
provider "google" {
  project     = var.project
  region      = var.compute_region
  zone =var.compute_zone
   # credentials = file("<path-to-key-file>.json") or provide your key as environment variable with name GOOGLE_APPLICATION_CREDENTIALS
}

# Create a VPC network
resource "google_compute_network" "vpc-public" {
  name = "vpc-public"
  auto_create_subnetworks = false
}

# Create a subnet within the VPC
resource "google_compute_subnetwork" "subnet1-vpc-public" {
  name          = "subnet1-vpc-public"
  network       = google_compute_network.vpc-public.name
  ip_cidr_range = "10.0.0.0/28"
  region        = "us-central1" # Replace with your desired GCP region
}
# Create a firewall rule to allow internal traffic
resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc-public.name

  allow {
    protocol = "all"
    ports    = []
  }
  source_ranges = ["10.0.0.0/28"] # Allow all internal IP ranges , if you have multiple subnets in the same vpc , then source_ranges = ["10.0.0.0/8","10.10.10.0/28"]
}

# Create a firewall rule to allow SSH traffic
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc-public.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere (for SSH)
}

# Create a firewall rule to allow RDP traffic (optional)
resource "google_compute_firewall" "allow-rdp" {
  name    = "allow-rdp"
  network = google_compute_network.vpc-public.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere (for RDP)
}

# Create a firewall rule to allow ICMP traffic (ping) 
resource "google_compute_firewall" "allow-icmp" {
  name    = "allow-icmp"
  network = google_compute_network.vpc-public.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere (for ICMP)
}

# Create a firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow-http" {
  name          = "allow-http"
  network       = google_compute_network.vpc-public.name # Replace with the actual VPC name
  direction     = "INGRESS"
  priority      = 1000 # Adjust the priority as needed
  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere
  target_tags   = ["http-server"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}
# Create a firewall rule to allow  HTTPS traffic
resource "google_compute_firewall" "allow-https" {
  name          = "allow-https"
  network       = google_compute_network.vpc-public.name # Replace with the actual VPC name
  direction     = "INGRESS"
  priority      = 1000 # Adjust the priority as needed
  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere
  target_tags   = ["https-server"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

# Create a Google Cloud VM instance with a startup script
resource "google_compute_instance" "instance-tf-rbn-pc" {
 name = "instance-tf-rbn-pc"
    network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    subnetwork=google_compute_subnetwork.subnet1-vpc-public.name
  }

  boot_disk {
    auto_delete = true
    device_name = "instance-tf-rbn-pc"
    initialize_params {
      image = var.vm_parametes.os_image
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = var.vm_parametes.machine_type

  metadata = {
    startup-script = "#!/bin/bash\napt update\napt -y install apache2\necho \"<html><body><p> Welcome to the Linux System Server </p><p>Host Machine info :  $(hostname)</p><p>Internal IP: $(hostname -I)</p></body></html>\" > /var/www/html/index.html"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "1234567890-compute@developer.gserviceaccount.com"  #specify your default service account name 
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = var.network_tags  # default value ["http-server", "https-server"] 
  zone = var.compute_zone
}


#End of simple web server configuration file