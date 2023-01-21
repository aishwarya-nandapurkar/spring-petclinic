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
        stage('Publish to Jfrog') {
            steps{
                   configFileProvider([configFile(fileId: '0b2813be-f9a6-47e6-9b6b-e67009aa3108', variable: 'MAVEN_SETTINGS_XML')]) {
                        sh './mvnw -s $MAVEN_SETTINGS_XML clean deploy'
                    }
                }
            }
    }
}
