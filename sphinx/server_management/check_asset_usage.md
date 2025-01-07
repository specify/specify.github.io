# Check Asset Usage

On the `assets1.specifycloud.org` instance, we host and manage most[^1] assets for hosted Specify Cloud users.

To see the space used by all current asset directories, you can log into the VPS as `root` and run the following alias:

```bash
usage
```

This is defined in the `~/.bash_aliases` file, but it essentially runs this command:
```bash
du -sh * /home/specify/attachments
```

This can be adjusted and used elsewhere when needed. You can use `du -sh *` to effectively summarize the space used by a set of directories.

[^1]: Some regions (including Swiss instances via Exoscale, KU collections on KUBI managed VMs) manage assets independently.