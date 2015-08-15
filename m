From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: ratelimit the file system mounted message
Date: Sat, 15 Aug 2015 14:59:57 -0400
Message-ID: <1439665197-10766-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60563 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbbHOTAA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Aug 2015 15:00:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The xfstests ext4/305 will mount and unmount the same file system over
4,000 times, and each one of these will cause a system log message.
Ratelimit this message since if we are getting more than a few dozen
of these messages, they probably aren't going to be helpful.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 70c52ea..45658c1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -60,6 +60,7 @@ static struct ext4_lazy_init *ext4_li_info;
 static struct mutex ext4_li_mtx;
 static struct ext4_features *ext4_feat;
 static int ext4_mballoc_ready;
+static struct ratelimit_state ext4_mount_msg_ratelimit;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
@@ -4277,9 +4278,10 @@ no_journal:
 				 "the device does not support discard");
 	}
 
-	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
-		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
-		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
+	if (___ratelimit(&ext4_mount_msg_ratelimit, "EXT4-fs mount"))
+		ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
+			 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
+			 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
 
 	if (es->s_error_count)
 		mod_timer(&sbi->s_err_report, jiffies + 300*HZ); /* 5 minutes */
@@ -5617,6 +5619,7 @@ static int __init ext4_init_fs(void)
 {
 	int i, err;
 
+	ratelimit_state_init(&ext4_mount_msg_ratelimit, 30 * HZ, 64);
 	ext4_li_info = NULL;
 	mutex_init(&ext4_li_mtx);
 
-- 
2.5.0

