#!/bin/bash

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}  # :- if DAYS are provided that will be considered, otherwise default 14 days

LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_root()
{
#check the user have root privilages or not ? 
    if [ $USERID -ne 0 ]
    then 
        echo -e "$R ERROR: Please run the user with root access $N" | tee -a $LOG_FILE  
        exit 1 #give other than 0 upto 127 
    else 
        echo "You are running with root access" | tee -a $LOG_FILE 
    fi
}

check_root
mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE 


USAGE()
{
    echo -e "$R USAGE:: $N sh 20-backup.sh <source-dir> <dest-dir> <days(optional)>"
}

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

if [$# -lt 2 ]
then 
    USAGE 
fi
