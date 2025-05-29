#!/bin/bash

DISK_USUAGE=$(df -hT | grep -v Filesystem)
DISK_THRESHOLD=1 #in project it will be genarlly 75
MSG=""
IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

while IFS= read line
do 
    USUAGE=$(echo $line | awk '{print $6f}' | cut -d "%" -f1)
    PARTITION=$(echo $line | awk '{print $7f}')
    #echo "$PARTITION: $USUAGE"
    if [ $USUAGE -ge $DISK_THRESHOLD ]
    then 
        MSG+="High Disk Usuage on $PARTITION: $USUAGE % <br>""   # + near msg will append result of each loop  && \n is for new line
    fi
done <<< $DISK_USUAGE

# echo -e $MSG

sh mail.sh "DevOpsTeam" "High Disk Usuage" "$IP" "$MSG" "sriharibandi99@gmail.com" "ALERT_High Disk Usage"

