resource "aws_iam_role" "ec2_cw_access_role" {
  name               = "cw_role"
  assume_role_policy = file("${path.module}/assume-role-policy.json")
}

resource "aws_iam_policy" "cw_full_policy" {
  name        = "terraform_cw_full_policy"
  description = "Clod Watch Full access policy"
  policy      = file("${path.module}/policy-cloud-watch-full.json")
}

resource "aws_iam_policy_attachment" "terraform_attach" {
  name       = "terraform_policy_attachment"
  roles      = [aws_iam_role.ec2_cw_access_role.name]
  policy_arn = aws_iam_policy.cw_full_policy.arn
}

resource "aws_iam_instance_profile" "terraform_profile" {
  name = "terraform_profile"
  role = aws_iam_role.ec2_cw_access_role.name
}

