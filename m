From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext3: allow specifying external journal by pathname mount
 option
Date: Tue, 30 Jul 2013 17:26:24 -0500
Message-ID: <51F83D90.5080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Leonardo Menezes Vaz <lvaz@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab3G3W0b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jul 2013 18:26:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's always been a hassle that if an external journal's
device number changes, the filesystem won't mount.
And since boot-time enumeration can change, device number
changes aren't unusual.

The current mechanism to update the journal location is by
passing in a mount option w/ a new devnum, but that's a hassle;
it's a manual approach, fixing things after the fact.

Adding a mount option, "-o journal_path=/dev/$DEVICE" would
help, since then we can do i.e.

# mount -o journal_path=/dev/disk/by-label/$JOURNAL_LABEL /mnt

and it'll mount even if the devnum has changed, as shown here:

# losetup /dev/loop0 journalfile
# mke2fs -L mylabel-journal -O journal_dev /dev/loop0 
# mkfs.ext3 -L mylabel -J device=/dev/loop0 /dev/sdb1

Change the journal device number:

# losetup -d /dev/loop0
# losetup /dev/loop1 journalfile 

And today it will fail:

# mount /dev/sdb1 /mnt/test
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# dmesg | tail -n 1
[17343.240702] EXT3-fs (sdb1): error: couldn't read superblock of external journal

But with this new mount option, we can specify the new path:

# mount -o journal_path=/dev/loop1 /dev/sdb1 /mnt/test
#

(which does update the encoded device number, incidentally):

# umount /dev/sdb1
# dumpe2fs -h /dev/sdb1 | grep "Journal device"
dumpe2fs 1.41.12 (17-May-2010)
Journal device:	          0x0701

But best of all we can just always mount by journal-path, and
it'll always work:

# mount -o journal_path=/dev/disk/by-label/mylabel-journal /dev/sdb1 /mnt/test
#

So the journal_path option can be specified in fstab, and as long as
the disk is available somewhere, and findable by label (or by UUID),
we can mount.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

The patch is a little hacky, doing all the work in option parsing,
just to get to a journal devnum like the old option expected, only
to later re-decode it when we really want to open it.

I could clean it up so that both journal-update mount options
find the bdev, rather than ending with an encoded device number,
which must then be decoded & re-opened, if that seems better.

But this was expedient enough to get the idea out on the list.

If we like it, I'll do ext4 as well.

Thanks,
-Eric


diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 293855e..7ed0d17 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -26,11 +26,12 @@ journal=inum		When a journal already exists, this option is ignored.
 			Otherwise, it specifies the number of the inode which
 			will represent the ext3 file system's journal file.
 
+journal_path=path
 journal_dev=devnum	When the external journal device's major/minor numbers
-			have changed, this option allows the user to specify
+			have changed, these options allow the user to specify
 			the new journal location.  The journal device is
-			identified through its new major/minor numbers encoded
-			in devnum.
+			identified through either its new major/minor numbers
+			encoded in devnum, or via a path to the device.
 
 norecovery		Don't load the journal on mounting. Note that this forces
 noload			mount of inconsistent filesystem, which can lead to
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index c47f147..cb1dd6e 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -819,6 +819,7 @@ enum {
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
 	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
+	Opt_journal_path,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
@@ -860,6 +861,7 @@ static const match_table_t tokens = {
 	{Opt_journal_update, "journal=update"},
 	{Opt_journal_inum, "journal=%u"},
 	{Opt_journal_dev, "journal_dev=%u"},
+	{Opt_journal_path, "journal_path=%s"},
 	{Opt_abort, "abort"},
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
@@ -975,6 +977,9 @@ static int parse_options (char *options, struct super_block *sb,
 	int option;
 	kuid_t uid;
 	kgid_t gid;
+	struct block_device *journal_bdev;
+	char *journal_path;
+
 #ifdef CONFIG_QUOTA
 	int qfmt;
 #endif
@@ -1129,6 +1134,31 @@ static int parse_options (char *options, struct super_block *sb,
 				return 0;
 			*journal_devnum = option;
 			break;
+		case Opt_journal_path:
+			if (is_remount) {
+				ext3_msg(sb, KERN_ERR, "error: cannot specify "
+				       "journal on remount");
+				return 0;
+			}
+			journal_path = match_strdup(&args[0]);
+			if (!journal_path) {
+				ext3_msg(sb, KERN_ERR, "error: could not dup "
+					"journal device string");
+				return 0;
+			}
+			journal_bdev = lookup_bdev(journal_path);
+			if (IS_ERR(journal_bdev)) {
+				ext3_msg(sb, KERN_ERR, "error: could not look "
+					"up journal device: error %d",
+					(int)PTR_ERR(journal_bdev));
+				kfree(journal_path);
+				return 0;
+			}
+
+			*journal_devnum = new_encode_dev(journal_bdev->bd_dev);
+			bdput(journal_bdev);
+			kfree(journal_path);
+			break;
 		case Opt_noload:
 			set_opt (sbi->s_mount_opt, NOLOAD);
 			break;

