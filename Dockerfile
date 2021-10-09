FROM ubuntu
USER root

# Updating repository
RUN apt-get update -qq

# Adding repository required for python3.6
RUN apt-get install software-properties-common -qq
RUN add-apt-repository ppa:deadsnakes/ppa

# Updating repositories
RUN apt-get update -qq

# Setting up project
RUN apt-get install pip -qq
RUN apt-get install python3.6 -qq
RUN apt-get install python3.6-venv -qq

# Switch directory to the app
COPY . /usr/src/app/
WORKDIR /usr/src/app/

# Run initialization/setup commands
ENV PYTHONUNBUFFERRED=1
CMD python3.6 -m venv . \
    && . bin/activate \
    && pip3 install -r requirements.txt \
    && python3.6 manage.py makemigrations \
    && python3.6 manage.py migrate \
    && python3.6 manage.py runserver 0.0.0.0:8000
