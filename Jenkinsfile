pipeline {
  agent {label "development"}
  environment {
    TAG = "dev"
    PORT = "81"
    DOKCERHUB_CREDS = credentials('docker-hub-credentials')
  }
  stages {
    stage('Preparation') {
      steps {
        git branch: "$TAG", url: 'https://github.com/vadrif-draco/Booster_CI_CD_Project.git'
      }
    }

    stage('Build') {
      steps {
        sh "docker build -t ${DOKCERHUB_CREDS_USR}/bootcamp-capstone-cicd-project:$TAG ."
      }
    }

    stage('Push') {
      steps {
        sh """
        docker login -u ${DOKCERHUB_CREDS_USR} -p ${DOKCERHUB_CREDS_PSW}
        docker push ${DOKCERHUB_CREDS_USR}/bootcamp-capstone-cicd-project:$TAG
        """
      }
    }

    stage('Deploy') {
      steps {
        sh """
        docker rm -f $TAG-server 2>> /dev/null
        docker run --name $TAG-server -d -p $PORT:8000 ${DOKCERHUB_CREDS_USR}/bootcamp-capstone-cicd-project:$TAG
        """
      }
    }
  }
  post {
    success {
      slackSend channel: "capstone-project-$TAG", message: "Build ${env.BUILD_NUMBER} passed successfully.", color: "#00cc00"
    }
    failure {
      slackSend channel: "capstone-project-$TAG", message: "Build ${env.BUILD_NUMBER} failed, please check the build logs for more details...", color: "#cc0000"
    }
  }
}
