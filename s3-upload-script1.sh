#!/bin/bash

Admin="AWS-OPS@sifycorp.com"

timestamp=$(date +"%F %r")

backupdate=$(date +"%F" --date="-1 day")

copyloc="/var/monthly"

backlogfile="/var/log/s3bakstatus.log"

email_sub="Amazon s3 Backup Status-KOBELCO"

email_msgs="Backup Successful"

email_msgf="Backup Failed"

/usr/bin/aws s3 cp $copyloc/sql_"$backupdate" s3://test1234-1/new/ 

if [ $? -eq 0 ];then


    find $copyloc -type f -mtime +2 -exec rm -f {} \;

   echo "Backup Completed Successfully at $timestamp"  >> "$backlogfile"
   echo "$email_msgs" | mail -s "$email_sub" -r "$(hostname)<alert@sify.net>" $Admin
else
   echo "Backup Failed at $timestamp"  >> "$backlogfile"
   echo "$email_msgf" | mail -s "$email_sub" -r "$(hostname)<alert@sify.net>" $Admin
fi

