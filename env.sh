#!/usr/bin/bash

Username=$(whoami)
ImageName=$(echo $Username"_img")
ContainerName=$(echo $Username"_container")
JupyterPort=8333

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
    if ! docker stop $ContainerName > /dev/null 2>&1 ; then
        echo "There is a unexpected wrong when stop the '$ContainerName'"
    else
        echo "Stop the '$ContainerName' successfully!"
    fi
elif [ $1 == "rm" ] ; then # remove the container
    if ! docker rm "$ContainerName" > /dev/null 2>&1 ; then
        echo "There is a unexpected wrong when removing '$ContainerName'"
    else
        echo "Remove the '$ContainerName' successfully!"
    fi
elif [ $1 == "rmi" ] ; then # remove the image
    if ! docker rmi "$ImageName" > /dev/null 2>&1 ; then
        echo "There is a unexpected wrong when removing '$ImageName'"
    else
        echo "Remove the '$ImageName' successfully!"
    fi
else 
    echo "Wrong parameter!"
fi
