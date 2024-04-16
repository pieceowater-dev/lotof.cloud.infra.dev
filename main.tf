# -------------------BACKEND--------------------

locals {
  tfstate_bucket_name = "pcwt-terraform-state-bucket"
}

terraform {
  backend "s3" {
    bucket         = "pcwt-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
  }
}

# ------------------Provider--------------------

provider "aws" {
  region = var.ProviderRegion
}

# ---------------------Tools---------------------

resource "random_string" "suffix" {
  length  = 8
  special = false
}