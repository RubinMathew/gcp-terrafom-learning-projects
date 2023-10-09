
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
