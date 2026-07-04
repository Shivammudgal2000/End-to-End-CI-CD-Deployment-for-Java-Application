pipeline {
    agent any
    
    environment {
        // Centralized account coordinates
        DOCKER_HUB_USER = 'shivammudgal' 
        IMAGE_NAME      = 'java-devops-project'
        IMAGE_TAG       = "v${env.BUILD_NUMBER}"
        
        // Elite Edge: Explicit absolute file system routes wrapped cleanly in internal quotes
        MVN_CMD         = '"C:\\apache-maven-3.9.6\\bin\\mvn.cmd"'
        DOCKER_CMD      = '"C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker.exe"'
    }
    
    stages {
        stage('1. Git Checkout') {
            steps {
                // Extracts remote repository branch files into active workspace
                checkout scm
            }
        }
        
        stage('2. Maven Build') {
            steps {
                // Direct call using the explicit file system path string
                bat "${MVN_CMD} clean package"
            }
        }
        
        stage('3. Docker Build') {
            steps {
                // Direct container build invocation bypassing path resolution engines
                bat "${DOCKER_CMD} build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                bat "${DOCKER_CMD} tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }
        
        stage('4. Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_PASS')]) {
                    // Securely authenticates and transmits artifacts using absolute location execution paths
                    bat "${DOCKER_CMD} login -u ${DOCKER_HUB_USER} -p %DOCKER_PASS%"
                    bat "${DOCKER_CMD} push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    bat "${DOCKER_CMD} push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
    }
    
    post {
        always {
            // Cleanup step ensuring old workspace images are purged without failing the overall pipeline
            bat "${DOCKER_CMD} rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} || exit 0"
            cleanWs()
        }
    }
}