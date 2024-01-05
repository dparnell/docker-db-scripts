#!/bin/sh

mkdir -p $HOME/oradata/19.3.0.0/oradata
mkdir -p $HOME/oradata/19.3.0.0/diag

sudo chown 54321:54321 $HOME/oradata/19.3.0.0/oradata
sudo chown 54321:54321 $HOME/oradata/19.3.0.0/diag

docker create --restart always --name oracle_19_3_0_0 \
	 -p 19300:1521 \
	 -e ORACLE_SID=orcl \
	 -e ORACLE_PWD=Mamori2021 \
	 -v $HOME/oradata/19.3.0.0/oradata:/opt/oracle/oradata \
	 -v $HOME/oradata/19.3.0.0/diag:/opt/oracle/diag \
	  container-registry.oracle.com/database/enterprise:19.3.0.0
