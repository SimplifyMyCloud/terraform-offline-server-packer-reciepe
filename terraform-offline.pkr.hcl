# Ensure an offline Terraform server using local GCP Provider files
source "googlecompute" "terraform-offline" {
  project_id              = "simplifymycloud-dev"
  source_image_family     = "rocky-linux-8"
  ssh_username            = "packer"
  use_os_login            = true
  zone                    = "us-west1-c"
  subnetwork              = "smc-dev-subnet-01"
  image_name              = "terraform-offline-v02"
  image_description       = "Terraform server v.0.1"
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
      "sudo gsutil cp gs://smc-artifact-shelf/terraform/terraform /usr/local/bin/.",
      "sudo chmod 0755 /usr/local/bin/terraform",
      "mkdir -p ~/.terraform.d/plugins/registry.terraform.io/hashicorp/google/4.46.0/linux_amd64",
      "sudo gsutil cp gs://smc-artifact-shelf/gcp-provider-terraform/terraform-provider-google_v4.46.0_x5 ~/.terraform.d/plugins/registry.terraform.io/hashicorp/google/4.46.0/linux_amd64/.",
    ]
  }
}