pipeline {
    agent any

    stages {
        // REMOVED the manual 'Checkout' stage because Jenkins does it automatically
        
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t personality-quiz:latest .'
            }
        }

        stage('Deploy to AWS Mumbai') {
            steps {
                script {
                    def serverIp = "13.206.122.231"
                    echo "Deploying to ${serverIp}..."
                    
                    // This command runs SSH from your Jenkins machine to AWS
                    bat """
                        ssh -i my-key.pem -o StrictHostKeyChecking=no ubuntu@${serverIp} "sudo docker stop quiz-app || true && sudo docker rm quiz-app || true && sudo docker run -d --name quiz-app -p 7000:80 personality-quiz:latest"
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful! Check: http://13.206.122.231:7000"
        }
        failure {
            echo '❌ Build Failed'
        }
    }
}