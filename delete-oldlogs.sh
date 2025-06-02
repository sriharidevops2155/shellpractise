#!/bin/bash


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SOURCE_DIR=/home/ec2-user/app-logs
USERID=$(id -u)

mkdir -p $LOGS_FOLDER

#check the user have root privilages or not ? 
if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: Please run the user with root access $N" | tee -a $LOG_FILE  
    exit 1 #give other than 0 upto 127 
else 
    echo "You are running with root access" | tee -a $LOG_FILE 
fi

#validating if installation is sucedded or not 
VALIDATE()
{
    if [ $1 -eq 0 ]
    then
       echo -e "$2 is ...$G SUCESS $N" | tee -a $LOG_FILE 
    else
       echo -e " $2 is ...$R FAILURE $N "| tee -a $LOG_FILE 
        exit 1
    fi
}

echo "Script started executing at $(date)" | tee -a $LOG_FILE 

FILES_TO_DEL=$(find $SOURCE_DIR -name "*.log" -mtime +14 )
while IFS= read -r filepath 
do
   echo "Deleting file $filepath" | tee -a $LOG_FILE 
   rm -rf $filepath | tee -a $LOG_FILE 
done <<< $FILES_TO_DEL

echo "Script executed sucessfully"
