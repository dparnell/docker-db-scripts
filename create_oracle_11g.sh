#!/bin/sh

DATA_DIR=$HOME/oracle/11c
mkdir -p $DATA_DIR
docker run -d --name oracle-11g \
           --restart always \
           --privileged -v $DATA_DIR:/u01/app/oracle \
           -p 8011:8080 -p 1511:1521 absolutapps/oracle-11g-ee
