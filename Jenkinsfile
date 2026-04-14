pipeline {
    agent any

    environment {
        SERVER_IP = "13.127.83.173"
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
                    echo "🚀 Deploying to Mumbai Server: ${SERVER_IP}"
                    
                    /* This uses 'withCredentials' which creates a temporary 
                       secret file. It is much more stable on Windows than 'sshagent'.
                    */
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-mumbai-key', keyFileVariable: 'SSH_KEY')]) {
                        bat """
                            @echo off
                            ssh -i %SSH_KEY% -o StrictHostKeyChecking=no ubuntu@${SERVER_IP} "sudo docker stop quiz-app || true && sudo docker rm quiz-app || true && sudo docker run -d --name quiz-app -p 7000:80 ${DOCKER_IMAGE}"
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
}