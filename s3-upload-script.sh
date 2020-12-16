#!/bin/bash

timestamp=$(date +"%F %r")

backupdate=$(date +"%F" --date="-1 day")

copyloc="/root/test"

backlogfile="/var/log/s3bakstatus.log"

email_sub="Amazon s3 Backup Status-KOBELCO"

email_msgs="Backup Successful"

email_msgf="Backup Failed"

/root/.local/bin/aws s3 mv $copyloc/./ s3://vmc-bucket --recursive
if [ $? -eq 0 ];then


    find $copyloc -type f -mtime +2 -exec rm -f {} \;

   echo "Backup Completed Successfully at $timestamp"  >> "$backlogfile"
  
else
   echo "Backup Failed at $timestamp"  >> "$backlogfile"
  
fi

