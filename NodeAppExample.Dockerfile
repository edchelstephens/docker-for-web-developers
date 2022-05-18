# Build this image on top of the node image as the base image
# Pulls the latest node image(if not yet pulled)
#  You can poptionally specify version 
# e.g. FROM node:6.8.1
FROM node:latest

# Labels for this container
LABEL author="Edchel Stephen Nini"
LABEL author_email="edchelstephens@gmail.com"

# Environment variables that will be available in and available to the container
ENV NODE_ENV=production
ENV PORT=3000

# Copy the local source code from current working directory into the image into a folder called `/var/www/`
COPY . /var/www/

# Make /var/www/ the working directory in the image
WORKDIR /var/www/

# Make /var/www/ a container volume
# That is, the docker host(Operating System) would actually be where the source code is going to live( can be overriden with `docker run`)
VOLUME ["/var/www"]

# Run npm install for the project
# So under /var/www/ a `package.json` file must exists, which it does since we copied the source code into the docker volume
RUN npm install

# Expose the PORT as defined in the environment variable for the interal port for the container
EXPOSE $PORT

# The entry point command, which in this case is `npm start` for a javasript node application
ENTRYPOINT [ "npm", "start" ]