From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Improve error message that changing journaling mode on remount is not possible
Date: Mon, 24 Aug 2009 16:58:30 +0200
Message-ID: <1251125910-2457-3-git-send-email-jack@suse.cz>
References: <1251125910-2457-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbZHXO6b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 10:58:31 -0400
In-Reply-To: <1251125910-2457-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch makes the error message about changing journaling mode on remount
more descriptive. Some people are going to hit this error now due to commit
bbae8bcc49bc4d002221dab52c79a50a82e7cd1f if they configure a kernel to default
to data=writeback mode. The problem happens if they have data=ordered set for
the root filesystem in /etc/fstab but not in the kernel command line (and they
don't use initrd). Their filesystem then gets mounted as data=writeback by
kernel but then their boot fails because init scripts won't be able to remount
the filesystem rw. Better error message will hopefully make it easier for them
to find the error in their setup and bother us less with error reports :).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   40 +++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 524b349..a8d80a7 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -543,6 +543,19 @@ static inline void ext3_show_quota_options(struct seq_file *seq, struct super_bl
 #endif
 }
 
+static char *data_mode_string(unsigned long mode)
+{
+	switch (mode) {
+	case EXT3_MOUNT_JOURNAL_DATA:
+		return "journal";
+	case EXT3_MOUNT_ORDERED_DATA:
+		return "ordered";
+	case EXT3_MOUNT_WRITEBACK_DATA:
+		return "writeback";
+	}
+	return "unknown";
+}
+
 /*
  * Show an option if
  *  - it's set to a non-default value OR
@@ -616,13 +629,8 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 
-	if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA)
-		seq_puts(seq, ",data=journal");
-	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA)
-		seq_puts(seq, ",data=ordered");
-	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)
-		seq_puts(seq, ",data=writeback");
-
+	seq_printf(seq, ",data=%s", data_mode_string(sbi->s_mount_opt &
+						     EXT3_MOUNT_DATA_FLAGS));
 	if (test_opt(sb, DATA_ERR_ABORT))
 		seq_puts(seq, ",data_err=abort");
 
@@ -1024,12 +1032,18 @@ static int parse_options (char *options, struct super_block *sb,
 		datacheck:
 			if (is_remount) {
 				if ((sbi->s_mount_opt & EXT3_MOUNT_DATA_FLAGS)
-						!= data_opt) {
-					printk(KERN_ERR
-						"EXT3-fs: cannot change data "
-						"mode on remount\n");
-					return 0;
-				}
+						== data_opt)
+					break;
+				printk(KERN_ERR
+					"EXT3-fs (device %s): Cannot change "
+					"data mode on remount. The filesystem "
+					"is mounted in data=%s mode and you "
+					"try to remount it in data=%s mode.\n",
+					sb->s_id,
+					data_mode_string(sbi->s_mount_opt &
+							EXT3_MOUNT_DATA_FLAGS),
+					data_mode_string(data_opt));
+				return 0;
 			} else {
 				sbi->s_mount_opt &= ~EXT3_MOUNT_DATA_FLAGS;
 				sbi->s_mount_opt |= data_opt;
-- 
1.6.0.2

