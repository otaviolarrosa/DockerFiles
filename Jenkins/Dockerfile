FROM debian 

MAINTAINER Otávio Larrosa 

# Update Packages
RUN apt update

# Install JRE
RUN apt install -y default-jre

# Enable Jenkins PPA
RUN apt install -y  wget
RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt update
RUN apt install jenkins

RUN cat /etc/default/jenkins

