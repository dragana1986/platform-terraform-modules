data "aws_iam_policy_document" "app_assume_role" {

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_role" {
  name               = "${var.name}-app-role"
  description        = "The IAM role assumed by the application servers through their instance profile"
  assume_role_policy = data.aws_iam_policy_document.app_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name}-app-role"
  })
}

resource "aws_iam_role_policy_attachment" "app_ssm_attachment" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "app_role_permissions" {

  statement {
    actions = ["s3:GetObject"]
    effect  = "Allow"

    resources = ["${var.artifact_bucket_arn}/*"]
  }
}

resource "aws_iam_role_policy" "app_artifact_read" {
  name   = "${var.name}-app-artifact-read"
  role   = aws_iam_role.app_role.id
  policy = data.aws_iam_policy_document.app_role_permissions.json
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.name}-app-instance-profile"
  role = aws_iam_role.app_role.name

  tags = merge(var.tags, {
    Name = "${var.name}-app-instance-profile"
  })
}
