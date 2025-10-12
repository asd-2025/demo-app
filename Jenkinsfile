pipeline {
  agent any

  stages {

    stage('Checkout') {
      steps {
        // Retrieve code and show short SHA for traceability
        checkout scm
        sh 'git rev-parse --short HEAD'
      }
    }

    stage('Docker sanity') {
      steps {
        // Ensure Docker is available
        sh 'docker --version'
      }
    }

    stage('Build Docker image') {
      when {
        expression {
          // Build only if Dockerfile exists
          return fileExists('Dockerfile')
        }
      }
      steps {
        script {
          // Create a local tag based on short SHA
          def shortSha = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          env.IMAGE_NAME = "demo-app"
          env.IMAGE_TAG  = "local-${shortSha}"
        }
        sh '''
          echo "Building image: ${IMAGE_NAME}:${IMAGE_TAG}"
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
        '''
      }
    }

    stage('Tag for GHCR') {
      steps {
        script {
          // Compute GHCR tag using the same short SHA
          def shortSha = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          env.REGISTRY   = 'ghcr.io'
          env.OWNER      = 'asd-2025'     // change to 'ben-edu' if you prefer under your user
          env.IMAGE_NAME = 'demo-app'
          env.GHCR_TAG   = "${env.REGISTRY}/${env.OWNER}/${env.IMAGE_NAME}:${shortSha}"
        }
        sh '''
          echo "Retagging to: ${GHCR_TAG}"
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${GHCR_TAG}
          docker image ls ${GHCR_TAG}
        '''
      }
    }

    stage('Push to GHCR') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ghcr-pat', usernameVariable: 'GH_USER', passwordVariable: 'GH_PAT')]) {
          sh '''
            set -e
            echo "$GH_PAT" | docker login ghcr.io -u "$GH_USER" --password-stdin
            docker push ${GHCR_TAG}
            docker logout ghcr.io
          '''
        }
      }
    }

    stage('Test') {
      steps {
        echo "Running tests for demo app... (placeholder)"
      }
    }
  }
}
