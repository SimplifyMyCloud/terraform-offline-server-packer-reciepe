# Ensure an offline Terraform server using local GCP Provider files
source "googlecompute" "terraform-offline" {
  project_id              = "simplifymycloud-dev"
  source_image_family     = "rocky-linux-8"
  ssh_username            = "packer"
  use_os_login            = true
  zone                    = "us-west1-c"
  subnetwork              = "smc-dev-subnet-01"
  image_name              = "terraform-offline-v.0.1"
  image_description       = "Debian 11 golden image v.0.1"
  image_storage_locations = ["us-west1"]
}

build {
  sources = ["sources.googlecompute.terraform-offline"]
  provisioner "shell" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install unzip -y",
      "sudo dnf install wget -y",
      "sudo dnf install git -y",
    ]
  }
}