pipeline {
  agent any
  parameters {
    string(name: 'REGISTRY',   defaultValue: 'ghcr.io',  description: 'Container registry host')
    string(name: 'OWNER',      defaultValue: 'ben-edu',  description: 'Owner/namespace in registry')
    string(name: 'IMAGE_NAME', defaultValue: 'demo-app', description: 'Image name')
    booleanParam(name: 'PUSH',       defaultValue: true,  description: 'Push image to registry')
    booleanParam(name: 'TAG_LATEST', defaultValue: false, description: 'Also tag & push :latest')
    string(name: 'EXTRA_TAG',  defaultValue: '',         description: 'Optional extra tag (e.g. preprod)')
  }
  environment { LOCAL_TAG = "local-${env.BUILD_NUMBER}" }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'echo "✅ Checked out $(git rev-parse --short HEAD)"'
      }
    }
    stage('Docker sanity') { steps { sh 'docker --version' } }
    stage('Build image') {
      steps {
        script { env.SHORT_SHA = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim() }
        sh '''
          echo "🧱 Building: ${IMAGE_NAME}:${LOCAL_TAG}"
          docker build -t ${IMAGE_NAME}:${LOCAL_TAG} .
        '''
      }
    }
    stage('Tag for registry') {
      steps {
        script { env.GHCR_TAG = "${params.REGISTRY}/${params.OWNER}/${params.IMAGE_NAME}:${env.SHORT_SHA}" }
        sh '''
          echo "🏷  Retag to: ${GHCR_TAG}"
          docker tag ${IMAGE_NAME}:${LOCAL_TAG} ${GHCR_TAG}
          docker image ls ${GHCR_TAG}
        '''
        script {
          if (params.EXTRA_TAG?.trim()) {
            env.EXTRA_FULL = "${params.REGISTRY}/${params.OWNER}/${params.IMAGE_NAME}:${params.EXTRA_TAG.trim()}"
            sh 'docker tag ${IMAGE_NAME}:${LOCAL_TAG} ${EXTRA_FULL}'
          }
          if (params.TAG_LATEST) {
            env.LATEST_FULL = "${params.REGISTRY}/${params.OWNER}/${params.IMAGE_NAME}:latest"
            sh 'docker tag ${IMAGE_NAME}:${LOCAL_TAG} ${LATEST_FULL}'
          }
        }
      }
    }
    stage('Push (optional)') {
      when { expression { return params.PUSH } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'ghcr-pat', usernameVariable: 'GH_USER', passwordVariable: 'GH_PAT')]) {
          sh '''
            set -e
            echo "$GH_PAT" | docker login ${REGISTRY} -u "$GH_USER" --password-stdin
            docker push ${GHCR_TAG}
            [ -n "${EXTRA_FULL:-}" ]  && docker push ${EXTRA_FULL}  || true
            [ -n "${LATEST_FULL:-}" ] && docker push ${LATEST_FULL} || true
            docker logout ${REGISTRY} || true
          '''
        }
      }
    }
    stage('Test') { steps { echo 'Placeholder tests…' } }
  }
  post { always { sh 'docker image prune -f || true' } }
}
