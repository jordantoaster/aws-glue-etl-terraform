provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "incoming_data_bucket" {
  bucket = "jm_etl_incoming_data"
  acl = "private"
}

resource "aws_s3_bucket" "transformed_data_bucket" {
  bucket = "jm_etl_transformed_data"
  acl = "private"
}

resource "aws_iam_service_linked_role" "glue_service_role" {
  aws_service_name = "aws-glue.amazonaws.com"
}

resource "aws_glue_catalog_database" "aws_glue_catalog_database_incoming" {
  name = "incoming_data_catalog"
}

resource "aws_glue_crawler" "incoming_data_bucket_glue_crawler" {
  database_name = "${aws_glue_catalog_database.aws_glue_catalog_database_incoming.name}"
  name = "incoming_data_crawler"
  role = "${aws_iam_service_linked_role.glue_service_role.aws_service_name}"

  s3_target {
    path = "s3://${aws_s3_bucket.incoming_data_bucket.bucket}"
  }
}





