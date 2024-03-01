# Digital Ocean to AWS migration

The migration from Digital Ocean to Amazon Web Services has our hosting provider will 
increase Specify's reliability and security.

Since MySQL 5.7 is now deprecated, we are now using MariaDB v10.11.  In the future we 
hope to upgrade to PostgreSQL

The database backups will be further improved by storing daily backups for a month

For connecting Specify6 to the database via ssh, two things have changed, there will be 
no root login to the server, and the IP address for the database.  The Linux username 
will be the same as in your institution's url, but with 
underscore `_` replacing dashes `-`

Change the database IPs (they have been updated in the wiki [here]
(https://github.com/specify/specify7/wiki/Specify-6-Remote-Access)

Here is an example
On Linux/Mac`ssh -N -L3307:xxx.xx.xx.xx:3306 institution_id@na-db-1.specifycloud.org`
On Windows PuTTY target 

```commandline
C:\Program Files\PuTTY\putty.exe  -ssh -i C:\users\your_user\private_key_.ppk \
    institution_id@eu-db-1.specifycloud.org -L 3307:xxx.xx.xx.xx:3306 -N`
```

For now, you will log into the database as `master` with the same previous passwords, 
but we will soon be creating database user for each institution.