# Create a VPC network
resource "google_compute_network" "vpc-public" {
  name = "vpc-public"
  auto_create_subnetworks = false
}
# Define a list of regions and corresponding subnet configurations
locals {
  regions = [
    {
      region     = "us-central1",
      subnet_cidr = "10.0.0.0/28",
    },
    {
      region     = "us-east1",
      subnet_cidr = "10.10.0.0/28",
    },
    {
      region     = "europe-west1",
      subnet_cidr = "10.10.10.0/28",
    },
  ]
}
# Create subnets in each region
resource "google_compute_subnetwork" "subnets-vpc" {
  count       = length(local.regions)
  name        = "subnet-${local.regions[count.index].region}-vpc-public"
  network     = google_compute_network.vpc-public.self_link
  region      = local.regions[count.index].region
  ip_cidr_range = local.regions[count.index].subnet_cidr
}
