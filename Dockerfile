FROM jenkins/jenkins:alpine

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# Add Configuration as Code - Casc
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
# Copy plugins to Jenkins and install them
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
# Copy Casc file to Jenkins
COPY casc.yaml /var/jenkins_home/casc.yaml
# Add default job - Name the jobs  
ARG job_name_1="default"  
# Create the job workspaces  
RUN mkdir -p "$JENKINS_HOME"/workspace/${job_name_1}  
# Create the jobs folder recursively  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}  
# Add the custom configs to the container  
COPY /configs/${job_name_1}_config.xml "$JENKINS_HOME"/jobs/${job_name_1}/config.xml  
# Create build file structure  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/latest/  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/builds/1/
USER root
USER jenkins