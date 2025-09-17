# S3 Asset Server

### Here are the S3 Buckets for each of the Asset Regions:
- us: s3://sp-assets-us/
- ca: s3://sp-assets-ca/
- eu: s3://sp-assets-eu/
- il: s3://sp-assets-il/
- br: s3://sp-assets-br/

### Backup Locations:
- us: s3://sp-assets-na-snaphots/
- ca: s3://sp-assets-ca-snaphot/
- eu: s3://sp-assets-eu-snaphot/
- il: s3://sp-assets-il-snaphot/
- br: s3://specify-cloud-rds-backups-br/asset-backups/

### AWS S3 Sync Commands for Backup Cronjobs:

```bash
aws s3 sync s3://sp-assets-us s3://sp-assets-na-snapshots --size-only --only-show-errors;
aws s3 sync s3://sp-assets-ca s3://sp-assets-ca-snapshot --size-only --only-show-errors;
aws s3 sync s3://sp-assets-eu s3://sp-assets-eu-snapshot --size-only --only-show-errors;
aws s3 sync s3://sp-assets-il s3://specify-cloud-rds-backups-il/asset-backups --size-only --only-show-errors;
aws s3 sync s3://sp-assets-br s3://specify-cloud-rds-backups-br/asset-backups --size-only --only-show-errors;
```

### User S3 Buckets:

The user needs to have an AWS account, then create and upload data to their S3 bucket.

Give the user the follow bucket policy to give Specify and the asset server access to the user's S3 bucket.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowExternalAccountAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::321942852011:user/specify.dev"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::<BucketName>",
        "arn:aws:s3:::<BucketName>/*"
      ]
    }
  ]
}
```

This gives the specify developer AWS user access to the user's S3 bucket, so that the asset server can user the data.  The user can just give access to particular path in their S# bucket if they want.  We also need to make sure that the path they tell us to use is formatted correctly, with an originals and thumbnails directory with the correct file types in each.  The last thing to do is to add the S3 path for the client in the settings.py file in the server.

### User Asset Uploading Without a User S3 Bucket:

If the wants to upload assets directly to the asset server, then uploading over ssh is used.  First an linux user is setup for the client with their ssh keys added.  Second, a s3fs mount is created for that user.  The s3fs mount is mounted as "attachments" in the user's home directory.  The mount will point to the path to the user's folder in S3.  This is so that the user can only access the S3 path in the bucket that is associated with that user.

If a user wants regular backups available to them, a cronjob can be setup to do daily backups, which the user can fetch over ssh via a command like 'scp', 'sftp', or 'rsync'.  A command like this can be used in a cronjob to create a tarball:

```bash
0 3 * * 0 tar -cJf /home/user/user-assets.tar.xz -C /home/ubuntu/attachments user && chown user:user /home/user/user-assets.tar.xz
```

### S3 Attachments

The current asset server is configured to use the AWS S3 API commands to add, get, and delete assets located in S3.  This reduces storage cost compared to EFS, and is faster to run compared to s3fs.  Future development should be to make this universal, so to work on both a local file system, and on S3, and let each client define the setup in the settings file.
