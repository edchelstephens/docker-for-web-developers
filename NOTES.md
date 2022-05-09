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