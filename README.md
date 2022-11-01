
SWE 645 – Assignment 2


Team Members:
Manankumar Thakkar (G01340764)
Yaksh Kiran Shah (G01254574)
Vineet Kasat (G01283897)
Vyshnavi Reddy (G01323466)
Shrushitha Bodanam (G01348656)


Contributions:
Manankumar - 	Kubernetes/GKE, Jenkins, Tutorial Video
Yaksh - 	Jenkins, Docker, Readme file/Report
Vineet - 	Kubernetes/GKE, Readme file/Report
Vyshnavi -	Jenkins, Readme file/Report
Shrushitha - 	Jenkins, Kubernetes/GKE


Following are the instructions for installing and replicating the project using the source code contained in the zip file:

1.	Setting up a repository on GitHub
2.	Creating the Docker Hub account and the repository for pushing the images
3.	Creating Docker file and building the image using Google cloud console
4.	Setting up Kubernetes cluster on Google cloud and deploying the survey form on GKE
5.	Creating an AWS EC2 Ubuntu instance
6.	Jenkins Installation
7.	Setting up the Jenkins
8.	Creating Jenkins file
9.	Building the CI/CD pipeline


Step 1: Setting up a repository on GitHub
a)	Create a new GitHub repository and set it to public.
b)	Use the command line to push the files created in HW1, Dockerfile, and Jenkinfile to the Git repository.
Step 2: Creating the Docker Hub account and the repository for pushing the images
 
Step 3: Creating Docker file and building the image using Google cloud console
a)	Create a Dockerfile. 
b)	In the Dockerfile, use the FROM command to retrieve the initial image. To run the war file in Tomcat, we should use the Tomcat image: FROM tomcat:latest
c)	Once that is done, we need to drop the war file into the webapps folder and EXPOSE it on 8080: COPY SWE645.war /usr/local/tomcat/webapps
             
d)	On the Google cloud terminal, clone the git repository where all the files are uploaded using the command ‘git clone https://github.com/ManankumarThakkar/SWE645-HW2’ 
e)	Now, login to the docker account created in Step 2 using the following command ‘docker login’ and enter the username and password when prompted and build the docker image using ‘docker build -t manan98/swe645:m1 . ’
f)	On the command line, use this command: ‘docker build --tag swe645-hw2:m1 .’ Use any name and tag you like.
g)	Now, push the image to the docker hub using command ‘docker push manan98/swe645:m1’ 

 

h)	Docker image from Docker Hub: https://hub.docker.com/repository/docker/manan98/swe645 

              

Step 4: Setting up Kubernetes cluster on Google cloud and deploying the survey form on GKE

a)	Login to cloud.google.com using Gmail credentials, navigate to the Console and create a new project. Also, enable Kubernetes Engine API if it is not enabled.
b)	Create a new cluster now and choose the zone and cluster name.

 

c)	In the Cloud Shell Terminal run the command shown for connecting to the Kubernetes clusters.

 

d)	Next, create a Kubernetes deployment for swe645 Docker image and set the default number of Deployment replicas to 3 using following commands:
 ‘kubectl create deployment swe645 --image=manan98/swe645:m1’ 
 ‘kubectl scale deployment swe645 --replicas=3’
e)	For Deployment, create a HorizontalPodAutoscaler resource using ‘kubectl autoscale deployment swe645 --cpu-percent=80 --min=3 --max=5’ command. 
i.	It will ensure that the cluster scales appropriately to handle large traffic.
f)	Now, expose the deployed survey form to the internet using ‘kubectl expose deployment swe645 --name=swe645-service --type=LoadBalancer --port 80 --target-port 8080’ and ‘kubectl get service’ commands.
i.	By doing this, you expose it and allow people to access it.

 

g)	Now, use the External-IP shown in the above image to see if the survey form is working correctly.

 


Step 5: Creating an AWS EC2 Ubuntu instance

a)	 Sign up for an AWS account at https://aws.amazon.com/. To use this service, you will need a credit card. Alternatively, you can use AWS educate, which has limited capabilities.
b)	In the AWS Console, click Services, then EC2, and then click Instances and Launch Instance. From the list, select the Ubuntu AMI.
 
