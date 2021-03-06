# Docker for Web Developers

# Docker Images and Containers

# A docker image is something that's used to build a container

- An image will have the necessary files to run something on an operating system like Ubuntu
  and then you have your application framework, your database and the files that support that

Example images:

- Ubuntu with Node.js and Application Code
- Ubuntu with python and django application code

# A docker container is created by using an image

- A container runs your application
- You use docker images to create running instances of containers
- The container is where the live application runs, where database runs, front end app runs etc

# An image is a read-only template composed of layered filesystems used to share common files and create Docker container instances

# A container is an isolated and secured shipping container created from an image that can be run, started, stopped, moved and deleted

# Docker Benefits for Web Developers

- Accelerate Developer Onboarding
- Eliminate App Conflicts
- Environment Consistency
- Ship Software Faster

# Docker Run Command

## Running on specified port

`docker run -p <machine_port_number>:<forward_to_container_port_number> <image_name>`

For example:
`docker run -p 80:80 kitematic/hello-world-nginx`

# Docker Key Commands

## Image

- `docker pull [image name optionally with tag and version]`

  - pull an image from docker hub
  - e.g.
    `docker pull edchelstephens/express_site:1`

- `docker push [image name optionally with tag and version]`

  - push an image to docker hub
  - `docker push edchelstephens/express_site:2`

- `docker images`
  - see list of all iamges
- `docker rmi [image Id]`

  - removes image

- `docker run -e <environment_variable>=<value> postgres`
- run postgres image into a container and set environment variable into that container
- example:
  `docker run -e DB_PASSWORD=password123 postgres`

- `docker network ls`
- list docker networks

## Container

- `docker run [image name]`

  - run image on container
  - if run doesn't find image, it will automatically download it and run

- `docker stop [image name]`
  - stop the running container
- `docker ps`

  - list all running containers

- `docker ps -a`

  - list all containers

- `docker rm [container ID]`
  - remove container

# How to get source code into a container?

1. Create a container volume that points to the source code
2. Add your source code into a custom image that is used to create a container

# Layered File System

- Docker images and containers are built on a layered file system, which is a layer of files that build upon each other.

Like a stack of files.

Example Image: Ubuntu image from docker hub:

gsw8s
sgshw
asx41
d3a3f
Ubuntu Image

with d3a3f as the bottom layer.

# The file system and the layers that compose it within a given image are READ ONLY(R/0).

- Image Layers are Read Only
- Once the image is baked, you're not going to be writing anything to that image from a container, for instance.
- The image has the files, they're kind of hard-coded in the image, and they're ready to go and be used, but you can't actually write to this.

# While images and the file system they have is read only, a container builds on top of this and gets its own thin read/write (R/W) layer.

- This is the main distinguishing factor between a container and an image
- An image is a set of read only layers whereas a container has a thin read/write layer

Any changes made while a container is running that are written to the writable layer, they kinda go away if the container is removed. So if you delete the container, you're also going to delete the file layer that is the read/write layer.

# Volumes

## What is a volume?

- Volume is a special type of directory in a container(the read write layer) typically referred to as a `data volume`
- In the data volume, we can store all types of data:
  - code
  - log files,
  - data files,
  - database,
  - images and more
- These data can be shared and reused among containers
- It's possible for multiple containers to write to this volume,
  or you could just have a single container that has one or more volumes it writes to
- Any update to an image aren't going to affect a data volume, it stays separate
- Data volumes are persistent
- Even if a container is deleted and it's completely blown away from the machine, the data volume can still stick around and you have control over that. :)

# Docker host

- The docker host is actually the thing hosting the container, meaning the Operating System where the docker container is running
- It is the thing that the container is atually running on top of.
- Remember containers are sort of virtual os, and the main os running these containers is actually the Docker host.
- So if you're running on a Linux System or a Window Server 2016 or a higher type of system, then the host would be that OS.

# Writing to a volume

- We can define a volume to a container
- When you write to a data volume from within your container, for example
  /var/www/ path
- That is really just going to be an alias for a mounte folder that is in the Operating System or the Docker host.
- So when we have a volume that we wrote to, instead of writing into that thin read/write type of layer that is associated with the container, it can actually write it up into this mounted folder are that's part of the Docker host or the operating system the docker container is running on top of.
- Even if you delete the container, the data volume or mounted folder that's on your Docker host can actuall stick around and you can preserve all of that code if you'd like.

