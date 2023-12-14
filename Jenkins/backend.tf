terraform {
  backend "s3" {
    region = "us-east-2"
    key = "Jenkins/terraform.tfstate"
    bucket = "terraform-statefile-bucket-0001"
  }
}