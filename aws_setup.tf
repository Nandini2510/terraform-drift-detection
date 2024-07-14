provider "aws" {
  region = "us-west-2"
}

resource "aws_ssm_parameter" "metric_namespace" {
  name  = "/terraform-drift/metric-namespace"
  type  = "String"
  value = "TerraformDrift"
}

resource "aws_cloudwatch_dashboard" "terraform_drift_dashboard" {
  dashboard_name = "TerraformDriftDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["TerraformDrift", "DriftDetected", "Workspace", "LocalTestWorkspace"]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = "us-west-2",
          title   = "Terraform Drift - Local Test"
        }
      }
    ]
  })
}