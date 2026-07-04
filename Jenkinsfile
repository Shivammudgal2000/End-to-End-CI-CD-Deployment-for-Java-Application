pipeline {
    agent any
    
    environment {
        // Centralized account coordinates
        DOCKER_HUB_USER = 'shivammudgal' // <--- Replace with your actual Docker Hub username
        IMAGE_NAME      = 'java-devops-project'
        IMAGE_TAG       = "v${env.BUILD_NUMBER}"
        
        // Network and File Path Overrides
        DOCKER_HOST     = 'tcp://127.0.0.1:2375'
        MVN_CMD         = '"C:\\apache-maven-3.9.6\\bin\\mvn.cmd"'
        DOCKER_CMD      = '"C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker.exe"'
    }
    
    stages {
        stage('1. Git Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('2. Maven Build') {
            steps {
                bat "${MVN_CMD} clean package"
            }
        }
        
        stage('3. Docker Build & Auth') {
            steps {
                // Elite Edge: Authenticate FIRST to overwrite any dead cached tokens preventing base image pulls
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_PASS')]) {
                    bat "${DOCKER_CMD} login -u ${DOCKER_HUB_USER} -p %DOCKER_PASS%"
                    bat "${DOCKER_CMD} build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                    bat "${DOCKER_CMD} tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('4. Docker Push') {
            steps {
                // Securely transmit the compiled images up to the cloud registry
                bat "${DOCKER_CMD} push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                bat "${DOCKER_CMD} push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }
    }
    
    post {
        always {
            // Cleanup local images and explicitly log out to prevent future token caching issues
            bat "${DOCKER_CMD} rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} || exit 0"
            bat "${DOCKER_CMD} logout || exit 0"
            cleanWs()
        }
    }
}