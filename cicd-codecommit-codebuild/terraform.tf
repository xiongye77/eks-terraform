terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-state-code"
    key            = "global/s3/terraform.tfstate"
    #region         = "ap-southeast-2"
    encrypt        = true
  }
}
