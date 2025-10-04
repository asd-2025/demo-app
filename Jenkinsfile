pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        // Récupère le code de la branche détectée par le Multibranch
        checkout scm
        // Affiche l'identifiant du commit pour la traçabilité
        sh 'git rev-parse --short HEAD'
      }
    }

    stage('Build') {
      steps {
        echo "Building the demo app..."
      }
    }

    stage('Test') {
      steps {
        echo "Running tests for demo app..."
      }
    }
  }
}
