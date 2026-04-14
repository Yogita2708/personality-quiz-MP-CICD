pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Fixed the URL to your new repository
                git 'https://github.com/Yogita2708/personality-quiz-MP-CICD.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Using 'bat' for Windows Jenkins
                bat 'docker build -t personality-quiz:latest .'
            }
        }

        stage('Test Docker') {
            steps {
                bat 'docker ps'
            }
        }

        stage('Test') {
            steps {
                // Windows-friendly file check
                bat 'if exist index.html echo "File exists - PASS"'
            }
        }

        stage('Deploy') {
            steps {
                // Use 'exit 0' to prevent errors if container doesn't exist yet
                bat 'docker stop quiz-app || exit 0'
                bat 'docker rm quiz-app || exit 0'
                bat 'docker run -d --name quiz-app -p 7000:80 personality-quiz:latest'
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Build Failed - Check logs'
        }
    }
}