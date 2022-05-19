FROM node:latest

LABEL author="Edchel Stephen Nini"
LABEL author_email="edchelstephens@gmail.com"

ENV NODE_ENV=production
ENV PORT=3000

COPY . /project
WORKDIR /project

VOLUME ["/project"]

RUN npm install

EXPOSE $PORT

ENTRYPOINT [ "npm", "start" ]