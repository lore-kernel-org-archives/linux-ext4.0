From: <gregkh@suse.de>
Subject: patch ext4-fix-11321-create-proc-ext4-stats-more-carefully.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:55:53 -0800
Message-ID: <20081203185919.11CAB49045@coco.kroah.org>
References: <1226851540-8032-3-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: adobriyan@gmail.com, gregkh@suse.de, linux-ext4@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751787AbYLCS7U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:20 -0500
In-Reply-To: <1226851540-8032-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: fix #11321: create /proc/ext4/*/stats more carefully

to the 2.6.27-stable tree.  Its filename is

    ext4-fix-11321-create-proc-ext4-stats-more-carefully.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 09:56:22 2008
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 16 Nov 2008 11:05:22 -0500
Subject: ext4: fix #11321: create /proc/ext4/*/stats more carefully
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Alexey Dobriyan <adobriyan@gmail.com>
Message-ID: <1226851540-8032-3-git-send-email-tytso@mit.edu>


From: Alexey Dobriyan <adobriyan@gmail.com>

(cherry picked from commit 899fc1a4cf404747de2666534d508804597ee22f)

ext4 creates per-suberblock directory in /proc/ext4/ . Name used as
basis is taken from bdevname, which, surprise, can contain slash.

However, proc while allowing to use proc_create("a/b", parent) form of
PDE creation, assumes that parent/a was already created.

bdevname in question is 'cciss/c0d0p9', directory is not created and all
this stuff goes directly into /proc (which is real bug).

Warning comes when _second_ partition is mounted.

http://bugzilla.kernel.org/show_bug.cgi?id=11321

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2785,14 +2785,20 @@ static int ext4_mb_init_per_dev_proc(str
 	mode_t mode = S_IFREG | S_IRUGO | S_IWUSR;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct proc_dir_entry *proc;
-	char devname[64];
+	char devname[BDEVNAME_SIZE], *p;
 
 	if (proc_root_ext4 == NULL) {
 		sbi->s_mb_proc = NULL;
 		return -EINVAL;
 	}
 	bdevname(sb->s_bdev, devname);
+	p = devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
+
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
+	if (!sbi->s_mb_proc)
+		goto err_create_dir;
 
 	MB_PROC_HANDLER(EXT4_MB_STATS_NAME, stats);
 	MB_PROC_HANDLER(EXT4_MB_MAX_TO_SCAN_NAME, max_to_scan);
@@ -2804,7 +2810,6 @@ static int ext4_mb_init_per_dev_proc(str
 	return 0;
 
 err_out:
-	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
@@ -2813,6 +2818,8 @@ err_out:
 	remove_proc_entry(EXT4_MB_STATS_NAME, sbi->s_mb_proc);
 	remove_proc_entry(devname, proc_root_ext4);
 	sbi->s_mb_proc = NULL;
+err_create_dir:
+	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 
 	return -ENOMEM;
 }
@@ -2820,12 +2827,15 @@ err_out:
 static int ext4_mb_destroy_per_dev_proc(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	char devname[64];
+	char devname[BDEVNAME_SIZE], *p;
 
 	if (sbi->s_mb_proc == NULL)
 		return -EINVAL;
 
 	bdevname(sb->s_bdev, devname);
+	p = devname;
+	while ((p = strchr(p, '/')))
+		*p = '!';
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);


Patches currently in stable-queue which might be from adobriyan@gmail.com are

queue-2.6.27/ext4-fix-11321-create-proc-ext4-stats-more-carefully.patch
