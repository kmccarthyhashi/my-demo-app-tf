provider "hcp" {}

data "hcp_packer_iteration" "ubuntu" {
  bucket_name = "packer-demo"
  channel     = "development"
}

data "hcp_packer_image" "ubuntu_us_east_2" {
  bucket_name    = "packer-demo"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.ubuntu.ulid
  region         = "us-east-2"
}