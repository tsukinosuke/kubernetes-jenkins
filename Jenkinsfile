pipeline {
    agent any 
    environment {
        DOCKER_TAG = getDockerTag()
    }
    stages {
        stage('Build Docker image') {
            steps {
                sh "docker build . -t mehmetoz74/nodeapp:${DOCKER_TAG}"
            }
        }
        stage('Push the Image to DockerHub registry') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
                    sh "docker login -u mehmetoz74 -p ${dockerHubPwd}"
                    sh "docker push mehmetoz74/nodeapp:${DOCKER_TAG}"
            }
                
            }
            
        }
        stage('Deploy to K8S') {
            steps {
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh${DOCKER_TAG}"
                sshagent(['kops-machine']) {
                sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ec2-user@54.197.43.47:/home/ec2-user/"
                script {
                    try {
                        sh "ssh ec2-user@54.197.43.47 kubectl apply -f . -n nodejs"
                    }catch(error) {
                        sh "ssh ec2-user@54.197.43.47 kubectl create -f . -n nodejs"
                    }
                }
            }
            }
        }
    }

}

def getDockerTag() {
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag 
}