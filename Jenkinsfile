pipeline {
    agent any
    environment {
        registry = "jfrogdev34.jfrog.io/docker-dev/spring-petclinic"
        registryCredential = 'jfrog-docker'
        dockerImage = ''
      }
    stages {
    stage('Clean') {
                steps {
                    sh "./mvnw clean"

                }
            }
            stage('Tests') {
                        steps {
                            sh './mvnw surefire:test'
                        }
                        post {
                            always {
                                junit 'target/surefire-reports/*.xml'
                            }
                        }
                    }
        stage('Package') {
            steps {
                git url: 'https://github.com/aishwarya-nandapurkar/spring-petclinic.git', branch: 'main'

                sh "./mvnw -DskipTests package"

            }
        }

        stage('Deploy Jars') {
            steps{
                   configFileProvider([configFile(fileId: '0b2813be-f9a6-47e6-9b6b-e67009aa3108', variable: 'MAVEN_SETTINGS_XML')]) {
                        sh './mvnw -s $MAVEN_SETTINGS_XML -DskipTests deploy'
                    }
                }
            }
    }
}
