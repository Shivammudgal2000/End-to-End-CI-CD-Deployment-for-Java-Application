pipeline {
    agent any
    
    environment {
        // Centralized environment variables
        DOCKER_HUB_USER = 'shivammudgal' 
        IMAGE_NAME      = 'java-devops-project'
        IMAGE_TAG       = "v${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('1. Git Checkout') {
            steps {
                // Pulls down repository assets matching configuration targets
                checkout scm
            }
        }
        
        stage('2. Maven Build') {
            steps {
                // Elite Edge: Switched from sh to bat for native Windows script execution
                bat 'mvn clean package'
            }
        }
        
        stage('3. Docker Build') {
            steps {
                // Compiles layer builds using native command blocks
                bat "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                bat "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }
        
        stage('4. Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_PASS')]) {
                    // Safe command parameter parsing for Windows CLI engines
                    bat "docker login -u ${DOCKER_HUB_USER} -p %DOCKER_PASS%"
                    bat "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    bat "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
    }
    
    post {
        always {
            // Safely clear out local images to optimize host storage footprint
            bat "docker rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} || exit 0"
            cleanWs()
        }
    }
}