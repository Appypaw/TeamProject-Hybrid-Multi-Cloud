# IAM 그룹 만들기
resource "aws_iam_group" "group" {
  name = "FiveLeader-admin"
}

resource "aws_iam_group" "group2" {
  name = "FiveLeader-subadmin"
}

resource "aws_iam_group" "group3" {
  name = "FiveLeader-infra"
}

resource "aws_iam_group" "group4" {
  name = "FiveLeader-storage"
}

# IAM 유저 만들기
resource "aws_iam_user" "user_one" {
  name = "Dev-Yunseob"
}

resource "aws_iam_user" "user_two" {
  name = "Dev-Jeongyeon"
}

resource "aws_iam_user" "user_three" {
  name = "Dev-Woonghyeon"
}

resource "aws_iam_user" "user_four" {
  name = "Dev-Junjae"
}

# IAM 그룹 멤버십 생성
resource "aws_iam_group_membership" "fiveleader-admin" {
  name = "fiveleader-admin"

  users = [
    aws_iam_user.user_one.name,
  ]

  group = aws_iam_group.group.name
}

resource "aws_iam_group_membership" "fiveleader-subadmin" {
  name = "fiveleader-subadmin"

  users = [
    aws_iam_user.user_two.name,
  ]

  group = aws_iam_group.group2.name
}

resource "aws_iam_group_membership" "fiveleader-infra" {
  name = "fiveleader-infra"

  users = [
    aws_iam_user.user_three.name,
  ]

  group = aws_iam_group.group3.name
}

resource "aws_iam_group_membership" "fiveleader-storage" {
  name = "fiveleader-storage"

  users = [
    aws_iam_user.user_four.name
  ]

  group = aws_iam_group.group4.name
}



# IAM 그룹 정책 생성
resource "aws_iam_group_policy" "fiveleader_admin_policy" {
  name  = "fiveleader_admin_policy"
  group = aws_iam_group.group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
          "Effect": "Allow",
          "Action": "*",
          "Resource": "*"
      },
    ]
  })
}

resource "aws_iam_group_policy" "fiveleader_subadmin_policy" {
  name  = "fiveleader_subadmin_policy"
  group = aws_iam_group.group2.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
          "Effect": "Allow",
          "Action": "*",
          "Resource": "*"
      },
    ]
  })
}

resource "aws_iam_group_policy" "fiveleader_infra_policy" {
  name  = "fiveleader_infra_policy"
  group = aws_iam_group.group3.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
          "Action": "ec2:*",
          "Effect": "Allow",
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "elasticloadbalancing:*",
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "cloudwatch:*",
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "autoscaling:*",
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "iam:CreateServiceLinkedRole",
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "iam:AWSServiceName": [
                      "autoscaling.amazonaws.com",
                      "ec2scheduled.amazonaws.com",
                      "elasticloadbalancing.amazonaws.com",
                      "spot.amazonaws.com",
                      "spotfleet.amazonaws.com",
                      "transitgateway.amazonaws.com"
                  ]
              }
          }
      },
      {
          "Effect": "Allow",
          "Action": [
              "ec2:*",
          ],
          "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_group_policy" "fiveleader_storage_policy" {
  name  = "fiveleader_storage_policy"
  group = aws_iam_group.group4.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
          "Effect": "Allow",
          "Action": [
              "s3:*",
              "s3-object-lambda:*"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": [
              "rds:*",
              "application-autoscaling:DeleteScalingPolicy",
              "application-autoscaling:DeregisterScalableTarget",
              "application-autoscaling:DescribeScalableTargets",
              "application-autoscaling:DescribeScalingActivities",
              "application-autoscaling:DescribeScalingPolicies",
              "application-autoscaling:PutScalingPolicy",
              "application-autoscaling:RegisterScalableTarget",
              "cloudwatch:DescribeAlarms",
              "cloudwatch:GetMetricStatistics",
              "cloudwatch:PutMetricAlarm",
              "cloudwatch:DeleteAlarms",
              "cloudwatch:ListMetrics",
              "cloudwatch:GetMetricData",
              "ec2:DescribeAccountAttributes",
              "ec2:DescribeAvailabilityZones",
              "ec2:DescribeCoipPools",
              "ec2:DescribeInternetGateways",
              "ec2:DescribeLocalGatewayRouteTablePermissions",
              "ec2:DescribeLocalGatewayRouteTables",
              "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
              "ec2:DescribeLocalGateways",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeSubnets",
              "ec2:DescribeVpcAttribute",
              "ec2:DescribeVpcs",
              "ec2:GetCoipPoolUsage",
              "sns:ListSubscriptions",
              "sns:ListTopics",
              "sns:Publish",
              "logs:DescribeLogStreams",
              "logs:GetLogEvents",
              "outposts:GetOutpostInstanceTypes",
              "devops-guru:GetResourceCollection"
          ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "pi:*",
          "Resource": "arn:aws:pi:*:*:metrics/rds/*"
      },
      {
          "Effect": "Allow",
          "Action": "iam:CreateServiceLinkedRole",
          "Resource": "*",
          "Condition": {
              "StringLike": {
                  "iam:AWSServiceName": [
                      "rds.amazonaws.com",
                      "rds.application-autoscaling.amazonaws.com"
                  ]
              }
          }
      },
      {
          "Action": [
              "devops-guru:SearchInsights",
              "devops-guru:ListAnomaliesForInsight"
          ],
          "Effect": "Allow",
          "Resource": "*",
          "Condition": {
              "ForAllValues:StringEquals": {
                  "devops-guru:ServiceNames": [
                      "RDS"
                  ]
              },
              "Null": {
                  "devops-guru:ServiceNames": "false"
              }
          }
      }
    ]
  })
}