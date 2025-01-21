# Check Asset Usage

On the `assets1.specifycloud.org` instance, we host and manage most[^1] assets for hosted Specify Cloud users.

To see the space used by all current asset directories, you can log into the VPS as your user and run the command:

Europe:
```bash
du -sh * /home/specify/s3_attachments/eu
```

Canada:
```bash
du -sh * /home/specify/s3_attachments/ca
```

North America:
```bash
du -sh * /home/specify/s3_attachments/na
```

This can be adjusted and used elsewhere when needed. You can use `du -sh *` to effectively summarize the space used by a set of directories.

[^1]: Some regions (including Swiss instances via Exoscale, KU collections on KUBI managed VMs) manage assets independently. Brazil has its own asset server running in that region as well.