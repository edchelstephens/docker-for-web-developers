FROM node:latest

LABEL author="Edchel Stephen Nini"
LABEL author_email="edchelstephens@gmail.com"

ENV NODE_ENV=production
ENV PORT=8000

COPY . /var/www/
WORKDIR /var/www/

VOLUME ["/var/www"]

RUN npm install

EXPOSE $PORT

ENTRYPOINT [ "npm", "start" ]