locals {
  bucket_name = "${var.name_prefix}-bucket-${random_pet.this.id}"
}

resource "random_pet" "this" {
  length = 2
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = true
}

resource "aws_s3_object" "file1" {
  bucket      = local.bucket_name
  key         = "source/customers-100.csv"
  source      = "${path.module}/assets/customers-100.csv"
  source_hash = filemd5("${path.module}/assets/customers-100.csv")
  depends_on  = [aws_s3_bucket.this]
}

resource "aws_s3_object" "file2" {
  bucket      = local.bucket_name
  key         = "source/customers-1000.csv"
  source      = "${path.module}/assets/customers-1000.csv"
  source_hash = filemd5("${path.module}/assets/customers-1000.csv")
  depends_on  = [aws_s3_bucket.this]
}

data "aws_iam_policy_document" "this" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["appflow.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:putobject",
      "s3:getbucketacl",
      "s3:putobjectacl"
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

module "flow" {
  source      = "../../"
  name        = var.name_prefix
  flow_source = "S3"
  destination = "S3"
  source_s3_properties = {
    bucket_name   = local.bucket_name
    bucket_prefix = "source"
    file_type     = "CSV"
  }
  destination_s3_properties = {
    bucket_name   = local.bucket_name
    bucket_prefix = "destination"
    file_type     = "CSV"
  }
  tasks = [
    {
      task_type          = "Merge"
      source_fields      = ["First Name", "Last Name"]
      destination_field  = "First Name,Last Name"
      connector_operator = "NO_OP"
      task_properties = {
        CONCAT_FORMAT = "$${First Name} $${Last Name}"
      }
    },
    {
      task_type          = "Map"
      source_fields      = ["First Name,Last Name"]
      destination_field  = "Full Name"
      connector_operator = "NO_OP"
      task_properties = {
        DESTINATION_DATA_TYPE = "string"
        SOURCE_DATA_TYPE      = "string"
      }
    },
    # {
    #   task_type          = "Filter"
    #   source_fields      = ["First Name,Last Name"]
    #   connector_operator = "PROJECTION"
    #   task_properties = { }
    # }
  ]

  depends_on = [aws_s3_bucket_policy.this]
}