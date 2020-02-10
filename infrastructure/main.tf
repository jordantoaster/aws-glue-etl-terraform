provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "incoming-data-bucket" {
  bucket = "jm-etl-incoming-data"
  acl = "private"
}

resource "aws_s3_bucket" "transformed-data-bucket" {
  bucket = "jm-etl-transformed-data"
  acl = "private"
}

resource "aws_s3_bucket" "artifact-bucket" {
  bucket = "jm-etl-artifacts"
  acl = "private"
}





