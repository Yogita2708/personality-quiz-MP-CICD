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
            def serverIp = "13.127.83.173"
            // We use 'withCredentials' instead of 'sshagent' to avoid the Java error
            withCredentials([sshUserPrivateKey(credentialsId: 'aws-mumbai-key', keyFileVariable: 'SSH_KEY')]) {
                bat """
                    @echo off
                    rem Use the temporary key file created by Jenkins
                    ssh -i %SSH_KEY% -o StrictHostKeyChecking=no ubuntu@${serverIp} "sudo docker stop quiz-app || true && sudo docker rm quiz-app || true && sudo docker run -d --name quiz-app -p 7000:80 personality-quiz:latest"
                """
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