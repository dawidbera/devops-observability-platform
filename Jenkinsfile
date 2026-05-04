pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:3.9-eclipse-temurin-17
    command: ['cat']
    tty: true
  - name: docker
    image: docker:24.0.5-dind
    securityContext:
      privileged: true
    command: ['cat']
    tty: true
  - name: helm
    image: alpine/helm:3.12.0
    command: ['cat']
    tty: true
  - name: trivy
    image: aquasec/trivy:0.44.1
    command: ['cat']
    tty: true
"""
        }
    }

    environment {
        DOCKER_REGISTRY = "nexus-sonatype-nexus.nexus:5000"
        IMAGE_NAME = "demo-app"
        SONAR_URL = "http://sonarqube-sonarqube.sonarqube:9000"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                container('maven') {
                    sh 'mvn -f app/pom.xml clean package'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                container('maven') {
                    // This assumes sonar-maven-plugin is available and credentials are set in Jenkins
                    sh 'mvn -f app/pom.xml sonar:sonar -Dsonar.host.url=${SONAR_URL} -Dsonar.login=admin -Dsonar.password=admin'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                container('docker') {
                    sh "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} app/"
                }
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                container('trivy') {
                    sh "trivy image --severity HIGH,CRITICAL --exit-code 1 ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                container('helm') {
                    sh """
                    helm upgrade --install demo-app cicd/infrastructure/helm/app-chart \\
                        --namespace staging --create-namespace \\
                        --set image.repository=${DOCKER_REGISTRY}/${IMAGE_NAME} \\
                        --set image.tag=${BUILD_NUMBER}
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
