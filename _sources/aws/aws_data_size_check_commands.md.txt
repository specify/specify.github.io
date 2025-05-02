# AWS Data Size Check Commands

commands to get the database sizes:
```sql
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024 / 1024, 2) AS 'Size (GB)',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')
GROUP BY table_schema;
```

```bash
ssh -i ~/specify/keys/specify_ssh_key ubuntu@na-specify7-1.specifycloud.org \
  "mysql -h specify-cloud-na-db-1.cqvncffkwz9t.us-east-1.rds.amazonaws.com -umaster -p'thing-park-why-green' -e \"SHOW DATABASES;\""
```

```bash
ssh -i ~/specify/keys/specify_ssh_key ubuntu@na-specify7-1.specifycloud.org \
  "mysql -h specify-cloud-na-db-1.cqvncffkwz9t.us-east-1.rds.amazonaws.com \
    -umaster -p'thing-park-why-green' \
    -e \"SELECT table_schema AS \\\"Database\\\", \
      ROUND(SUM(data_length + index_length)/(1024*1024*1024),2) AS \\\"Size (GB)\\\" \
    FROM information_schema.TABLES \
    GROUP BY table_schema \
    ORDER BY SUM(data_length + index_length) DESC;\""
```

commands to get asset server sizes:
```bash
du -sh ~/attachments/*
```

commands to get rds backup sizes:
```bash
aws s3 ls s3://specify-cloud-rds-backups/na-db-snapshot-04-01-25/ --recursive --summarize --human-readable

aws s3 ls s3://specify-cloud-rds-backups-ca/ca-db-snapshot-04-01-25/ --recursive --summarize --human-readable

aws s3 ls s3://specify-cloud-rds-backups-eu/eu-db-snapshot-04-01-25/ --recursive --summarize --human-readable

aws s3 ls s3://specify-cloud-rds-backups-il/il-db-snapshot-04-01-25/ --recursive --summarize --human-readable

aws s3 ls s3://specify-cloud-rds-backups-br/br-db-snapshot-04-01-25/ --recursive --summarize --human-readable
```

command to get mysql backup sizes:
```bash
aws s3 ls s3://specify-cloud-rds-backups/dumps/2025_05_01/ --summarize --human-readable

aws s3 ls s3://specify-cloud-rds-backups-ca/dumps/2025_05_01/ --summarize --human-readable

aws s3 ls s3://specify-cloud-rds-backups-eu/dumps/2025_05_01/ --summarize --human-readable

aws s3 ls s3://specify-cloud-rds-backups-il/dumps/2025_05_01/ --summarize --human-readable

aws s3 ls s3://specify-cloud-rds-backups-br/dumps/2025_05_01/ --summarize --human-readable
```

