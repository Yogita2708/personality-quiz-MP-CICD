pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Pull code from GitHub
                git 'https://github.com/YOUR_USERNAME/personality-quiz.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t personality-quiz:latest .'
            }
        }
        stage('Test') {
            steps {
                // Check the HTML file exists (simple test)
                sh 'test -f index.html && echo "File exists - PASS"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker stop quiz-app || true'
                sh 'docker rm quiz-app || true'
                sh 'docker run -d --name quiz-app -p 8080:80 personality-quiz:latest'
            }
        }
    }
    post {
        success { echo '✅ Deployment Successful!' }
        failure { echo '❌ Build Failed - Check logs' }
    }
}