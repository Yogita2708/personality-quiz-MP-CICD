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
                    def serverIp = "13.127.83.173"
                    echo "🚀 Deploying to Mumbai Server: ${serverIp}"
                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'aws-mumbai-key', keyFileVariable: 'SSH_KEY')]) {
                        bat """
                            @echo off
                            :: 1. Disable inheritance (strips the 'Users' group)
                            icacls "%SSH_KEY%" /inheritance:r
                            
                            :: 2. Grant only the current user and SYSTEM read access
                            icacls "%SSH_KEY%" /grant:r *S-1-5-18:R
                            icacls "%SSH_KEY%" /grant:r "%USERNAME%":R
                            
                            :: 3. Run the SSH command
                            ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no ubuntu@${serverIp} "sudo docker stop quiz-app || true && sudo docker rm quiz-app || true && sudo docker run -d --name quiz-app -p 7000:80 ${DOCKER_IMAGE}"
                        """
                    }
                }
            }
        }
    } // <--- This was missing! It closes the "stages" block.

    post {
        success {
            echo "✅ Deployment Successful!"
            echo "🔗 App Link: http://${SERVER_IP}:7000"
        }
        failure {
            echo "❌ Build Failed. Check Console Output."
        }
    }
} // <--- Final bracket that closes the whole "pipeline".