pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                git url: 'https://github.com/aishwarya-nandapurkar/spring-petclinic.git'

                sh "mvn -DskipTests clean package"

            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
    }
}
