#configure your gke cluster here
resource "google_container_cluster" "gke-private-cluster" {
  name               = "gke-private-cluster"
  network            = google_compute_network.vpc-public.name
  location = "us-central1" # this is a zonal cluster ,if you want a regional cluster specify us-central1
  subnetwork         = google_compute_subnetwork.subnets-vpc[1].name #subnet should be available in the location specified above is subnet shoulf be available at us-central1
  deletion_protection = false # Set deletion_protection to false to allow cluster deletion
  
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    
    enable_private_endpoint = false  # master nodes can assesss from public endpoint and can use kubectl commands , if it is true you cannot have a public end point and you cannot use kubectl commands from gcloud shell to access private gke
    enable_private_nodes    = true #cluster nodes are private 
    master_ipv4_cidr_block  = "172.16.0.0/28" #it must not overlap with subnets cidr range, heres where your master nodes are palced which is managed by google

  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0" #master node is exposed to public internet in oder to execute kubectl commands from gcloud shell machine , but in production , this is not a good practise
    }
  }
  node_pool {
    name       = "e2-micro-pool"
    node_count = 1   #this is a regional cluster, you will get 3 nodes totally(1 for us-central1-a, us-central1-b, us-central1-b. us-central1-d zone hos no kubernetes support) , 
    #if this cluster is a zonal cluster , then node_count=1 means , there  1 node is generated in the zonespecified as location 
    node_config {
      machine_type = "e2-micro"
      disk_size_gb = 10 # Specify the boot disk size here
    }
  }
}

