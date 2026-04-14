pipeline {
    agent any

    environment {
        // Define the Mumbai Server IP here for easy updates
        SERVER_IP = "13.127.83.173"
        DOCKER_IMAGE = "personality-quiz:latest"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Pulls the latest code from your GitHub repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                // Builds the local Docker image using the Dockerfile in the root
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy to AWS Mumbai') {
            steps {
                script {
                    echo "🚀 Deploying to Mumbai Server: ${SERVER_IP}"
                    
                    /* This block uses the Jenkins SSH Agent. 
                       Requirement: You must have created a credential in Jenkins 
                       with the ID 'aws-mumbai-key'.
                    */
                    sshagent(['aws-mumbai-key']) {
                        bat """
                            ssh -o StrictHostKeyChecking=no ubuntu@${SERVER_IP} "sudo docker stop quiz-app || true && sudo docker rm quiz-app || true && sudo docker run -d --name quiz-app -p 7000:80 ${DOCKER_IMAGE}"
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful!"
            echo "🔗 Visit your app at: http://${SERVER_IP}:7000"
        }
        failure {
            echo "❌ Build Failed. Check the Console Output for errors."
        }
    }
}