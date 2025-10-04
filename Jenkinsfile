pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'git rev-parse --short HEAD'
      }
    }

    stage('Docker sanity') {
      steps {
        // اگر Docker نصب باشد نسخه را نشان می‌دهد؛ اگر نصب نباشد اینجا خطا می‌گیریم و همانجا می‌ایستیم
        sh 'docker --version'
      }
    }

    stage('Build Docker image') {
      when {
        expression {
          // فقط اگر Dockerfile وجود دارد، تلاش برای build کن
          return fileExists('Dockerfile')
        }
      }
      steps {
        script {
          // یک تگ محلی بر اساس SHA کوتاه بسازیم تا قابل ردگیری باشد
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

    stage('Test') {
      steps {
        echo "Running tests for demo app... (placeholder)"
      }
    }
  }
}
