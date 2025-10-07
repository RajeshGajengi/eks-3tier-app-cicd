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
                
            }
        }

        stage('terraform-init') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh '''
                    cd terraform
                    terraform init
                    '''
                }
            }
        }

        stage('terraform-plan') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh '''
                    cd terraform
                    terraform plan
                    '''
                }
            }
        }

        stage('terraform-apply') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh '''
                    cd terraform
                    terraform apply --auto-approve
                    '''
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
