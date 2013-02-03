From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] ext4: check incompatible mount options while mounting ext2/3
Date: Sat,  2 Feb 2013 23:44:06 -0500
Message-ID: <1359866646-29876-5-git-send-email-tytso@mit.edu>
References: <1359866646-29876-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46688 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab3BCEoM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Feb 2013 23:44:12 -0500
In-Reply-To: <1359866646-29876-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check for incompatible mount options when using the ext4 file system
driver to mount ext2 or ext3 file systems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c | 47 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bcd5f12..b132df5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1409,6 +1409,9 @@ static int clear_qf_name(struct super_block *sb, int qtype)
 #define MOPT_QFMT	MOPT_NOSUPPORT
 #endif
 #define MOPT_DATAJ	0x0080
+#define MOPT_NO_EXT2	0x0100
+#define MOPT_NO_EXT3	0x0200
+#define MOPT_EXT4_ONLY	(MOPT_NO_EXT2 | MOPT_NO_EXT3)
 
 static const struct mount_opts {
 	int	token;
@@ -1421,21 +1424,29 @@ static const struct mount_opts {
 	{Opt_nogrpid, EXT4_MOUNT_GRPID, MOPT_CLEAR},
 	{Opt_block_validity, EXT4_MOUNT_BLOCK_VALIDITY, MOPT_SET},
 	{Opt_noblock_validity, EXT4_MOUNT_BLOCK_VALIDITY, MOPT_CLEAR},
-	{Opt_dioread_nolock, EXT4_MOUNT_DIOREAD_NOLOCK, MOPT_SET},
-	{Opt_dioread_lock, EXT4_MOUNT_DIOREAD_NOLOCK, MOPT_CLEAR},
+	{Opt_dioread_nolock, EXT4_MOUNT_DIOREAD_NOLOCK,
+	 MOPT_EXT4_ONLY | MOPT_SET},
+	{Opt_dioread_lock, EXT4_MOUNT_DIOREAD_NOLOCK,
+	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_discard, EXT4_MOUNT_DISCARD, MOPT_SET},
 	{Opt_nodiscard, EXT4_MOUNT_DISCARD, MOPT_CLEAR},
-	{Opt_delalloc, EXT4_MOUNT_DELALLOC, MOPT_SET | MOPT_EXPLICIT},
-	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR | MOPT_EXPLICIT},
-	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM, MOPT_SET},
+	{Opt_delalloc, EXT4_MOUNT_DELALLOC,
+	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
+	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC,
+	 MOPT_EXT4_ONLY | MOPT_CLEAR | MOPT_EXPLICIT},
+	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
+	 MOPT_EXT4_ONLY | MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
-				    EXT4_MOUNT_JOURNAL_CHECKSUM), MOPT_SET},
-	{Opt_noload, EXT4_MOUNT_NOLOAD, MOPT_SET},
+				    EXT4_MOUNT_JOURNAL_CHECKSUM),
+	 MOPT_EXT4_ONLY | MOPT_SET},
+	{Opt_noload, EXT4_MOUNT_NOLOAD, MOPT_NO_EXT2 | MOPT_SET},
 	{Opt_err_panic, EXT4_MOUNT_ERRORS_PANIC, MOPT_SET | MOPT_CLEAR_ERR},
 	{Opt_err_ro, EXT4_MOUNT_ERRORS_RO, MOPT_SET | MOPT_CLEAR_ERR},
 	{Opt_err_cont, EXT4_MOUNT_ERRORS_CONT, MOPT_SET | MOPT_CLEAR_ERR},
-	{Opt_data_err_abort, EXT4_MOUNT_DATA_ERR_ABORT, MOPT_SET},
-	{Opt_data_err_ignore, EXT4_MOUNT_DATA_ERR_ABORT, MOPT_CLEAR},
+	{Opt_data_err_abort, EXT4_MOUNT_DATA_ERR_ABORT,
+	 MOPT_NO_EXT2 | MOPT_SET},
+	{Opt_data_err_ignore, EXT4_MOUNT_DATA_ERR_ABORT,
+	 MOPT_NO_EXT2 | MOPT_CLEAR},
 	{Opt_barrier, EXT4_MOUNT_BARRIER, MOPT_SET},
 	{Opt_nobarrier, EXT4_MOUNT_BARRIER, MOPT_CLEAR},
 	{Opt_noauto_da_alloc, EXT4_MOUNT_NO_AUTO_DA_ALLOC, MOPT_SET},
@@ -1451,9 +1462,10 @@ static const struct mount_opts {
 	{Opt_resgid, 0, MOPT_GTE0},
 	{Opt_journal_dev, 0, MOPT_GTE0},
 	{Opt_journal_ioprio, 0, MOPT_GTE0},
-	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_DATAJ},
-	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_DATAJ},
-	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA, MOPT_DATAJ},
+	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
+	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
+	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA,
+	 MOPT_NO_EXT2 | MOPT_DATAJ},
 	{Opt_user_xattr, EXT4_MOUNT_XATTR_USER, MOPT_SET},
 	{Opt_nouser_xattr, EXT4_MOUNT_XATTR_USER, MOPT_CLEAR},
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
@@ -1531,6 +1543,17 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		return -1;
 	}
 
+	if ((m->flags & MOPT_NO_EXT2) && IS_EXT2_SB(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Mount option \"%s\" incompatible with ext2", opt);
+		return -1;
+	}
+	if ((m->flags & MOPT_NO_EXT3) && IS_EXT3_SB(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Mount option \"%s\" incompatible with ext3", opt);
+		return -1;
+	}
+
 	if (args->from && match_int(args, &arg))
 		return -1;
 	if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
-- 
1.7.12.rc0.22.gcdd159b

