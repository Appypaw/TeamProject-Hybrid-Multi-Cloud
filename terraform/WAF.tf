# WAF 생성
resource "aws_wafv2_web_acl" "fourdollar" {
  name        = "fourdollar"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            block {}
          }

          name = "AnonymousIPList"
        }

        rule_action_override {
          action_to_use {
            block {}
          }

          name = "HostingProviderIPList"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "fourdollar"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            block {}
          }

          name = "NoUserAgent_HEADER"
        }

        rule_action_override {
          action_to_use {
            block {}
          }

          name = "UserAgent_BadBots_HEADER"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SizeRestrictions_QUERYSTRING"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SizeRestrictions_Cookie_HEADER"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SizeRestrictions_BODY"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SizeRestrictions_URIPATH"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "EC2MetaDataSSRF_BODY"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "EC2MetaDataSSRF_COOKIE"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "EC2MetaDataSSRF_URIPATH"
        }

        rule_action_override {
          action_to_use {
            block {}
          }

          name = "EC2MetaDataSSRF_QUERYARGUMENTS"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "GenericLFI_QUERYARGUMENTS"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "GenericLFI_URIPATH"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "GenericLFI_BODY"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "RestrictedExtensions_URIPATH"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "RestrictedExtensions_QUERYARGUMENTS"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "GenericRFI_QUERYARGUMENTS"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "GenericRFI_BODY"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "GenericRFI_URIPATH"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "CrossSiteScripting_COOKIE"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "CrossSiteScripting_QUERYARGUMENTS"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "CrossSiteScripting_BODY"
        }

        rule_action_override {
          action_to_use {
            block {}
          }

          name = "CrossSiteScripting_URIPATH"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "fourdollar"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SQLiExtendedPatterns_QUERYARGUMENTS"
        }

        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SQLi_QUERYARGUMENTS"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SQLi_BODY"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SQLi_COOKIE"
        }
        
        rule_action_override {
          action_to_use {
            block {}
          }

          name = "SQLi_URIPATH"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "fourdollar"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "My-Rules"
    priority = 3

    action {
      block {}
    }

    statement {
      byte_match_statement {
        positional_constraint = "CONTAINS"
        search_string         = "exec"

        field_to_match {
          uri_path {}
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled   = true
      metric_name                  = "fourdollar"
      sampled_requests_enabled     = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "fourdollar"
    sampled_requests_enabled   = true
  }
}

# CloudFront를 테라폼 리소스로 배포시 사용할 것
resource "aws_wafv2_web_acl_association" "acl_association" {
  resource_arn = ""
  web_acl_arn  = aws_wafv2_web_acl.fourdollar.arn
}