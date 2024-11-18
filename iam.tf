locals {
  create_glue_role = var.enable_glue_catalog && var.create_glue_role
}

data "aws_region" "current" {}

### Glue ###
data "aws_iam_policy_document" "glue_assume_role" {
  count = local.create_glue_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["appflow.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue" {
  count                 = local.create_glue_role ? 1 : 0
  name                  = coalesce(var.glue_role_name, "${var.name}-glue")
  description           = var.glue_role_description
  path                  = var.glue_role_path
  force_detach_policies = var.glue_role_force_detach_policies
  permissions_boundary  = var.glue_role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.glue_assume_role[0].json
  tags                  = merge(var.tags, var.glue_role_tags)
}

data "aws_iam_policy_document" "glue" {
  count = local.create_glue_role ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "glue:BatchCreatePartition",
      "glue:CreatePartitionIndex",
      "glue:DeleteDatabase",
      "glue:GetTableVersions",
      "glue:GetPartitions",
      "glue:BatchDeletePartition",
      "glue:DeleteTableVersion",
      "glue:UpdateTable",
      "glue:DeleteTable",
      "glue:DeletePartitionIndex",
      "glue:GetTableVersion",
      "glue:CreatePartition",
      "glue:UntagResource",
      "glue:UpdatePartition",
      "glue:TagResource",
      "glue:UpdateDatabase",
      "glue:CreateTable",
      "glue:BatchUpdatePartition",
      "glue:GetTables",
      "glue:BatchGetPartition",
      "glue:GetDatabases",
      "glue:GetPartitionIndexes",
      "glue:GetTable",
      "glue:GetDatabase",
      "glue:GetPartition",
      "glue:CreateDatabase",
      "glue:BatchDeleteTableVersion",
      "glue:BatchDeleteTable",
      "glue:DeletePartition"
    ]
    resources = [
      "arn:aws:glue:::catalog",
      "arn:aws:glue:::database/${var.glue_database_name}",
      "arn:aws:glue:::table/${var.glue_database_name}/${var.glue_table_name}"
    ]
  }
}

resource "aws_iam_policy" "glue" {
  count  = local.create_glue_role ? 1 : 0
  name   = "Glue"
  path   = var.glue_policy_path
  policy = data.aws_iam_policy_document.glue[0].json
  tags   = merge(var.tags, var.glue_role_tags)
}

resource "aws_iam_role_policy_attachment" "glue" {
  count      = local.create_glue_role ? 1 : 0
  role       = aws_iam_role.glue[0].name
  policy_arn = aws_iam_policy.glue[0].arn
}