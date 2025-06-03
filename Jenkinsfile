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

                    // For Maven projects, use this instead:
                    // sh 'chmod +x ./mvnw'
                    // sh './mvnw clean package -DskipTests'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run unit tests
                    sh './gradlew test'

                    // For Maven:
                    // sh './mvnw test'
                }

                // Publish test results
                publishTestResults testResultsPattern: 'build/test-results/test/*.xml'
            }
        }

        stage('Code Quality Check') {
            steps {
                script {
                    // Run code quality checks
                    sh './gradlew check'
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
            echo '✅ Build and tests completed successfully, wa zabaaaaaaa!'
        }

        failure {
            echo '❌ Build or tests failed, wa zabaaaaaaa!'
        }
    }
}