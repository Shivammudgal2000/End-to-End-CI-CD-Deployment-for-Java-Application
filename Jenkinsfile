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
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_PASS')]) {
                    bat "${DOCKER_CMD} login -u ${DOCKER_HUB_USER} -p %DOCKER_PASS%"
                    bat "${DOCKER_CMD} build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                    bat "${DOCKER_CMD} tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('4. Docker Push') {
            steps {
                bat "${DOCKER_CMD} push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                bat "${DOCKER_CMD} push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }
        
        // --- NEW TASK 7 STAGE: CONTINUOUS DEPLOYMENT ---
        stage('5. Deploy to Production') {
            steps {
                // Elite Edge: Force-remove the old server to prevent port conflicts, then launch the new version
                bat "${DOCKER_CMD} rm -f live-java-app || exit 0"
                bat "${DOCKER_CMD} run -d -p 8085:8080 --name live-java-app ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }
    }
    
    // This block is appended at the very root level of your Jenkinsfile inside the 'post' block
post {
    success {
        mail to: 'team-alerts@yourcompany.com',
             subject: "Pipeline Success: Build #${env.BUILD_NUMBER} is LIVE",
             body: "The End-to-End CI/CD deployment for Build #${env.BUILD_NUMBER} completed successfully on Docker Swarm."
    }
    failure {
        mail to: 'dev-leads@yourcompany.com',
             subject: "CRITICAL PIPELINE FAILURE: Build #${env.BUILD_NUMBER}",
             body: "Build #${env.BUILD_NUMBER} failed during execution. Please check the console logs at: ${env.BUILD_URL}"
    }
}
}