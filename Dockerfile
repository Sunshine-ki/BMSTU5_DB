FROM postgres:latest

RUN apt-get update
RUN apt-get -y install python3 postgresql-contrib postgresql-plpython3-13