terraform {

  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  


    time = {
      version = ">= 0.9.0"
      source  = "hashicorp/time"
    }
    random = {
      version = ">= 3.2.0"
      source  = "hashicorp/random"
    }
  }

}