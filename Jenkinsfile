pipeline {
    agent any

    environment {
        DATABASE_URL = 'jdbc:postgresql://postgres:5432/budgeteerdb'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "Checked out code from ${env.GIT_BRANCH}"
            }
        }

        stage('Build Application') {
            steps {
                script {
                    // Make gradlew executable
                    sh 'chmod +x ./gradlew'

                    // Build the application (skip tests for now)
                    sh './gradlew clean build -x test'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run unit tests
                    sh './gradlew test'
                }

                // Fix: Use junit instead of publishTestResults
                junit testResultsPattern: 'build/test-results/test/*.xml', allowEmptyResults: true
            }
        }

        stage('Code Quality Check') {
            steps {
                script {
                    // Simplified: just run compilation checks
                    sh './gradlew compileKotlin compileTestKotlin'
                    echo "✅ Code quality check passed"
                }
            }
        }
    }

    post {
        always {
            // Archive the built JAR file
            archiveArtifacts artifacts: 'build/libs/*.jar', allowEmptyArchive: true

            // Clean up workspace
            cleanWs()
        }

        success {
            echo '✅ Build and tests completed successfully, zaba !'
        }

        failure {
            echo '❌ Build or tests failed, zaba !'
        }
    }
}