#!/bin/bash

if ! docker pull ziwei0/awsdevops | grep "Image is up to date" ; then
    docker stop con
    docker system prune -f
    docker run -d -p 8080:8080 --name con ziwei0/awsdevops
fi
