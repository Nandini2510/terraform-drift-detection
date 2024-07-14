pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:light'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-west-2'  // or your preferred region
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    def planExitCode = sh(script: 'terraform plan -detailed-exitcode', returnStatus: true)
                    
                    switch (planExitCode) {
                        case 0:
                            echo "No changes detected"
                            sendToCloudWatch(false)
                            break
                        case 1:
                            error "Terraform plan failed"
                            break
                        case 2:
                            echo "Changes detected"
                            sendToCloudWatch(true)
                            break
                        default:
                            error "Unexpected Terraform plan exit code: ${planExitCode}"
                    }
                }
            }
        }
    }
}

def sendToCloudWatch(boolean driftDetected) {
    def namespace = sh(script: "aws ssm get-parameter --name /terraform-drift/metric-namespace --query 'Parameter.Value' --output text", returnStdout: true).trim()
    
    sh """
        aws cloudwatch put-metric-data \
            --namespace ${namespace} \
            --metric-name DriftDetected \
            --dimensions Workspace=LocalTestWorkspace \
            --value ${driftDetected ? 1 : 0} \
            --timestamp \$(date +%s)
    """
}