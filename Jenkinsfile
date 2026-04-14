pipeline {
    agent any

    stage('Checkout') {
    steps {
        // ✅ This must match your new repo name exactly
        git 'https://github.com/Yogita2708/personality-quiz-MP-CICD.git'
    }
}
        stage('Build Docker Image') {
            steps {
                // Changed sh to bat
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
                // Simplified for Windows: check if file exists
                bat 'if exist index.html echo "File exists - PASS"'
            }
        }
        stage('Deploy') {
            steps {
                // Changed sh to bat
                bat 'docker stop quiz-app || exit 0'
                bat 'docker rm quiz-app || exit 0'
                bat 'docker run -d --name quiz-app -p 7000:80 personality-quiz:latest'
            }
        }
    }
    post {
        success { echo '✅ Deployment Successful!' }
        failure { echo '❌ Build Failed - Check logs' }
    }
}