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
             stage('Package') {
            steps {
                git url: 'https://github.com/aishwarya-nandapurkar/spring-petclinic.git', branch: 'main'

                sh "./mvnw -DskipTests package"

            }
        }
        stage('Tests') {
                                steps {
                                    sh './mvnw test'
                                }
                                post {
                                    always {
                                        junit 'target/surefire-reports/*.xml'
                                    }
                                }
                            }

        stage('Deploy Jars') {
            steps{
                   configFileProvider([configFile(fileId: '0b2813be-f9a6-47e6-9b6b-e67009aa3108', variable: 'MAVEN_SETTINGS_XML')]) {
                        sh './mvnw -s $MAVEN_SETTINGS_XML -DskipTests deploy'
                    }
                }
            }
        stage('Building image') {
                  steps{
                    script {
                      dockerImage = docker.build registry + ":$BUILD_NUMBER"
                    }
                  }
                }
                stage('Deploy Image') {
                  steps{
                    script {
                      docker.withRegistry( 'https://jfrogdev34.jfrog.io', registryCredential ) {
                        dockerImage.push()
                      }
                    }
                  }
                }
                stage('Remove Unused docker image') {
                  steps{
                    sh "docker rmi $registry:$BUILD_NUMBER"
                  }
                }
    }
}
