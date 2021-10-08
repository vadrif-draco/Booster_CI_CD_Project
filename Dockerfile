FROM ubuntu
USER root

# Preparing slave env
RUN mkdir -p /jenkins
RUN chmod 777 /jenkins
RUN useradd -ms /bin/bash jenkins

# Updating repository
RUN apt-get update -qq

# Installing some bs prerequisite that keeps hanging STDIN
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Installing git for SCM
RUN apt-get install git -qq

# Installing openjdk 8 for slavery
RUN apt-get install openjdk-8-jdk -qq

# Installing and starting openssh
RUN apt-get install openssh-server -qq
RUN service ssh start

# Adding repository required for python3.6
RUN apt-get install software-properties-common -qq
RUN add-apt-repository ppa:deadsnakes/ppa

# Updating repositories
RUN apt-get update -qq

# Setting up project
RUN apt-get install pip -qq
RUN apt-get install python3.6 -qq
RUN apt-get install python3.6-venv -qq
RUN git clone https://github.com/vadrif-draco/Booster_CI_CD_Project.git /usr/src/app

# Switch directory to the app
WORKDIR /usr/src/app/

# Run initialization/setup commands
COPY authorized_keys ~/.ssh/
ENV PYTHONUNBUFFERRED=1
CMD python3.6 -m venv . \
    && . bin/activate \
    && pip3 install -r requirements.txt \
    && python3.6 manage.py makemigrations \
    && python3.6 manage.py migrate \
    && python3.6 manage.py runserver 0.0.0.0:8000
