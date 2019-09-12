# Automatic daily backup of Amazon RDS/MySQL Database from EC2 Instance to Amazon S3 using Shell Script and cron jobs

Easy way and scalable solution for your Amazon RDS/MySQL Database backups by using of Amazon RDS.

If you are not using RDS to host your databases, it is very probable that you are doing your own backups. In this project we'll see a very simple shell script to do automatic daily backups for your mysql databases into an S3 bucket.

## What you need to do to upload your MySQL backups to S3

* Create an S3 Bucket in AWS.
* Configuring the AWS CLI.
* Create access key/secret for an IAM user.
* Configure S3 command line/AWS Cli tools on server 
* Create Bash Script that contains MySQL credentials (Hostname, Username, DB Name) path to your server where you want to store dump (PATH), log path etc.,
* Apply chmod +x on Shell Script (mysql-backup.sh)
* Schedule with cron as per your requirement

### Create S3 Bucket in AWS
![Create S3 Bucket](https://docs.aws.amazon.com/AmazonS3/latest/gsg/images/flowCreateABucket.png)

1. Sign in to the AWS Management Console and open the Amazon S3 console at [AWS Console](https://console.aws.amazon.com/s3/)
2. Choose ```Create bucket```
3. In the Bucket name field, type a unique DNS-compliant name for your new bucket. (The example screen shot uses the bucket name admin-created. You cannot use this name because S3 bucket names must be unique.) Create your own bucket name using the following naming guidelines:
    * The name must be unique across all existing bucket names in Amazon S3.
    * After you create the bucket you cannot change the name, so choose wisely.
    * Choose a bucket name that reflects the objects in the bucket because the bucket name is visible in the URL that points to the objects that you're going to put in your bucket.
 4. For Region, choose US West (Oregon) as the region where you want the bucket to reside.
 5. Choose Create
 6. ![Create S3 Bucket](https://docs.aws.amazon.com/AmazonS3/latest/gsg/images/gsg-create-bucket-name-region.png)

### Configuring the AWS CLI
This section explains how to configure the settings that the AWS Command Line Interface (AWS CLI) uses to interact with AWS, including your security credentials, the default output format, and the default AWS Region.

* Note: AWS requires that all incoming requests are cryptographically signed. The AWS CLI does this for you. The               "signature" includes a date/time stamp. Therefore, you must ensure that your computer's date and time are set          correctly. If you don't, and the date/time in the signature is too far off of the date/time recognized by the          AWS service, then AWS rejects the request.

For general use, the ``` aws configure ``` command is the fastest way to set up your AWS CLI installation.
 
``` 
aws configure
AWS Access Key ID [None]: Your_Access_Key_ID
AWS Secret Access Key [None]: Your_Secret_Access_Key
Default region name [None]: region name
Default output format [None]: json
```

### Create access key/secret  for an IAM user.

1. Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/.
2. In the navigation pane, choose **Users.**
3. Choose the name of the user whose access keys you want to create, and then choose the **Security credentials tab.**
4. In the **Access keys** section, choose **Create access key.**
5. To view the new access key pair, choose Show. You will not have access to the secret access key again after this dialog box closes. Your credentials will look something like this:
    * Access key ID: AKIAIOSFODNN7EXAMPLE
    * Secret access key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
6. To download the key pair, choose **Download .csv file.** Store the keys in a secure location. You will not have access to the secret access key again after this dialog box closes.
Keep the keys confidential in order to protect your AWS account and never email them. Do not share them outside your organization, even if an inquiry appears to come from AWS or Amazon.com. No one who legitimately represents Amazon will ever ask you for your secret key.
7. After you download the .csv file, choose **Close.** When you create an access key, the key pair is active by default, and you can use the pair right away.

* Region
The Default ``` region name ``` identifies the AWS Region whose servers you want to send your requests to by default. This is typically the Region closest to you, but it can be any Region. For example, you can type ``` us-west-2 ``` to use US West (Oregon). This is the Region that all later requests are sent to, unless you specify otherwise in an individual command.

* Output Format

The ``` Default output format ``` specifies how the results are formatted. The value can be any of the values in the following list. If you don't specify an output format, json is used as the default.
* **json**: The output is formatted as a JSON string.
* **text**: The output is formatted as multiple lines of tab-separated string values, which can be useful if you want to pass the output to a text processor, like grep, sed, or awk.
* **table**: The output is formatted as a table using the characters +|- to form the cell borders. It typically presents the information in a "human-friendly" format that is much easier to read than the others, but not as programmatically useful.

#### Creating Profile
If you use the command shown in the previous section, the result is a single profile named default. You can create additional configurations that you can refer to with a name by specifying the ``` --profile ``` option and assign a name. The following example creates a profile named produser. You can specify credentials from a completely different account and region than the other profiles.
```
$ aws configure 
AWS Access Key ID [None]: AKIAI44QH8DHBEXAMPLE
AWS Secret Access Key [None]: je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: text
```
or you can use --profile produser
```
$ aws configure --profile produser
AWS Access Key ID [None]: AKIAI44QH8DHBEXAMPLE
AWS Secret Access Key [None]: je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: text
```
Then, when you run a command, you can omit the --profile option and use the credentials and settings stored in the default profile.
```
$ aws s3 ls
```

####  Adding MySQL Credentials and Location to dump a file
fetching current day date
```
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`
```
Add your MySql Server credentials 
```
DB_BACKUP_PATH='/home/automation/backup' # ---- Backup path 
MYSQL_HOST='your_database_host' # ----   add your DATABASE_HOST address   */
MYSQL_PORT='3306' # ----   MYSQL_PORT no by default 3306 */
MYSQL_USER='your_mysql_user_name' # ---- add your Mysql user name   */
MYSQL_PASSWORD='your_mysql_password' # ---- add your Mysql password   */
DATABASE_NAME='your_database_name' # ---- add your Mysql password   */
BACKUP_RETAIN_DAYS=30   ## Number of days to keep local backup copy
 ```

#### Give chmod +x on Shell Script
 ```
 chmod +x mysql-backup.sh
 ```
#### Schedule Cron Jobs
 
 Create your own crontab file, type the following command at the UNIX / Linux shell prompt:
 ```
 $ crontab -e
 ```
* Syntax of crontab (field description)
The syntax is:
```
1 2 3 4 5 /path/to/command arg1 arg2
```
OR
```
1 2 3 4 5 /root/backup.sh
```

Where,

   * 1: Minute (0-59)
   * 2: Hours (0-23)
   * 3: Day (0-31)
   * 4: Month (0-12 [12 == December])
   * 5: Day of the week(0-7 [7 or 0 == sunday])
   * /path/to/command – Script or command name to schedule

```
* * * * * command to be executed
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)
```

#### Example: Running a backup cron job script
**If you wish to have a script named ```/home/backup.sh``` run every day at 3am, your crontab entry would look like this. First, install your cronjob by running the following command:** 

Append the following entry:
```
0 0 * * * /home/backup.sh
```
Save and close the file.