# Mouting

Mounting is a process by which the operating system makes files and directories on a storage device (such as hard drive, CD-ROM, or network share) available for users to access via the computer's file system.

# Creating a Data Volume using docker defaults

`docker run -p <external_port>:<internal_port> <image> -v <data_volume> <image>`

Where:
`-p` is for port
`-v` is for volume

Example:
If we want a special are that node can write to, a data volume we say:

`docker run -p 8080:300 node -v /var/www/ node`

Where:
`node` is the image name
`/var/www/` is the data volume

# Locating a Volume

`docker inspect <container>`

it will give you a list-like or array like datastructure containing objects printed,

The volume will be on the `"Mounts"` key
located on the `Source` key

e.g.

...
"Mounts": [
{
"name": "d13gs",
"Source": "mnt/.../var/lib/docker/volumes/d3agxyaf/_data",
"Destination": "/var/www",
"Driver": "local",
"RW": true,
}
]
...

The actual location of the volume is in the Host or OS with the path specified in the `Source` key
The `Destination` key is the volume locator in the container.

# Creating a Custom Data volume

`docker run -p 8080:300 node -v $(pwd):/var/www node`

Where:
`-v $(pwd)` means go to the current working direcrtory and and use that as the host mount.
In other words, use that as the folder where I want to put my source code, or database, or image files, etc

`/var/www` is the container volume.

While running the container when you read or write to `/var/www`, then the container is actually going to look in the host location, which would be the current working directory.

So if you set up a `src/` folder and that's where you ran the command prompt from,
then that would be your current working directory.

When we do an inspect:

`docker inspect mycontainer`

it gives:

...
"Mounts": [
{
"Name": "atyg2sgh..",
"Source": "src/", # The host location as specified in the create volume command
"Destination": "/var/www"/, # The container data volume
"Driver": "local",
"RW": true,
}
]
...

- The container volume `/var/www/` is just like an alias(sort of) to the actual `src/` folder in the docker host, where all the file read and writes will be performed by this container.

# Specify working directory when running a container:

`docker run -p <external_port>:<internal_container_port> -v $(pwd):/src -w "/src" node npm start`

Where:
-w command says, that in the running container, run the node command npm start at the container /src folder which is an alias for the current working directory.

# Removing volumes

`docker rm -v lastContainer`

NOTE:

- You only need the `-v` when you want to delete the docker managed volumes, that is, volumes that docker automatically mounted on the docker host, something we did not set ourselves like:

`docker run -p <external_port>:<internal_container_port> -v $(pwd):/src -w "/src" node npm start`

- You only want to remove the volume when you're down to your last container, because other containers might be using it.

# Linking our source code to a container via container volume

- We can link our source code to a container by specifing the volume with -v using $(pwd) on our project source code working directory
- Now we can just get Node or Python or PHP, or ASP.NET or whatever it may be up and running as a container.
- We don't have to install anything on our local machine. We just to have to get that image (the python or node image, etc) running and then we can simply create a volume that links into our source code and then we're off and running! :)

# Recap: How do you get source code into a container?

1. Create a container volume that points to the source code
2. Add your souce code into a custom image that is used to create a container

# Dockerfile and Images

Dockerfile

- just a text file that has instructions on it :)
- These instructions of course are uinique to Docker
- We run the Dockerfile through the Docker client and it has a `build` command we can run and then that `build` command can read through those
  instructions, generate a layered file system to generate a Docker image that we can then use to make a container from it.
- It's just a text file that we want to feed into the Docker build process

# Dockerfile Overview

- Text file used to build Docker images
- Contains build instructions
- Instructions create intermediate image that can be cached to speed up future builds
- Used with `docker build` command

# Dockerfile Key Instructions

`FROM`

- Create an image from a baseline image, like Node.js image, a python image and then you build on top of that using this layered file system

`LABEL`

- label for the image, e.g.
- mainter/author

`RUN`

- Really important
- You can actually have different things defined that are going to be run and these would be:
  - I want to go to the internet and grab something
  - I want to run npm install, pip install, etc

`COPY`

- When you go to production, you want to copy that source code into the container oftentimes

