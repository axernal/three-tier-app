terraform {
  backend "s3" {
    bucket  = "new-bucket-for-statefile"
    key     = "dev-terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}