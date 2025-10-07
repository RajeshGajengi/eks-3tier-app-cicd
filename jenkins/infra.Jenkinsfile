pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        GIT_URL = 'https://github.com/RajeshGajengi/eks-3tier-app-cicd.git'
    }

    stages {
        stage('clone-repository') {
            steps {
                git branch: 'main', url: "${GIT_URL}"
                sh 'cd terraform'
            }
        }

        stage('terraform-init') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh 'terraform init'
                }
            }
        }

        stage('terraform-plan') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh 'terraform plan'
                }
            }
        }

        stage('terraform-apply') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh 'terraform apply --auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Infrastructure deployed successfully.'
        }
        failure {
            echo '❌ Deployment failed. Check the logs for more details.'
        }
    }
}
