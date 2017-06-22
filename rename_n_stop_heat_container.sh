#!/bin/bash
for name in $(docker ps | awk '{if(NR>1) print $NF}' | grep heat)
do
    new_name=$name'_ocata'
    docker rename $name $new_name
    docker stop $new_name
done