`ENTRYPOINT`

- The main entry point for the container
- The initial entry point that kicks off the container

`WORKDIR`

- The working directory
- This sets the context for where the container is going to run as, for instance, where the entry point is run.
- So I could say, what folder has my `package.json` and I can do an `npm run`

`EXPOSE`

- Expose a port
- This is the default port the container would then run internally

`ENV`

- Define environment variables
- These environment variables can be then used in the container

`VOLUME`

- Define volumes
- You can define the actual volume and control how it stores that on the host system for the container

## Example Dockerfile

`FROM node`
`LABEL author="Edchel Stephen Nini"`
`COPY . /var/www`
`WORKDIR /var/www`
`RUN npm install`
`EXPOSE 8080`
`ENTRYPOINT [ "node", "server.js" ]`

Where:

`# This will grabe the Node image as the base file system`
`# And then add addtional layers on top of that`
`FROM node`

`# Custom labels, author, maintainers etc`
`LABEL author="Edchel Stephen Nini"`

`# Then copy the source code that is in this current directory via the **.** symbol where i'm building from`
`# Copy that source code into the containers alias location /var/www`
`# What that will do now is that, this layered file system will have a layer in it that's going to be just for our source code`
`COPY . /var/www`

`# Set the working directory to the location of the copied source code which in this case is /var/www in the image`
`WORKDIR /var/www`

`# Run npm install on curernt working directory`
`RUN npm install`

`# The port we'd like to expose that the container actually runs with`
`EXPOSE 8080`

`# Define the entry point.`
`# In this case, the node command and service js is my inital entry point into this container`
`ENTRYPOINT [ "node", "server.js" ]`

# Building a custom image

Command:
`docker build -t <username>/<repository>:<tag_string> .`
where:
-t is for tag
<username> is docker hub username
<repository> is repository name for the image
<tag_string> is a unique string to tag this image build, much like versioning

`.` - is the Build context, which is going to be the folder where it's actually going to run this from that will help find the Dockerfile and do some other things along the way

# Every docker instruction like `FROM`, `COPY`, `RUN` leads to an intermediate container being created that's ultimately cached behind the scense, for faster builds moving forward(if no change then just use the cached version of the instruction)

# Building Custom Images with DockerFile

- Dockerfile is a simple text file with instructions that is used to create an image
- Each Dockerfile starts with a `FROM` instruction, and then you can add multiple instructions, like another `FROM`
- Custom images are built using:
  `docker build -t <username>/<image_name_or_image_repostitory>:<version_tag> <build_context_where_dockerfile_lives_usually a .>`

# Container Linking

## Docker Container Linking Options

1. Use Legacy Linking

- Done using Container names
- Under the hood, it creates what's called a `bridge network` and within that network you can communicate between the containers,
  based on the name of the containers

2. Add Containers to a Bridge Network

- Done by adding containers to a **custom bridge network**
- This custom bridget network is isolated and only the containers in that network can communicate with each other.
  This is nice because now we can cerate specific networks for specific use cases:
  one network for a certain set of containers to communicate,
  another network for some other containers that they need to communicate
  This allows us to divide things up a little more elegantly than what you can do with the older legacy linking

### Docker Container Linking via Legacy linking(using container names)

#### Steps to link containers

1. Run a container with a name
   `docker run -d --name <custom_container_name> <image_name>`
   where:
   `-d` is for daemon mode, that is, run in background
   example:
   `docker run -d --name postgres_db_container postgres`

2. Link to a running container by name

`docker run -d -p <external_port>:<internal_port> --link <linked_custom_container_name>:<linked_custom_container_alias> <tag>`

where:
`-d` is for daemon mode, that is, run in background
`-p` is for port

example:

`docker run -d -p 8000:5000 --link postgres_db_container:database_container edchelstephens/express_site:4`

3. Repeat for additional containers
   Repeat steps 1 to 2 up to as many containers you need to link

### Note on linking containers

- Docker run isn't gonna wait for services like database to be setup.
- There's no way for Docker to know when Postgres or Mongo or any of these specially databases are finished loading.
- So if you ever do have code that has to seed a lookup table for example, you might call and it fails because the database hasn't finished loading in the container yet.
- All linking does is make sure that they start in proper oder. It doesn't guarantee the database is done setting up.
- This is something to be aware of, and that means you might have to have some try catch type code and some retries if you're seeding something, specially in development

