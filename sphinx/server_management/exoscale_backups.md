# Backups on Exoscale

To configure the backups, you first need to create an [Exoscale bucket](https://portal.exoscale.com/u/specify-collections-consortium/storage). 

For our backups, we have one named 'swiss-backups'.

In this instance, I chose the `CH-GVA-2` zone so that the data remains in Geneva.

> Exoscale has [great instructions](https://community.exoscale.com/documentation/storage/quick-start/) on how to connect to a bucket.

First, you must install `s3cmd` to connect to the Exoscale Bucket (as `root`):
```sh
apt-get update && apt-get install s3cmd
```

`s3cmd` enables us to create and use Exoscale buckets. Our configuration file (located at `/home/ubuntu/.s3cfg`) looks like this:

```
[default]
host_base = sos-ch-gva-2.exo.io
host_bucket = %(bucket)s.sos-ch-gva-2.exo.io
access_key = $EXO_SOS_KEY
secret_key = $EXO_SOS_SECRET
use_https = True
```
(**Note:** $EXO_SOS_KEY and $EXO_SOS_SECRET are hidden for this guide)

I created an IAM Role named 'Create Backups' that will be used to connect the compute instances to the bucket. Once this was done, I generated an API key pair for that role.

Now that this is configured, you can place files into the bucket by simply running `s3cmd put ${file_name} s3://swiss-backups/${file_name}`:

```sh
ubuntu@sp7cloud-swiss-1:~$ touch hello-world.txt
ubuntu@sp7cloud-swiss-1:~$ s3cmd put hello-world.txt s3://swiss-backups/hello-world.txt
upload: 'hello-world.txt' -> 's3://swiss-backups/hello-world.txt'  [1 of 1]
 12 of 12   100% in    0s   110.91 B/s  done
 ```

Now that this is configured, we can use a script to backup the databases nightly:

```sh
#!/bin/bash

# Get the current date in YYYY_mm_dd format
current_date=$(date +"%Y_%m_%d")

# Create the date directory in the backup bucket
bucket_dir="s3://swiss-backups/${current_date}"

# Fetch the list of databases dynamically
databases=$(mysql -h 0.0.0.0 -P 3306 -uroot -p"$MYSQL_ROOT_PASSWORD" -e 'SHOW DATABASES;' | grep -Ev '^(Database|information_schema|performance_schema|mysql|sys)$')

# Loop through each database and perform the backup
for db in $databases; do
  # Create the backup file name for the upload
  backup_file_name="${db}_${current_date}.sql.gz"

  echo "Backing up database: $db"

  # Perform the mysqldump and upload directly to the Exoscale bucket
  mysqldump --max-allowed-packet=2G --single-transaction -h 0.0.0.0 -P 3306 -uroot -p"$MYSQL_ROOT_PASSWORD" "$db" | gzip | s3cmd put - "${bucket_dir}/${backup_file_name}"

  # Check if the upload was successful
  if [ $? -eq 0 ]; then
    echo "Backup of $db completed and uploaded successfully to $bucket_dir."
  else
    echo "Backup of $db failed or upload failed." >&2
  fi
done
```

See the process after running the script at `/home/ubuntu/.backup/backup_script.sh`:
```sh
ubuntu@sp7cloud-swiss-1:~/.backup$ sh backup_script.sh
Backing up database: geo_swiss
upload: '<stdin>' -> 's3://swiss-backups/2024_08_14/geo_swiss_2024_08_14.sql.gz'  [part 1 of -, 6MB] [1 of 1]
 6365386 of 6365386   100% in    0s    26.16 MB/s  done
Backup of geo_swiss completed and uploaded successfully to s3://swiss-backups/2024_08_14.
Backing up database: mcsn
upload: '<stdin>' -> 's3://swiss-backups/2024_08_14/mcsn_2024_08_14.sql.gz'  [part 1 of -, 4MB] [1 of 1]
 4602206 of 4602206   100% in    0s    20.33 MB/s  done
Backup of mcsn completed and uploaded successfully to s3://swiss-backups/2024_08_14.
Backing up database: mhnc
upload: '<stdin>' -> 's3://swiss-backups/2024_08_14/mhnc_2024_08_14.sql.gz'  [part 1 of -, 4MB] [1 of 1]
 4588230 of 4588230   100% in    0s    16.26 MB/s  done
Backup of mhnc completed and uploaded successfully to s3://swiss-backups/2024_08_14.
Backing up database: mhnf
upload: '<stdin>' -> 's3://swiss-backups/2024_08_14/mhnf_2024_08_14.sql.gz'  [part 1 of -, 5MB] [1 of 1]
 5861026 of 5861026   100% in    0s    25.46 MB/s  done
Backup of mhnf completed and uploaded successfully to s3://swiss-backups/2024_08_14.
Backing up database: naag
upload: '<stdin>' -> 's3://swiss-backups/2024_08_14/naag_2024_08_14.sql.gz'  [part 1 of -, 10MB] [1 of 1]
 11213948 of 11213948   100% in    0s    24.78 MB/s  done
Backup of naag completed and uploaded successfully to s3://swiss-backups/2024_08_14.
Backing up database: nmb_rinvert
upload: '<stdin>' -> 's3://swiss-backups/2024_08_14/nmb_rinvert_2024_08_14.sql.gz'  [part 1 of -, 6MB] [1 of 1]
 6450282 of 6450282   100% in    0s    30.53 MB/s  done
Backup of nmb_rinvert completed and uploaded successfully to s3://swiss-backups/2024_08_14.
Backing up database: sp7demofish_swiss
upload: '<stdin>' -> 's3://swiss-backups/2024_08_14/sp7demofish_swiss_2024_08_14.sql.gz'  [part 1 of -, 15MB] [1 of 1]
 15728640 of 15728640   100% in    0s    30.45 MB/s  done
upload: '<stdin>' -> 's3://swiss-backups/2024_08_14/sp7demofish_swiss_2024_08_14.sql.gz'  [part 2 of -, 6MB] [1 of 1]
 6776807 of 6776807   100% in    0s    23.11 MB/s  done
Backup of sp7demofish_swiss completed and uploaded successfully to s3://swiss-backups/2024_08_14.
ubuntu@sp7cloud-swiss-1:~/.backup$
```

I configured a cron job to run this at 2 AM CEST (12 AM UTC) every day:
```sh
# m h  dom mon dow   command
0 0 * * * /home/ubuntu/.backup/backup_script.sh
```

Now this backup will run and be available within the bucket for future retrieval as needed!

```sh
ubuntu@sp7cloud-swiss-1:~/.backup$ s3cmd ls s3://swiss-backups/
                          DIR  s3://swiss-backups/2024_08_14/
ubuntu@sp7cloud-swiss-1:~/.backup$ s3cmd ls s3://swiss-backups/2024_08_14/
2024-08-14 00:44      6365385  s3://swiss-backups/2024_08_14/geo_swiss_2024_08_14.sql.gz
2024-08-14 00:44      4602206  s3://swiss-backups/2024_08_14/mcsn_2024_08_14.sql.gz
2024-08-14 00:44      4588230  s3://swiss-backups/2024_08_14/mhnc_2024_08_14.sql.gz
2024-08-14 00:45      5861026  s3://swiss-backups/2024_08_14/mhnf_2024_08_14.sql.gz
2024-08-14 00:45     11213948  s3://swiss-backups/2024_08_14/naag_2024_08_14.sql.gz
2024-08-14 00:45      6450282  s3://swiss-backups/2024_08_14/nmb_rinvert_2024_08_14.sql.gz
2024-08-14 00:45     22505447  s3://swiss-backups/2024_08_14/sp7demofish_swiss_2024_08_14.sql.gz
ubuntu@sp7cloud-swiss-1:~/.backup$
```