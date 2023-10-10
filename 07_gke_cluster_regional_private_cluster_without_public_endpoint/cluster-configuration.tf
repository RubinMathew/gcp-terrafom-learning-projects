#configure your gke clsuer here
resource "google_container_cluster" "gke-private-cluster" {
  name               = "gke-private-cluster"
  network            = google_compute_network.vpc-public.name
  location = "us-central1" # this is a regional cluster ,if you want a zonal clsuter specify zone name :us-central1-a
  subnetwork         = google_compute_subnetwork.subnets-vpc[1].name #subnet should be available in the location specified above
  deletion_protection = false # Set deletion_protection to false to allow cluster deletion
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28" #it must not overlap with subnet's cidr range, heres where your master nodes are deployed, 

  }
   master_authorized_networks_config {
    # cidr_blocks = ["0.0.0.0/0"] # Allow all IP addresses , adjust as needed 
 
  }

  node_pool {
    name       = "e2-micro-pool"
    node_count = 1   #this is a regional cluster you will get 1 node in each zone , totaly 3 nodes (1 for us-central1-a, us-central1-b, us-central1-b. us-central1-d zone hos no kubernetes support)
    #if this cluster is a zonal cluster , then node_count=1 means , there  only 1 node is generated at the specified zone
    node_config {
      machine_type = "e2-micro"
      disk_size_gb = 10 # Specify the boot disk size here
    }
  }
}

