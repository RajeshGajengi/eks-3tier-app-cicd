pipeline {
    agent any

    environment {
        BACKEND_IMAGE = 'r25gajengi/easy_backend:v2'
        FRONTEND_IMAGE = 'r25gajengi/easy_frontend:v2'
        AWS_REGION = 'us-east-1' // Use consistent region
        CLUSTER_NAME = 'mycluster'
    }

    stages {
        stage('clone-repository') {
            steps {
                git branch: 'main', url: 'https://github.com/RajeshGajengi/EasyCRUD-K8s.git'
            }
        }

        stage('docker-login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                }
            }
        }

        stage('build-backend-image') {
            steps {
                sh '''
                    cd backend
                    docker build -t ${BACKEND_IMAGE} -f docker/backend.dockerfile ./app/backend
                    docker push ${BACKEND_IMAGE}
                '''
            }
        }

        stage('build-frontend-image') {
            steps {
                sh '''
                    cd frontend
                    docker build -t ${FRONTEND_IMAGE} -f docker/frontend.dockerfile ./app/frontend
                    docker push ${FRONTEND_IMAGE}
                '''
            }
        }

        stage('configure-kubectl') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh 'aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}'
                }
            }
        }

        stage('install-nginx-ingress') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml'
                }
            }
        }

        stage('deploy-to-kubernetes') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh '''
                        kubectl apply -f k8s/secrets.yml
                        kubectl apply -f k8s/backend-deployment.yml
                        kubectl apply -f k8s/backend-service.yml
                        kubectl apply -f k8s/frontend-deployment.yml
                        kubectl apply -f k8s/frontend-service.yml
                        kubectl apply -f k8s/ingress.yml
                    '''
                }
            }
        }

        stage('verify-deployment') {
            steps {
                withAWS(credentials: 'aws-cred', region: "${AWS_REGION}") {
                    sh '''
                        kubectl get pods
                        kubectl get svc
                        kubectl get ingress
                    '''
                }
            }
        }
    }
}
