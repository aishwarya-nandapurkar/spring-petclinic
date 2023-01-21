pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                git url: 'https://github.com/aishwarya-nandapurkar/spring-petclinic.git', branch: 'main'

                sh "./mvnw -DskipTests clean package"

            }
        }
        stage('Test') {
            steps {
                sh './mvnw test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
    }
}
