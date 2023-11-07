# Easy-Docker-Setup

The repo is a quick start to set the docker container for those who need the pytorch cuda environment.


## How to use

1. `git clone https://github.com/yui0303/Easy-Docker-Setup.git`
2. cd Easy-Docker-Setup
3. `./env.sh start` to build the image and you will get in the container directly
4. type `exit` to leave the container
5. You can still type `./env.sh start` to get in the container again.
6. type `./env.sh stop` or `./env.sh rm` to stop/remove the container.
7. type `./env.sh rmi` to remove the image.
8. type `./env.sh jupyter` to open the jupyter notebook.

> Note: Of course, you can modify the Dockerfile or Bash script to fit your demand.

## My Test Environment
- Nvidia 2080ti
- CUDA Version: 11.6
