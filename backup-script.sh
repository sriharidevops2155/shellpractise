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
USERID=$(id -u)

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

USAGE()
{
    echo -e "$R USAGE:: $N sh 20-backup.sh <source-dir> <dest-dir> <days(optional)>"
}

if [ $# -lt 2 ]
then 
    USAGE 
fi

if [ ! -d $SOURCE_DIR ]
then 
    echo -e "$R Source directory  $SOURCE_DIR doesn't exist. Please check $N"
    exit 1
fi

if [ ! -d $DEST_DIR ]
then 
    echo -e "$R Destination directory $DEST_DIR doesn't exist. Please check $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

if [ ! -z $FILES ]
then
    echo "Files to zip are: $FILES"
    TIME_STAMP=$(date +%F-%Hh-%Mm-%Ss)
    ZIP_FILE="$DEST_DIR/app-logs-$TIME_STAMP.zip"
    echo $FILES | zip -@ $ZIP_FILE

    if [ -f $ZIP_FILE ]
    then 
        echo -e "Sucessfully created zip file"
        FILES_TO_DEL=$(find $SOURCE_DIR -name "*.log" -mtime +14 )
        while IFS= read -r filepath 
        do
        echo "Deleting file $filepath" | tee -a $LOG_FILE 
        rm -rf $filepath | tee -a $LOG_FILE 
        done <<< $FILES_TO_DEL
        echo -e "Log files older than $DAYS from source $SOURCE_DIR  removed .....$G SUCCESS $N"
    else 
        echo -e "Zip file creation....... $R FAILED"
        exit 1
    fi
    

else 
    echo -e "No log files found older than 14 days... $Y Skipping $N"
fi

 