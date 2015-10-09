From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: do not allow journal_opts for fs w/o journal
Date: Fri,  9 Oct 2015 13:09:59 +0400
Message-ID: <1444381799-10566-2-git-send-email-dmonakhov@openvz.org>
References: <1444381799-10566-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:34083 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbbJIJyy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Oct 2015 05:54:54 -0400
In-Reply-To: <1444381799-10566-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It is appeared that we can pass journal related mount options and such options
be shown in /proc/mounts

Example:
#mkfs.ext4 -F /dev/vdb
#tune2fs -O ^has_journal /dev/vdb
#mount /dev/vdb /mnt/  -ocommit=20,journal_async_commit
#cat /proc/mounts  | grep /mnt
 /dev/vdb /mnt ext4 rw,relatime,journal_checksum,journal_async_commit,commit=20,data=ordered 0 0

But options:"journal_checksum,journal_async_commit,commit=20,data=ordered" has
nothing with reality because there is no jornall at all.

This patch disallow following options for journalless configurations:
 - journal_checksum
 - journal_async_commit
 - commit=%ld
 - data={writeback,ordered,journal}

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    3 +++
 fs/ext4/super.c |   31 +++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f248c9..871cdc6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1019,6 +1019,9 @@ struct ext4_inode_info {
 #define EXT4_MOUNT2_HURD_COMPAT		0x00000004 /* Support HURD-castrated
 						      file systems */
 
+#define EXT4_MOUNT2_EXPLICIT_JOURNAL_CHECKSUM	0x00000008 /* User explicitly
+						specified journal checksum */
+
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
 #define set_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt |= \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e91f6d4..a29b32b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1371,10 +1371,10 @@ static const struct mount_opts {
 	{Opt_nojournal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
-	 MOPT_EXT4_ONLY | MOPT_SET},
+	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
 				    EXT4_MOUNT_JOURNAL_CHECKSUM),
-	 MOPT_EXT4_ONLY | MOPT_SET},
+	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
 	{Opt_noload, EXT4_MOUNT_NOLOAD, MOPT_NO_EXT2 | MOPT_SET},
 	{Opt_err_panic, EXT4_MOUNT_ERRORS_PANIC, MOPT_SET | MOPT_CLEAR_ERR},
 	{Opt_err_ro, EXT4_MOUNT_ERRORS_RO, MOPT_SET | MOPT_CLEAR_ERR},
@@ -1506,6 +1506,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	if (m->flags & MOPT_EXPLICIT) {
 		if (m->mount_opt & EXT4_MOUNT_DELALLOC) {
 			set_opt2(sb, EXPLICIT_DELALLOC);
+		} else if (m->mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) {
+			set_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM);
 		} else
 			return -1;
 	}
@@ -3675,6 +3677,31 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		       "suppressed and not mounted read-only");
 		goto failed_mount_wq;
 	} else {
+		/* Nojournal mode, all journal mount options are illegal */
+		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "journal_checksum, fs mounted w/o journal");
+			goto failed_mount_wq;
+		}
+		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "journal_async_commit, fs mounted w/o journal");
+			goto failed_mount_wq;
+		}
+		if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "commit=%lu, fs mounted w/o journal",
+				 sbi->s_commit_interval / HZ);
+			goto failed_mount_wq;
+		}
+		if (EXT4_MOUNT_DATA_FLAGS &
+		    (sbi->s_mount_opt ^ sbi->s_def_mount_opt)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "data=, fs mounted w/o journal");
+			goto failed_mount_wq;
+		}
+		sbi->s_def_mount_opt &= EXT4_MOUNT_JOURNAL_CHECKSUM;
+		clear_opt(sb, JOURNAL_CHECKSUM);
 		clear_opt(sb, DATA_FLAGS);
 		sbi->s_journal = NULL;
 		needs_recovery = 0;
-- 
1.7.1

