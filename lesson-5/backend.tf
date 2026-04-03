terraform {
  backend "s3" {
    bucket         = "darya-petrenko-terraform-state"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
