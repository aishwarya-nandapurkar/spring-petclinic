# Continuous integration pipeline for Spring Petclinic application

## Overview
This is a continuous integration pipeline for the Petclinic application which triggers a new build every single time there is a fresh commit on the `main` branch or if there is any pull request that gets merged. Using Jenkins as a CI(Continous Integration) server and JFrog artifactory as the repository manager, this project intends to automate the build creation process and stores newly created jars as well as docker images in Artifactory so that those could be accessed and run whenever required.

## Prerequisites
a. JFrog:
1. Create a free trial account by going to `https://jfrog.com/start-free/` . Go for the cloud hosted.
2. Once you have the url for your JFrog instance, start by creating 2 local repositories (one of generic type and the other of docker type). We will be using these created repos for pushing our builds to JFrog after the CI pipeline is run.
3. Creation of repos is very simple and you need to provide a repository key for each. In my case, I have `local-dev` for my Jars and `docker-dev` for my Docker images.
4. After repo creation, need to generate the token for each repo which can then be used as a credential from the Jenkins server to push the builds. This option is available in the `Set me up` section on the repositories screen.
5. XRay(CVE Scanning by JFrog) runs on every new image that's pushed so it will also assess any threats/ vulnerabilities and generate a report of the same.

b.Jenkins:
1. Download latest Jenkins war file from `https://www.jenkins.io/download/`
2. Install on your server or local depending on where you are going to run Jenkins(For this project I have installed on my local). Open cmd line and CD into the directory where Jenkins was installed. Run using : java -jar jenkins.war
3. This should bring your Jenkins up, and you can now access it on `http://localhost:8080`
4. Multiple plugins will need to be installed for this project, and it can be easily done by going to plugin manager : `Dashboard->Manage Jenkins->Plugin Manager`. List of these plugins is mentioned here
5. Need to add the artifactory credentials in Jenkins so that those could be used while pushing the builds to respective repos. This can be added in `Dashboard->Manage Jenkins->Credentials`. Create 2 creds here (1 for the Jar repo and other for Docker repo). Use creds created in step 2 from Jfrog prerequisites above. ![Screen Shot 2023-01-26 at 1 13 24 PM](https://user-images.githubusercontent.com/38335795/214951709-ca7f5c9f-dacd-4c85-8b51-4eb30caf8458.png)
6. One last change needed on Jenkins is to add a Global Maven Setting file so that this can then be utilized for storing all repo locations as well as their 
credentials so that those are not exposed on the versioning system. This file can be added at : `Dashboard->Manage Jenkins->Managed files-> Add a config`. 

c.Ngrok:
1. Since I want to integrate Jenkins with Artifactory, I will be using Ngrok to expose my Jenkins url externally.
2. Use `https://ngrok.com/download` to download and create your free account too. Now generate an auth token and add this to the ngrok config on your local.
3. Start ngrok by using this command on the command line : `ngrok http 8080`. This should now provide you with a forwarded https url which can be accessed over internet. Check my sample from below. Now my Jenkins is readily accessible on the 8080 port.
![Screen Shot 2023-01-26 at 12 24 25 PM](https://user-images.githubusercontent.com/38335795/214942807-b58523d5-6159-4cc8-9bb0-7dc8117309b7.png)

d. Petclinic application changes:
1. First introduced the `Jenkinsfile` in the root folder of the project. This file has all details regarding the pipeline setup and what steps are to be run before generating the build. It also has details about the specific artifactory destination where successful builds will be uploaded. We could have written all these steps in Jenkins directly but storing in Github gives more flexibility and history/versioning will also be tracked.
2. POM.xml will also need to be modified as we are now pulling dependencies from Jcenter bintray. 
3. One final and important change on the POM is to add the `distributionManagement` tag too. This tag helps deploy jars to the specified artifactory location.

## Jenkins and Github Integration
### Configuring Github
1. Go to your GitHub repository and click on `Settings`
2. Click on Webhooks and then click on `Add webhook`.
3. In the `Payload URL` field, paste your Jenkins environment URL obtained from ngrok. At the end of this URL add /github-webhook/. In the `Content type` select: `application/json` and leave the `Secret` field empty.
4. In the page `Which events would you like to trigger this webhook?` choose `Let me select individual events.` Then, check `Pull Requests` and `Pushes`. At the end of this option, make sure that the `Active` option is checked and click on `Add webhook`.

### Configuring Jenkins
1. In Jenkins, click on `New Item` to create a new project.
2. Give your project a name, then choose `Pipeline` and finally, click on `OK`.
3. Click on GitHub Project and paste the GitHub repository URL: https://github.com/aishwarya-nandapurkar/spring-petclinic.git/ in the `Repository URL` field.
4. Click on the `Build Triggers` tab and then check the `GitHub hook trigger for GITScm polling`.
5. In the `Pipeline` section, select `Pipeline script from SCM` under `Definition` and set the `Repository URL` to https://github.com/aishwarya-nandapurkar/spring-petclinic.git
6. Add `*/main` under `Branches to build` and click on `Save`

## Running Pipeline

Jenkins has been configured to run the build pipeline on any changes committed to the `main` branch.
The build pipeline will run the below stages:
1. Clean and Compile
2. Run tests
3. Package
4. Deploy Jars to Jfrog Artifactory: `https://jfrogdev34.jfrog.io/artifactory/local-dev/`
5. Build Docker Image
6. Push Docker Image to Jfrog docker repository: `jfrogdev34.jfrog.io/docker-dev/`
7. Clean docker images from Jenkins

## Running a Container

`docker run -p 8080:8080 jfrogdev34.jfrog.io/docker-dev/spring-petclinic/3.0.0-snapshot:1`

Go to `http://localhost:8080` and the Spring petclinic application should be running.
