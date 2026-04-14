pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
        // Use your real GitHub link here
                 git 'https://github.com/Yogita2708/Personality-quiz-miniproject-ci-cd.git'
            }
       }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t personality-quiz:latest .'
            }
        }
        stage('Test Docker') {
            steps {
                 bat 'docker ps'
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
                sh 'docker run -d --name quiz-app -p 7000:80 personality-quiz:latest'
            }
        }
    }
    post {
        success { echo '✅ Deployment Successful!' }
        failure { echo '❌ Build Failed - Check logs' }
    }
}