provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "incoming_data_bucket" {
  bucket = "jm-etl-incoming-data"
  acl = "private"
}

resource "aws_s3_bucket" "transformed_data_bucket" {
  bucket = "jm-etl-transformed-data"
  acl = "private"
}

resource "aws_iam_role" "glue" {
  name = "AWSGlueServiceRoleDefault"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glue_service" {
    role = "${aws_iam_role.glue.id}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "my_s3_policy" {
  name = "my_s3_policy"
  role = "${aws_iam_role.glue.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::my_bucket",
        "arn:aws:s3:::my_bucket/*"
      ]
    }
  ]
}
EOF
}

resource "aws_glue_catalog_database" "aws_glue_catalog_database_incoming" {
  name = "incoming_data_catalog"
}

resource "aws_glue_crawler" "incoming_data_bucket_glue_crawler" {
  database_name = "${aws_glue_catalog_database.aws_glue_catalog_database_incoming.name}"
  name = "incoming_data_crawler"
  role = "${aws_iam_role.glue.arn}"

  s3_target {
    path = "s3://${aws_s3_bucket.incoming_data_bucket.bucket}"
  }
}





