locals {

  ## codebuild role
  cb-01-role = {
    name = "${var.service_name}-cb-role"

    policy-01 = {
      name = "${var.service_name}-cb-policy"
    }
    ## policy-02: AmazonEC2ContainerRegistryPowerUser

  }

  ## codepipeline role
  cp-01-role = {
    name = "${var.service_name}-cp-role"

    policy-01 = {
      name = "${var.service_name}-cp-policy"
    }
  }

  ## codedeploy role
  deploy_role = {
    name = "${var.service_name}_deploy_role"

    policy-01 = {
      name = "${var.service_name}_deploy_policy"
    }
  }

  ## cloudwatch events role
  cwe-01-role = {
    name = "${var.service_name}-cwe-role"

    policy-01 = {
      name = "${var.service_name}-cwe-policy"
    }

  }

  ## instance role
  instance_role = {
    name = "${var.service_name}_instance_role"

    policy-01 = {
      name = "${var.service_name}_instance_policy"
    }
    profile = {
      name = "${var.service_name}_profile"
    }
  }

}

# ====================
#
# Codebuild Role
#
# ====================
resource "aws_iam_role" "cb-01-role" {
  name               = local.cb-01-role["name"]
  assume_role_policy = file("./roles/codebuild_role.json")
}
# ====================
#
# Codebuild Policy
#
# ====================
resource "aws_iam_policy" "cb-01-role_policy-01" {
  name   = local.cb-01-role.policy-01["name"]
  policy = file("./policies/codebuild-policy.json")
}

resource "aws_iam_role_policy_attachment" "cb-01-role_policy-01_attach" {
  policy_arn = aws_iam_policy.cb-01-role_policy-01.arn
  role       = aws_iam_role.cb-01-role.id
}

resource "aws_iam_role_policy_attachment" "cb-01-role_policy-02_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.cb-01-role.id
}


# ====================
#
# Codepipeline Role
#
# ====================
resource "aws_iam_role" "cp-01-role" {
  name               = local.cp-01-role["name"]
  assume_role_policy = file("./roles/codepipeline_role.json")
}
# ====================
#
# Codepipeline Policy
#
# ====================
resource "aws_iam_policy" "cp-01-role_policy-01" {
  name   = local.cp-01-role.policy-01["name"]
  policy = file("./policies/codepipeline-policy.json")
}

resource "aws_iam_role_policy_attachment" "cp-01-role_policy-01_attach" {
  policy_arn = aws_iam_policy.cp-01-role_policy-01.arn
  role       = aws_iam_role.cp-01-role.id
}


# ====================
#
# CodeDeploy Role
#
# ====================
resource "aws_iam_role" "deploy_role" {
  name               = local.deploy_role["name"]
  assume_role_policy = file("./roles/codedeploy_role.json")
}
# ====================
#
# CodeDeploy Policy
#
# ====================
resource "aws_iam_policy" "deploy_policy" {
  name   = local.deploy_role.policy-01["name"]
  policy = file("./policies/codedeploy_policy.json")
}

resource "aws_iam_role_policy_attachment" "deploy_policy_attach" {
  policy_arn = aws_iam_policy.deploy_policy.arn
  role       = aws_iam_role.deploy_role.id
}


# ====================
#
# Cloudwatch Events Role
#
# ====================
resource "aws_iam_role" "cwe-01-role" {
  name               = local.cwe-01-role["name"]
  assume_role_policy = file("./roles/cloudwatch_event_role.json")
}
# ====================
#
# Cloudwatch Events Policy
#
# ====================
resource "aws_iam_policy" "cwe-01-role_policy-01" {
  name   = local.cwe-01-role.policy-01["name"]
  policy = file("./policies/cloudwatch-event-policy.json")
}

resource "aws_iam_role_policy_attachment" "cwe-01-role_policy-01_attach" {
  policy_arn = aws_iam_policy.cwe-01-role_policy-01.arn
  role       = aws_iam_role.cwe-01-role.id
}


# ====================
#
# Instance Role
#
# ====================
resource "aws_iam_instance_profile" "instance_role" {
  name = local.instance_role.profile["name"]
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_role" "instance_role" {
  name               = local.instance_role["name"]
  description        = "The role for a instance with jenkins"
  assume_role_policy = file("./roles/instance_role.json")
}
# ====================
#
# Instance Policy
#
# ====================
resource "aws_iam_policy" "instance_policy" {
  name   = local.instance_role.policy-01["name"]
  policy = file("./policies/instance_policy.json")
}

resource "aws_iam_role_policy_attachment" "instance_policy_attach" {
  policy_arn = aws_iam_policy.instance_policy.arn
  role       = aws_iam_role.instance_role.id
}
