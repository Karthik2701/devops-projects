terraform {
  backend "s3" {
    bucket = "terraform-statefile-bucket-0001"
    key = "Jenkins/terraform.tfstate"
    region = "us-east-2"
  }
}