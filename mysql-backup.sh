#!/bin/bash
 
################################################################
##
##   MySQL Database Backup Script 
##   Written By: Kishore D R 
##   Last Update: Sep 10, 2019
##
################################################################
 
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`
 
################## Update below values  ########################
DB_BACKUP_PATH='/home/automation/backup' # ---- Backup path 
MYSQL_HOST='your_database_host' # ----   add your DATABASE_HOST address   */
MYSQL_PORT='3306' # ----   MYSQL_PORT no by default 3306 */
MYSQL_USER='your_mysql_user_name' # ---- add your Mysql user name   */
MYSQL_PASSWORD='your_mysql_password' # ---- add your Mysql password   */
DATABASE_NAME='your_database_name' # ---- add your Mysql password   */
BACKUP_RETAIN_DAYS=30   ## Number of days to keep local backup copy
 
 #creating the backup from the database
sudo mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"
 
 #using mysqldump taking the local backup in your local system
sudo mysqldump --routines=true -h ${MYSQL_HOST} \
       --user=${MYSQL_USER} \
       --password=${MYSQL_PASSWORD} \
	${DATABASE_NAME}   | gzip > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz
 
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi
 
#create the moving to the AWS S3 Bucket

sudo  aws s3 cp ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz s3://your_S3_bucket_name/ ## add your AWS S3 Bucket name
