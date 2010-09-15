From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/6] Add inititable/noinititable mount options for ext4
Date: Wed, 15 Sep 2010 18:36:04 +0200
Message-ID: <1284568568-13637-3-git-send-email-lczerner@redhat.com>
References: <1284568568-13637-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0IOQg0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 12:36:26 -0400
In-Reply-To: <1284568568-13637-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add new mount flag EXT4_MOUNT_INIT_INODE_TABLE and add new pair of mount
options (inititable/noinititable). When mounted with inititable file
system should try to initialize uninitialized inode tables, otherwise it
should prevent initializing inode tables. For now, default is noinittable.

One can also specify inititable=n where n is a number that will be used
as the wait multiplier (see "Add inode table initialization code into
Ext4" patch for more info). Bigger number means slower inode table
initialization thus less impact on performance, but longer
inititalization (default is 10).

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..dbd6760 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -885,6 +885,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
 #define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
+#define EXT4_MOUNT_INIT_INODE_TABLE	0x80000000 /* Initialize uninitialized itables */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..3dbae36 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -986,6 +986,10 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, DIOREAD_NOLOCK))
 		seq_puts(seq, ",dioread_nolock");
 
+	if (test_opt(sb, INIT_INODE_TABLE))
+		seq_printf(seq, ",init_inode_table=%u",
+			   (unsigned) sbi->s_li_wait_mult);
+
 	ext4_show_quota_options(seq, sb);
 
 	return 0;
@@ -1161,6 +1165,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard,
+	Opt_init_inode_table, Opt_noinit_inode_table,
 };
 
 static const match_table_t tokens = {
@@ -1231,6 +1236,9 @@ static const match_table_t tokens = {
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
+	{Opt_init_inode_table, "inititable=%u"},
+	{Opt_init_inode_table, "inititable"},
+	{Opt_noinit_inode_table, "noinititable"},
 	{Opt_err, NULL},
 };
 
@@ -1699,6 +1707,20 @@ set_qf_format:
 		case Opt_dioread_lock:
 			clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
 			break;
+		case Opt_init_inode_table:
+			set_opt(sbi->s_mount_opt, INIT_INODE_TABLE);
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = EXT4_DEF_LI_WAIT_MULT;
+			if (option < 0)
+				return 0;
+			sbi->s_li_wait_mult = option;
+			break;
+		case Opt_noinit_inode_table:
+			clear_opt(sbi->s_mount_opt, INIT_INODE_TABLE);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
-- 
1.7.2.2

