FROM nginx:latest

RUN apt update && apt install apache2-utils nano -y