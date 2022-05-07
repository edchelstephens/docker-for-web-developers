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

- `docker pull [image name]`
  - pull an image from docker hub
- `docker images`
  - see list of all iamges
- `docker rmi [image Id]`
  - removes image

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