### Docker Container Linking via Container Network or Bridge Network

### Steps to Linking:

1. Create a custom bridge network
   `docker network create --driver bridge isolated_network`

   where:
   `network create` - create a custom network
   `bridge` - use a bridge network
   `isolated_network` - name of the custom network

   generic form:
   `docker network create --driver bridge <network_name>`

2. Run containers in the network
   `docker run -d --net=isolated_network --name mongodb mongo`

where:
`-d` is for daemon mode, run in background
`--net=isolated_network` is specifying the network this container will run on, with generic form `--net=<network_name>`
`--name mongdbo` - the custom name for this container
`mongo` - the docker image from which to run this container

# The official term for Docker Container Linking via Container Network or Bridge Network is `Container Networking with a Bridge Driver`

# Docker containers communicate using link or network functionality

# The `--link` command line switch provides "legacy linking" by name

# The `--net` command line switch can be used to setup a bridge network -- preferred than legacy linking

# Docker Compose can be used to link multiple containers to each other --> preferred when linking 2 or more containers --> the preferred way moving forwards

# Docker Compose

## Docker Compose manages your application lifecycle

- It allows you to have multiple images and then convert those images into containers and the overall lifecycle of these containers

-Services in docker compose are really just running containers

# Docker Compose Features

It Manages the whole application lifecycle

- Start, stop and rebuild services
- View the status of running services
- Stream the log output of running services
- Run a one-off command on a service

# Docker Compose Workflow

- Once you have your Dockerfiles setup and docker-compose.yml is then you're gonna use docker compose to

1. Build Services

- under the covers, this just creates images

2. Start Services

- Run the built images as containers and they are called `services` in the docker compose world

3. Tear Down Services

- once we're done, we can tear down those services, stop the containers and even remove them

# The Role of the Docker Compose File

## docker-compose.yml

- a service configuration file, just a yml file with configuration for docker, just a normal text file with instructions that we can run thru the docker build process

## Docker Compose Workflow

docker-compose.yml -> Docker Compose Build -> Docker Images that get's run as containers which are now called Services

# docker-compose.yml generic format:

version: <version_string>
services:
<name_of_service>:
build:
context: .
dockerfile: <dockerfile>
networks: # networks this service is connected to - <name_of_network>

<name_of_service>:
image:<image>
networks: - <name_of_network>

networks:
<name_of_network>
driver:bridge

docker-compose.yml Example:

# ---- docker-compose.yml file -------

version: "3.x"
services:
node:
build:
context: .
dockerfile: node.dockerfile
networks: - nodeapp-network

mongodb:
image:mongo
networks: - nodeapp-network

networks:
nodeapp-network
driver:bridge

# Docker Compose Key Commands

Once you have your docker-compose.yml file, you can then run the following commands

`docker-compose build`

- build our services into images

`docker-compose up`

- once build is done and you have your images, you can the images up as running containers with this command

`docker-compose down`

- turn down the running containers or services

`docker-compose logs`
-view the logs

`docker-compose ps`

- list the differnt containers that are running our services

`docker-compose stop`

- stop all the different services

`docker-compose start`

- start the different services

`docker-compose rm`

- remove the different containers that are making up our services

# Building Services

Build Services ----> Start up Services ----> Tear Down Services

## Build Services

`docker-compose build`

- this will automatically build or rebuild all of the different service images that we need and that are all defined in docker-compose.yml

Single build:

`docker-compose build mongo`

- this will only build/rebuild mongo series

## Starting Services Up

`docker-compose up`

- this creates and starts the containers
- this includes linking them together if you're doing linking technology or using bridge network, whatever you're using in docker-compose.yml
- compare this to manual docker run:
  `docker run -d --net=isolated_network --name nodeapp -p 8000:3000 edchelstephens/express_site:1`

  which is really long and difficult. No need for this anymore, just configure in docker-compose.yml, build and run with docker-compose up

Options with `docker-compose up`

Do not recreate services that depends on something wiht --no-deps

`docker-compose up --no-deps node`

- This rebuilds node image and stop, destroy and recreate only the node image
- Just rebuild this single service, excluding dependencies

