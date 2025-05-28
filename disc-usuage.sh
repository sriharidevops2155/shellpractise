#!/bin/bash

DISK_USUAGE=$(df -hT | grep -v Filesystem)
DISK_THRESHOLD=1 #in project it will be genarlly 75

while IFS= read line
do
    USUAGE=$(echo $line | awk '{print $6f}' | cut -d "%" -f1)
    PARTITION=$(echo $line | awk '{print $7f}')
    echo "$PARTITION: $USUAGE" 
done <<<$DISK_USUAGE


