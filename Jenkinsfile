pipeline {
    agent any

    environment {
        SERVER_IP = "52.66.153.245"
        DOCKER_IMAGE = "personality-quiz:latest"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

stage('Deploy to AWS Mumbai') {
    steps {
        script {
            def serverIp = "52.66.153.245"
            echo "🚀 Transferring and Deploying to: ${serverIp}"
            
            withCredentials([sshUserPrivateKey(credentialsId: 'aws-mumbai-key', keyFileVariable: 'SSH_KEY')]) {
                bat """
                    @echo off
                    :: 1. Fix permissions on the temporary key
                    icacls "%SSH_KEY%" /inheritance:r
                    icacls "%SSH_KEY%" /grant:r *S-1-5-18:R
                    
                    :: 2. Transfer the image AND run it (The "Magic" Pipe)
                    docker save personality-quiz:latest | ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no ubuntu@${serverIp} "docker load && sudo docker stop quiz-app || true && sudo docker rm quiz-app || true && sudo docker run -d --name quiz-app -p 7000:80 personality-quiz:latest"
                """
            }
        }
    }
}
}
    post {
        success {
            echo "✅ Deployment Successful!"
            echo "🔗 App Link: http://${SERVER_IP}:7000"
        }
        failure {
            echo "❌ Build Failed. Check Console Output."
        }
    }
    
} // <--- Final bracket that closes the whole "pipeline".stage('Push to Docker Hub') {
   