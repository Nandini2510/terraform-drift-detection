pipeline {
    agent any

    options {
        timeout(time: 1, unit: 'HOURS')
        checkoutToSubdirectory('repo')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-west-2'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform') {
            steps {
                dir('repo') {
                    sh 'terraform init'
                    script {
                        def planExitCode = sh(script: 'terraform plan -detailed-exitcode', returnStatus: true)
                        
                        switch (planExitCode) {
                            case 0:
                                echo "No changes detected"
                                env.DRIFT_DETECTED = 'false'
                                break
                            case 1:
                                error "Terraform plan failed"
                                break
                            case 2:
                                echo "Changes detected"
                                env.DRIFT_DETECTED = 'true'
                                break
                            default:
                                error "Unexpected Terraform plan exit code: ${planExitCode}"
                        }
                    }
                }
            }
        }

        stage('Report to CloudWatch') {
            steps {
                script {
                    def namespace = sh(script: "aws ssm get-parameter --name /terraform-drift/metric-namespace --query 'Parameter.Value' --output text", returnStdout: true).trim()
                    
                    sh """
                        aws cloudwatch put-metric-data \
                            --namespace ${namespace} \
                            --metric-name DriftDetected \
                            --dimensions Workspace=LocalTestWorkspace \
                            --value ${env.DRIFT_DETECTED == 'true' ? 1 : 0} \
                            --timestamp \$(date +%s)
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}