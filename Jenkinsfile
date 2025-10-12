pipeline {
  agent any

  stages {

    stage('Checkout') {
      steps {
        // Retrieve the source code from the connected SCM (GitHub)
        checkout scm
        // Display the current short commit SHA for traceability
        sh 'git rev-parse --short HEAD'
      }
    }

    stage('Docker sanity') {
      steps {
        // Check if Docker is installed and running properly
        sh 'docker --version'
      }
    }

    stage('Build Docker image') {
      when {
        expression {
          // Only attempt to build if a Dockerfile exists in the repo
          return fileExists('Dockerfile')
        }
      }
      steps {
        script {
          // Generate a short SHA tag for version tracking
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
          // Generate same SHA for consistent tagging
          def shortSha = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()

          // Define registry and owner (organization or user)
          env.REGISTRY   = 'ghcr.io'
          env.OWNER      = 'asd-2025'     // Change to 'ben-edu' if needed
          env.IMAGE_NAME = 'demo-app'
          env.GHCR_TAG   = "${env.REGISTRY}/${env.OWNER}/${env.IMAGE_NAME}:${shortSha}"
        }

        sh '''
          echo "Retagging local image to: ${GHCR_TAG}"
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${GHCR_TAG}
          echo "Verifying the new tag:"
          docker image ls ${GHCR_TAG}
        '''
      }
    }

    stage('Test') {
      steps {
        echo "Running tests for demo app... (placeholder)"
      }
    }
  }
}
