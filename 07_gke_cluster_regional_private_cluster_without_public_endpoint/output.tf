output "gke_cluster_configuartion_status" {
    value = join(" ",[google_container_cluster.gke-private-cluster.name,"has been created successfully !"])
    #here join function is used to concatinate 2 strings
}