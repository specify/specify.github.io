# Setup remote database connection to local mysql workbench

Help clients setup remote database connection to local mysql workbench with an ssh tunnel. There are slightly different parameters for Mac and Windows machines. This is because the parameters have changed slightly since moving from digital ocean to aws.

The port forwarding command that needs to be used is
`ssh -L 3308:<db_host_ip>:3306 <linux_username>@na-db-1.specifycloud.org -i <path_to_ssh_key>`

Then test the connect by running:
`mysql -h 127.0.0.1 -P 3308 -u<db_username> -p'<db_password>' <database_name>`

MySQL Workbench Parameter example:

DB params:
server host: <db_host_ip>
port: 3306
username: master
password: <db_master_password>
ssh tunnel params:
host: na-db-1.specifycloud.org
user name: ubuntu
private key: /Users/me/specify/keys/specify_ssh_key

Mac/Windows example:

mac/linux: `ssh -L 3307:<db_host_ip>:3306 <linux_username>@il-specify7-1.specifycloud.org -i ~/specify_key`

Windows PuTTY: `C:\Program Files\PuTTY\putty.exe" -ssh -i c:\users\user_name\private_key_specify_cloud.ppk <linux_username>@il-specify7-1.specifycloud.org -L 3307:<db_host_ip>:3306 -N`

`C:\Program Files\PuTTY\putty.exe" -ssh -i c:\users\<user_name>\private_key_specify_cloud.ppk <linux_username>@eu-db-1.specifycloud.org -L 3307:<db_host_ip>:3306 -N`

Here is the command for windows for a remote sqldump: (run in command prompt) or use PuTTY
`plink -ssh -i "C:\path\to\your_private_key.ppk" <llinux_username>@eu-db-1.specifycloud.org "mysqldump --max-allowed-packet=2G --single-transaction -h <db_host_ip> -P 3306 -umaster' --databases <database_name>`
