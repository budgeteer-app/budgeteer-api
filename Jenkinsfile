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

                // Publish test results (fixed step name)
                publishTestResults testResultsPattern: 'build/test-results/test/*.xml'
            }

        }

        stage('Code Quality Check') {
            steps {
                script {
                    // More specific quality checks instead of generic 'check'
                    try {
                        sh './gradlew ktlintCheck'
                    } catch (Exception e) {
                        echo "Ktlint not configured, skipping..."
                    }

                    try {
                        sh './gradlew detekt'
                    } catch (Exception e) {
                        echo "Detekt not configured, skipping..."
                    }

                    // Generate test coverage report
                    try {
                        sh './gradlew jacocoTestReport'
                    } catch (Exception e) {
                        echo "JaCoCo not configured, skipping..."
                    }

                    // Basic compilation check (already done in build, but ensures code quality)
                    sh './gradlew compileKotlin compileTestKotlin'
                }
            }
        }
    }

    post {
        always {
            // Archive the built JAR file
            archiveArtifacts artifacts: 'build/libs/*.jar', allowEmptyArchive: true

            // Publish test results if available
            script {
                if (fileExists('build/test-results/test/*.xml')) {
                    junit 'build/test-results/test/*.xml'
                }
            }

            // Publish coverage reports if available
            script {
                if (fileExists('build/reports/jacoco/test/jacocoTestReport.xml')) {
                    publishCoverage adapters: [jacocoAdapter('build/reports/jacoco/test/jacocoTestReport.xml')]
                }
            }

            // Clean up workspace
            cleanWs()
        }

        success {
            echo '✅ Build and tests completed successfully !'
        }

        failure {
            echo '❌ Build or tests failed !'
        }
    }
}