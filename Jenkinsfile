pipeline {
    agent any
    tools {
        maven '3.8.6'
    }
    stages{
        stage('Build Maven'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ManankumarThakkar/SWE645-HW2']]])
                sh 'mvn clean install'
            }
        }
        stage('Build Docker Image'){
            steps{
                script{
                    def customImage = docker.build("manan98/swe645:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push Image To Hub'){
            steps{
                script{
                    sh "docker login -u manan98 -p Manan@9876"
                    sh "docker push manan98/swe645:${env.BUILD_NUMBER}"
				}
			}
		}
		stage("Deploying to Kubernetes"){
			steps{
				script{
					sh "kubectl set image deployment swe645=manan98/swe645:${env.BUILD_NUMBER}"
				}
			}
		}
	}
}

