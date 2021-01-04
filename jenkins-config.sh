app_tag=`git ls-remote https://github.com/javahometech/node-app HEAD | awk '{print $1}'`

docker_app="mehmetoz74/nodejenkins:$app_tag"
docker build -t $docker_app .

docker login -u mehmetoz74 -p yourpassword 

docker push $docker_app

scp -i /var/lib/jenkins/dev.pem deploy.sh ec2-user@172.31.43.90:/tmp

ssh -i /var/lib/jenkins/dev.pem ec2-user@172.31.43.90 chmod +x /tmp/deploy.sh

ssh -i /var/lib/jenkins/dev.pem ec2-user@172.31.43.90 /tmp/deploy.sh $docker_app
