# Homework 5 - Automated Pipeline with Jenkins

## Setting up the VMS and the SSH keys

1. vagrant up

2. vagrant ssh jenkins

3. su - jenkins

4. ssh-keygen -t ecdsa -b 521 -m PEM

5. ssh-copy-id jenkins@jenkins.do1.lab

6. ssh-copy-id jenkins@docker.do1.lab

## On the host machine, open http://127.0.0.1:8080/

1. Enter initialPassword

2. Install Recommended plugins

3. Register admin user

4. Accept proposed url

5. Enter Jenkins

6. Go to Plugins and download SSH

7. Restart Jenkins

## In jenkins machine, jenkins user
1. cd
2. cd .ssh
3. cat id_ecdsa
4. copy the private SSH key

### Manage Jenkins > Manage Credentials > Global > Add Credentials > SSH Username with private key
1. username: jenkins
2. Private key: Enter directly


### Then Manage Jenkins > Configure System > SSH remote hosts > Add
1. hostname: jenkins.do1.lab
2. port: 22
3. credentials: Credentials from File


### Then Manage Jenkins > Configure Global Security > SSH Server
1. SSHD Port Fixed:     
2. Save
3. Exit Jenkins user

### When back to the vagrant on the jenkins machine

1. ssh-keygen
2. cat ~/.ssh/id_rsa.pub

### Copy the key and then Manage Jenkins > Manage Users > admin > Configure
SSH Public Keys: Paste the Vagrant SSH key we just created
Save

1. ssh -l admin -p 2222 localhost help

2. to add teh fingerprint: yes

## Importing the pipeline
1. cp /vagrant/bgapp.xml .
2. ssh -l admin -p 2222 localhost create-job Pipeline-BGApp < bgapp.xml

## Setting Up Gitea
1. cp /vagrant/docker-compose.yml .
2. docker compose up -d

### When it's done, navigate to http://192.168.99.102:3000
1. Change Server domain to: 192.168.99.102
2. Change Gitea Base URL to: http://192.168.99.102:3000/
3. Register
4. New Repository with default settings, repo name is bgapp

## Back on the Jenkins machine

1. cd
2. git init
3. git checkout -b main
4. git remote add origin http://192.168.99.102:3000/ilia/bgapp.git
5. git clone -b m5 https://github.com/ilkoTheTiger/demo-app
6. cd demo-app
7. git branch main
8. git branch checkout main
9. git push http://192.168.99.102:3000/ilia/bgapp.git

### Go to Gitea Repo > Settings > Webhooks
1. Target URL: http://192.168.99.101:8080/gitea-webhook/post

### One more plugin we need to install in Jenkins
1. Manage Jenkins > Manage Plugins > Available Plugins > Gitea
2. Restart Jenkins when installation is complete

## Go to Docker hub
1. Login > Account Settings > Security > New Access Token
2. Put jenkins in description copy and close

## Back to Jenkins > Manage Jenkins > Manage Credentials > System > Global Credentials
1. Click Add Credentials
2. username: Docker Hub username
3. password: Docker Access Token
4. ID: docker-hub
5. description: Docker Access Token


## In the jenkins machine
1. ssh -l admin -p 2222 localhost build Pipeline-BGApp -f -v


## Installing Gitea plugin
1. Manage Jenkins > Manage Plugins > Gitea
2. Restart Jenkins



