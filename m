From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 18/42] ext4: fix #11321: create /proc/ext4/*/stats more carefully
Date: Thu,  9 Oct 2008 00:05:36 -0400
Message-ID: <1223525160-9887-19-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54526 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757568AbYJIEGN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:13 -0400
In-Reply-To: <1223525160-9887-18-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Dobriyan <adobriyan@gmail.com>

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
---
 fs/ext4/mballoc.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c7b0dea..af48548 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2786,14 +2786,20 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
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
@@ -2805,7 +2811,6 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 	return 0;
 
 err_out:
-	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
@@ -2814,6 +2819,8 @@ err_out:
 	remove_proc_entry(EXT4_MB_STATS_NAME, sbi->s_mb_proc);
 	remove_proc_entry(devname, proc_root_ext4);
 	sbi->s_mb_proc = NULL;
+err_create_dir:
+	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 
 	return -ENOMEM;
 }
@@ -2821,12 +2828,15 @@ err_out:
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
-- 
1.5.6.1.205.ge2c7.dirty

