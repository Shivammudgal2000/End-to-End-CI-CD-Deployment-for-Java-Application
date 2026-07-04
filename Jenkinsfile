pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USER = 'shivammudgal' 
        IMAGE_NAME      = 'java-devops-project'
        IMAGE_TAG       = "v${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('1. Git Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('2. Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('3. Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }
        
        stage('4. Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
    }
    
    post {
        always {
            sh "docker rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} || true"
            cleanWs()
        }
    }
}