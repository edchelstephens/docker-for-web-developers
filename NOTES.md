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
