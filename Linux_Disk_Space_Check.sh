#!/bin/bash

# Checks DISK usage if it is above the configured value
# Default is for 90% usage, can be changed by passing a value to the script. EX: max=95 will set the maximum DISK usage to 95%

for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

   export "$KEY"="$VALUE"
done

if [ -z "$max" ];
then
    max="90"
fi

output=$(df -h | grep -vE '^Filesystem|tmpfs|cdrom|udev' | awk '$5 ~ /%$/ {print $5 " " $1 }')

IFS=$'\n'
for disk in $output; do
    usep=$(echo "${disk}" | awk '{ print $1 }' | cut -d'%' -f1) 
    partition=$(echo "${disk}" | awk '{ print $2 }')
    
    if [ ${usep} -le $max ]; then
        echo "Disk $partition usage less than $max%. ($usep%)"
        exit 0
    else
        echo "Disk $partition usage greater than $max%. ($usep%)"
        exit 1
    fi
done
