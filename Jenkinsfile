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
    env:
    - name: SONAR_USER
      valueFrom:
        secretKeyRef:
          name: sonarqube-creds
          key: username
    - name: SONAR_PWD
      valueFrom:
        secretKeyRef:
          name: sonarqube-creds
          key: password
  - name: docker
    image: docker:24.0.5-dind
    securityContext:
      privileged: true
    command: ['cat']
    tty: true
    env:
    - name: NEXUS_USER
      valueFrom:
        secretKeyRef:
          name: nexus-creds
          key: username
    - name: NEXUS_PWD
      valueFrom:
        secretKeyRef:
          name: nexus-creds
          key: password
    - name: DOCKER_TLS_CERTDIR
      value: ""
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
                    withSonarQubeEnv('SonarQube') {
                        sh "mvn -f app/pom.xml sonar:sonar -Dsonar.host.url=${SONAR_URL} -Dsonar.login=${SONAR_USER} -Dsonar.password=${SONAR_PWD}"
                    }
                }
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build') {
            steps {
                container('docker') {
                    sh """
                    # Start Docker daemon in background
                    dockerd-entrypoint.sh --insecure-registry ${DOCKER_REGISTRY} &
                    sleep 5
                    docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} app/
                    """
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

        stage('Docker Push') {
            steps {
                container('docker') {
                    sh """
                    # Login using container env variables (escaped for Jenkins)
                    echo \$NEXUS_PWD | docker login ${DOCKER_REGISTRY} -u \$NEXUS_USER --password-stdin
                    docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}
                    """
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
                        --set image.tag=${BUILD_NUMBER} \\
                        --wait --timeout 5m
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