c)	Under Instance Type, choose t2.medium and then click on security group and add Port range All, 80 and 443 to source 0.0.0.0/0. Also, make sure to you save your pem key.
 
d)	Once the instance is up and running, you can either connect to the instance using terminal on local machine or AWS Connect. You might have to change the permission on your key to be read-only.

i.	Command to run on local machine using terminal: ‘ssh -i "studentsurvey.pem" ubuntu@ec2-54-236-215-99.compute-1.amazonaws.com’
ii.	To prevent your key from being public, run this command:
                           chmod 400 studentsurvey.pem

 

e)	Once connected to the instance, update it by running: 'sudo apt-get update'


Step 6: Jenkins Installation 

a)	After connecting to the AWS instance, install docker using 'sudo apt install docker.io' command. 
b)	Verify that docker is installed by running 'docker -v'
c)	Docker is installed on Jenkins, as we will use it later in the Jenkinsfile.
d)	Install JDK 11: ‘sudo apt install openjdk-11-jdk’
e)	Now, Jenkins repository key and package repository into Ubuntu server using following commands.

 ‘wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -’  

‘sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'’

f)	Install Jenkins by running: ‘sudo apt update’ and then ‘sudo apt install jenkins’
g)	Give the user the right to execute, and then use /var/lib/jenkins/secrets/initialAdminPassword to give Jenkins the initial password.


h)	Check the status of Jenkins install by running ‘systemctl status jenkins’ and opening a browser on <public IPv4 address>:8080

 

 

i)	Since we will be using kubectl commands in a Jenkinsfile, we have also installed kubectl on the Jenkins instance: 'sudo apt install snapd' and 'sudo snap install kubectl --classic' 
j)	Add Jenkins user using ‘sudo usermod -a -G docker jenkins’ command
k)	Next, get the kubeconfig file from GKE cluster using ‘cat ~/.kube/config’ command. 

l)	The above command does not extract auth token from kube config. In order to add the token to the /var/lib/jenkins/.kube/config file, we need to run another command: gke-gcloud-auth-plugin.
             

Step 7: Setting up the Jenkins
In order to build using Jenkins, we need to set up a pipeline that checks all changes on GitHub.
a)	To create a pipeline in Jenkins, click on 'New Items', enter a name, and click 'Pipeline'.
 
b)	Now, to make sure Jenkins checks for every change, we set up a cron job that checks every minute.
 
c)	Since we are using the GitHub Hook trigger, we must enable Webhooks in GitHub. This will allow external services to get notifications when certain events occur.
             
d)	In addition, Jenkins needs to know where the Jenkinsfile will be stored, so we will place it under the name 'Jenkinsfile' in the root directory of our GitHub repository. Save all the other settings as default.
e)	Now, configure system and manage plugins in Jenkins. Install following plugins: Build Timeout, CloudBees Docker Build and Publish plugin, CloudBees Docker Custom Build Environment Plugin, Docker Compose Build Step Plugin, Docker Pipeline, Docker plugin, GitHub Integration Plugin, Google Kubernetes Engine Plugin, Kubernetes CLI Plugin, Kubernetes plugin, Pipeline: GitHub, Pipeline: Stage View Plugin.
             



Step 8: Creating Jenkinsfile
a)	Jenkinsfiles are text files that define Jenkins pipelines and are checked into source control systems. In this, run ‘mvn clean install’ to build war file, if maven isn’t installed, then use the following command: brew install maven
b)	A DockerHub password and a build number will be passed to Jenkins as environmental variables. In the Jenkinsfile file, use double quotes to get the value of the build number, i.e., ${env.BUILD_NUMBER}. Under 'Manage Jenkins', you can configure these settings. 
c)	We reset the deployment images to the new image in the last stage using the 'kubectl set image' command.
 
Step 9: Building the CI/CD pipeline

              
   

  We can see that the image has been updated on the deployment.

   


![image](https://user-images.githubusercontent.com/63867138/199138961-46299eeb-f926-42f8-a2c6-012d63c8bb3b.png)
