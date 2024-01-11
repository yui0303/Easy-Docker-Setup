#!/bin/bash

Username=$(whoami)
DirName=$(basename $(pwd) | tr '[:upper:]' '[:lower:]')
ImageName=$(echo $Username"_img_"$DirName)
ContainerName=$(echo $Username"_container_"$DirName)
JupyterPort=8333

if [ $# -eq 0 ] ; then 
    echo "You need the parameter."
    echo "./env.sh --help for more infomation"
    exit 1
fi

if [ $1 == "start" ] ; then
    # create image
    if [ $(docker images -a | grep -w $ImageName | wc -l) -eq 0  ] ; then
            echo "$ImageName not found, start to building '$ContainerName' container"
            docker build -t $ImageName --build-arg UID=$(id -u) --build-arg USERNAME=$Username .
    fi
    # start the container
    if [ $(docker ps -a | grep -w $ContainerName | wc -l) -eq 0 ] ; then # create the container
        echo "Run the '$ContainerName' container"
        docker run -it \
            -p $JupyterPort:$JupyterPort \
            --gpus all \
            --name $ContainerName \
            -v $(pwd):/home/$Username/workspace \
            $ImageName bash
    else
        if [ $(docker ps | grep -w $ContainerName | wc -l) -eq 0 ] ; then # check whether the container has run already
            docker start $ContainerName > /dev/null 2>&1
        fi
        docker exec -it $ContainerName bash # get in the container
    fi
    
elif [ $1 == "stop" ] ; then # stop the container
	if [ $(docker ps | grep -w $ContainerName | wc -l) -eq 0 ] ; then
        echo "The '$ContainerName' is not running."
    elif ! docker stop $ContainerName > /dev/null 2>&1 ; then
        echo "There is an unexpected wrong when stop the '$ContainerName'"
    else
        echo "Stop the '$ContainerName' successfully!"
    fi
elif [ $1 == "rm" ] ; then # remove the container
    if ! docker rm "$ContainerName" > /dev/null 2>&1 ; then
        echo "There is an unexpected wrong when removing '$ContainerName'"
    else
        echo "Remove the '$ContainerName' successfully!"
    fi
elif [ $1 == "rmi" ] ; then # remove the image
    if ! docker rmi "$ImageName" > /dev/null 2>&1 ; then
        echo "There is an unexpected wrong when removing '$ImageName'"
    else
        echo "Remove the '$ImageName' successfully!"
    fi
elif [ $1 == "jupyter" ] ; then # open jupyter notebook
    if ! jupyter notebook --ip=0.0.0.0 --port=$JupyterPort --no-browser --allow-root ; then
        echo "There is an unexpected wrong when opening jupyter notebook"
    fi
elif [ $1 == "--help" ] ; then
    echo ./env "parameter"
    echo "start : to build or start the iamge and container"
    echo "stop : to stop the container"
    echo "rm : remove the conatiner"
    echo "rmi : remove the iamge"
    echo "jupyter: run the jupyter notebook in port $JupyterPort"
else 
    echo "Wrong parameter!"
    echo "./env.sh --help for more infomation"
fi
