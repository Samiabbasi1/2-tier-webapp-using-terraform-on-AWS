terraform {
  backend "s3" {
    bucket         = "myterras"
    key            = "backend/terraformp2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "remote-backend"
  }
}