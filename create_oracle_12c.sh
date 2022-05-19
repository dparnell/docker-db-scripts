#!/bin/sh

DATA_DIR=$HOME/oracle/12c
mkdir -p $DATA_DIR
docker run -d --name oracle \
           --privileged -v $DATA_DIR:/u01/app/oracle \
           -p 8012:8080 -p 1512:1521 absolutapps/oracle-12c-ee
