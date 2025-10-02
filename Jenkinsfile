
pipeline {
    agent any
    stages{
        stage('clone reposirory'){
            steps{
                git branch: 'main', url: 'https://github.com/RajeshGajengi/EasyCRUD-K8s.git'
            }
        }
        stage('Docker login'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
                }  
            }
        }
        stage('Build Backend image and push to Docker Hub'){
            steps{
               sh '''
                    cd backend
                    docker build -t r25gajengi/easy_backend:v2 .
                    docker push r25gajengi/easy_backend:v2
                    '''
            }
        }
        
        stage('Build Frontend image adn Push to Docker Hub'){
            steps{
                sh '''
                    cd frontend
                    docker build -t r25gajengi/easy_frontend:v2 .
                    docker push r25gajengi/easy_frontend:v2
                    '''
            }
        }
        stage ('kubernetes configure'){
            steps{
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                sh 'aws eks update-kubeconfig --region ap-south-1 --name mycluster'
            
                }
            }
        }
        stage ('ingress controller download'){
            steps{
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
                sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml'
                }
            }
        }
        stage ('Kubernetes deployment'){
            steps{
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
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
        stage('verify'){
            steps{
                withAWS(credentials: 'aws-cred', region: 'us-east-1') {
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

 
