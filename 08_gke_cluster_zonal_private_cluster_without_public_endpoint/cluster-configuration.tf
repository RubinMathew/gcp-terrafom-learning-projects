#configure your gke cluster here

resource "google_container_cluster" "gke-private-cluster" {
  name               = "gke-private-cluster"
  network            = google_compute_network.vpc-public.name
  location = "us-central1-a" # this is a zonal cluster ,if you want a regional clsuter specify us-central1
  subnetwork         = google_compute_subnetwork.subnets-vpc[1].name #subnet should be available in the location specified above : location=us-central1-a
  deletion_protection = false # Set deletion_protection to false to allow cluster deletion
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28" #it must not overlap with subnets cidr range, heres where your master nodes are palced which is managed by google

  }
  master_authorized_networks_config {
    # cidr_blocks = ["0.0.0.0/0"] # Allow all IP addresses, adjust as needed 
 
  }
  node_pool {
    name       = "e2-micro-pool"
    node_count = 2   #this is a zonal cluster, yu will get 2 node totally , 
    #if this cluster is a regional cluster , then node_count=2 thats is  6 nodes  are generated (2 for us-central1-a, us-central1-b, us-central1-b. us-central1-d zone hos no kubernetes support)
    node_config {
      machine_type = "e2-micro"
      disk_size_gb = 10 # Specify the boot disk size here
    }
  }
}

