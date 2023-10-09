#declare your input variable here 
variable "project" {
#project value will be fetched from terraform.tfvars file
}

#string type declartions compute_zone and compute_region both are equal
variable "compute_zone" {
  default = "us-central1-a" #settings default values
  description = "specify your default compute zone here"
  type = string
}

variable "compute_region" {
  default = "us-central1"
}
#list type variable, here list is restricted to accept only string values,when you specify var.network_tags, it would replace it with default value["http-server", "https-server"]
variable "network_tags" {
    type = list(string)
    description = "placing your network tags for grouping your instances .  "
    default = ["http-server", "https-server"]
}

#object type variable you , can access each object attributes as vm_parametes.machine_type
variable "vm_parametes" {
  type = object({
    machine_type = string
    os_image=string
  })
  description = "specify your vm inital parameters like machine type, os-image"
  default = {
    machine_type = "e2-micro"
    os_image = "projects/debian-cloud/global/images/debian-11-bullseye-v20230912"
   
  }
 
}
 
