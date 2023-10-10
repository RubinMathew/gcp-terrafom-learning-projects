
# Create a firewall rule to allow internal traffic
resource "google_compute_firewall" "allow-internal" {
  name    = "${var.vpcname}-allow-internal"
  network = google_compute_network.vpc-public.name

  allow {
    protocol = "all"
    ports    = []
  }
  source_ranges = ["10.0.0.0/28","10.10.10.0/28","10.10.0.0/28"] # Allow all internal IP ranges , if you have multiple subnets in the same vpc , then source_ranges = ["10.0.0.0/8","10.10.10.0/28"]
}

# Create a firewall rule to allow SSH traffic
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.vpcname}-allow-ssh"
  network = google_compute_network.vpc-public.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere (for SSH)
}

# Create a firewall rule to allow RDP traffic (optional)
resource "google_compute_firewall" "allow-rdp" {
  name    = "${var.vpcname}-allow-rdp"
  network = google_compute_network.vpc-public.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere (for RDP)
}

# Create a firewall rule to allow ICMP traffic (ping) 
resource "google_compute_firewall" "allow-icmp" {
  name    = "${var.vpcname}-allow-icmp"
  network = google_compute_network.vpc-public.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere (for ICMP)
}

# Create a firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow-http" {
  name          = "${var.vpcname}-allow-http"
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
  name          = "${var.vpcname}-allow-https"
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