`docker-compose up -d`

- Run containers in daemon mode, or in the background

## Tear Down Services

`docker-compose down`

- This takes all of the containers, stops and removes them.

If you want to just stop and not remove, then use:
`docker-compose stop`

Options:

- Remove all images and volumes as well:

`docker-compose down --rmi all --volumes`

# Docker Compose summary

- Docker compose simplifies the process of building, starting and stopping services
- docker-compose.yml defines services
- A service is really just a running container
- excellent way to manage services used in a development environment

# Kubernetes

# It would be nice if we could:

- Package an app, provide a manifest, and let something else manage it for us
- Not worry about the management of containers
- Eliminate single points of failure and self-heal containers
- Have a robust way to scale and load balance containers
- Update containers without brining down the application
- Have a robust networking and persisten storage options

# What if we could define the containers we want and then hand it off to a system that manages it all for us?

# - Well, welcome to Kubernetes, K8s does all of that! :)

# Kubernetes - K8s

- Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applciations
- kubernetes.io

# Analogies

## Sports Team - Containers as players, Kubernetes as coach

- In a perspective of sports team,
  the players are the containers and kubernetes is the coach, managing the play and the players
- Kubernetes is the coach of a container team

## Orchestra - The orchestra players as the container, Kubernetes as the conductor

# Kubernetes Overview

- Container and cluster management
- Supported by all major cloud platforms
- Provides a declarative way to define a cluster's state using manifest files (YAML)
  Which is very similar to docker-compose on this regard
- Interact with Kubernetes API using command-line tool `kubectl` or "kube cuddle" or "kube kotl" hehe

## Key Features

- Source Discovery/Load Balancing
- Storage Orchestration
- Automate Rollouts/Rollbacks
- Manage Workloads
- Self-healing
- Secret and configuration management
- Horizontal Scaling
- and More

## Kubernetes the big picture

- Kubernets is gonna have a `master node`
- The `master node` is in charge of keeping all the children nodes in line
- These `children nodes` are called `worker nodes`
- The `woker nodes` will have a `pod` inside of them
- A `node` is like a `VM`, and a `pod` is a container for containers
- Now with `multiple nodes being managed by a master`, we call that a `cluster`
- So we can have a cluster of virtual machines, we can scale out, scale in, etc

# Key Kubernetes Concepts

## Deployment

#### - Describe desired steate

- This allows us to describe the desired state we're after in one of two types of files:

  - we can use a YAML file, which is the normal one
  - or even a JSON file

- So what we'll be doing as we convert from Docker Compose to Kubernetes:
  - one option would be to basically translate the services in our Docker Compose file that defines the images and the containers that should run into a Kubernetes Deployment file.
  - Deployment in a nutshell is really saying hey, I need these five containers up and running, and I need them to communicate somehow

#### - Can be used to replicate pods

#### - Supports rolling updates and rollbacks

## Service

#### - Pods live and die

- If a container goes down, the pod may be completely removed and a new pod might be brought up
- Pods can have a short or a long life span, it really depends on the application scenarios
- Therefore pod IP address cannot be relied upon but services got this by abstracting the pod IP address for consumers

#### - Services abstract pod IP address from consumers

#### - Load balances between pods

#### Kubernetes Key commands

- `kubectl version`
- get version of kubernetes

- `kubectl get [deployments | services | pods | nodes]`
- get information on any deployments, services, pods or nodes

- `kubectl run nginx-server --image=nginx:alpine`
- generic format: `kubectl run <name> --image=<image>`
- run a container with a alias name using an image

- `kubectl apply -f [fileName | folderName]`
- if we already have our kubernetes deployment file or files, just run apply to get the cluster running

- `kubectl port-forward [name-of-pod] 8080:80`
- expose a port of a pod so we can get to it

## Stoping and Removing Containers on Kubernetes

-`kubectl delete -f[fileName | folderName]`

# Kubernetes summary

- Kubernetes provides a robust solution for automating deployment, scaling and management of containers
- Provides a way to move to a desired state
- Relies on YAML (or JSON) files to represent desired state
- Nodes and pods play a central role
- Nodes are VMs
- Pods act as a way to group one or more containers together
- A container runs in a pod
- `kubectl` can be used to issue commands and interact with the Kubernetes API
