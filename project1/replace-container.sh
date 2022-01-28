#!/bin/bash

docker stop con
docker rm con
docker pull ziwei0/awsdevops
docker run -d -p 8080:8080 --name con ziwei0/awsdevops