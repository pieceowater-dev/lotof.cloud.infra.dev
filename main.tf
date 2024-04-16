# -------------------BACKEND--------------------
locals {
  providerRegion = "eu-north-1"
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
  region = local.providerRegion
}

# ---------------------Tools---------------------

resource "random_string" "suffix" {
  length  = 8
  special = false
}

# ---------------------DEVENV--------------------

module "devenv" {
  source        = "./DEV_ENV"
  providerRegion = local.providerRegion
}