# Terraform Drift Detection Project

## Problem Statement
Infrastructure drift occurs when the actual state of your cloud infrastructure diverges from the state defined in your Infrastructure as Code (IaC) files. This project aims to automate the detection of such drift in Terraform-managed AWS resources and report the findings to CloudWatch for monitoring and alerting.

## Solution
We've implemented an automated pipeline using Jenkins that periodically checks for drift in Terraform-managed resources. When drift is detected, it reports this information to AWS CloudWatch, allowing for real-time monitoring and alerting.

## Architecture
Our solution consists of the following components:
1. Jenkins server (running in a Docker container)
2. Terraform configurations for AWS resources
3. AWS CloudWatch for metrics and dashboards
4. GitHub repository for version control

## Flow Diagram
[Insert flow diagram here]

The flow diagram should illustrate the following process:
1. Developer pushes changes to GitHub
2. Jenkins pulls the latest code
3. Jenkins runs Terraform init and plan
4. If drift is detected, Jenkins reports to CloudWatch
5. CloudWatch dashboard updates with drift information
6. (Optional) CloudWatch triggers alerts if configured

## Setup Steps
1. Clone the repository
   ```
   git clone https://github.com/Nandini2510/terraform-drift-detection.git
   cd terraform-drift-detection
   ```

2. Set up Docker and docker-compose
   - Install Docker and docker-compose on your local machine
   - Create a `docker-compose.yml` file for Jenkins

3. Start Jenkins
   ```
   docker-compose up -d
   ```

4. Configure Jenkins
   - Access Jenkins at http://localhost:8080
   - Install suggested plugins
   - Create an admin user
   - Install additional plugins: Git, AWS Steps, Terraform

5. Set up AWS credentials in Jenkins
   - Go to Manage Jenkins > Manage Credentials
   - Add AWS access key ID and secret access key

6. Create Jenkins Pipeline
   - Create a new pipeline job in Jenkins
   - Configure it to use the Jenkinsfile from the GitHub repository

7. Set up Terraform configurations
   - Create `main.tf` with your AWS resource definitions
   - Create `aws_setup.tf` for CloudWatch setup

8. Set up CloudWatch
   - The `aws_setup.tf` file should create necessary CloudWatch resources

9. Run the pipeline
   - Trigger a build in Jenkins to run the drift detection

10. Monitor results
    - Check the CloudWatch dashboard for drift metrics

## Files in the Project
- `Jenkinsfile`: Defines the CI/CD pipeline
- `main.tf`: Main Terraform configuration for AWS resources
- `aws_setup.tf`: Terraform configuration for CloudWatch setup
- `docker-compose.yml`: Docker configuration for running Jenkins
- `.gitignore`: Specifies intentionally untracked files to ignore

## Troubleshooting
- If Jenkins can't find Terraform, ensure it's installed in the Jenkins container
- For AWS credential issues, double-check the credential configuration in Jenkins
- For Docker-related issues, ensure Docker is running and accessible to Jenkins

## Future Improvements
- Implement automated remediation of detected drift
- Extend drift detection to other cloud providers
- Enhance notification system for detected drift