pipeline {
    agent any
    environment {
        ARTIFACTORY_ID = readMavenPom().getArtifactId().toLowerCase()
        VERSION = readMavenPom().getVersion().toLowerCase()
        registryDomain = "jfrogdev34.jfrog.io"
        registryDomainWithProtocol = "https://$registryDomain"
        registry = "$registryDomain/docker-dev/$ARTIFACTORY_ID/$VERSION"
        registryCredential = 'jfrog-docker'
        dockerImage = ''
    }
    stages {
        stage('Compile') {
            steps {
                sh "./mvnw clean compile"

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
        stage('Package') {
            steps {
                git url: 'https://github.com/aishwarya-nandapurkar/spring-petclinic.git', branch: 'main'

                sh "./mvnw -DskipTests package"

            }
        }

        stage('Deploy Jars') {
            steps {
                configFileProvider([configFile(fileId: '0b2813be-f9a6-47e6-9b6b-e67009aa3108', variable: 'MAVEN_SETTINGS_XML')]) {
                    sh './mvnw -s $MAVEN_SETTINGS_XML -DskipTests deploy'
                }
            }
        }
        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy Image') {
            steps {
                script {
                    docker.withRegistry(registryDomainWithProtocol, registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}
