#!/bin/bash

docker stop con
docker system prune -f
docker pull ziwei0/awsdevops
docker run -d -p 8080:8080 --name con ziwei0/awsdevops