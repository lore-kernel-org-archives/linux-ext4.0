From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: deprecate obsoleted mount options
Date: Fri, 19 Feb 2010 17:39:30 +0300
Message-ID: <87d401jnml.fsf_-_@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
	<1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
	<E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
	<20100218205218.GL5337@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40018 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab0BSOjn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Feb 2010 09:39:43 -0500
In-Reply-To: <20100218205218.GL5337@thunk.org> (tytso@mit.edu's message of
	"Thu, 18 Feb 2010 15:52:18 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

This patch deprecate some obsoleted functions.
It is not obvious what should we do in case of deprecated options on mount.
Just printk and continue or fail the mount, i've implemented the last one.
BTW: Do we need similar patch for e2fslib?


--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-deprecate-obsoleted-mount-options.patch

>From 72649dbf903705df6f20c330e0fcecabf24e426e Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Fri, 19 Feb 2010 17:20:36 +0300
Subject: [PATCH] ext4: deprecate obsoleted mount options

Disable following list of obsoleted mount options:
 - bsddf, miniddf
 - grpid, bsdgroups, nogrpid, sysvgroups

Disable following list of obsoleted default mount options
 - bsdgroups

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h   |    4 +-
 fs/ext4/ialloc.c |    4 +--
 fs/ext4/super.c  |   96 ++++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 68 insertions(+), 36 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 67859fa..1fd55a7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -731,12 +731,10 @@ struct ext4_inode_info {
  * Mount flags
  */
 #define EXT4_MOUNT_OLDALLOC		0x00002  /* Don't use the new Orlov allocator */
-#define EXT4_MOUNT_GRPID		0x00004	/* Create files with directory's group */
 #define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging messages */
 #define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on errors */
 #define EXT4_MOUNT_ERRORS_RO		0x00020	/* Remount fs ro on errors */
 #define EXT4_MOUNT_ERRORS_PANIC		0x00040	/* Panic on errors */
-#define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
 #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
 #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
 #define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
@@ -1185,6 +1183,8 @@ static inline void ext4_clear_inode_state(struct inode *inode, int bit)
 #define EXT4_DEFM_JMODE_DATA	0x0020
 #define EXT4_DEFM_JMODE_ORDERED	0x0040
 #define EXT4_DEFM_JMODE_WBACK	0x0060
+/* Deprecated default mount options mask */
+#define EXT4_DEFM_DEPRECATED	EXT4_DEFM_BSDGROUPS
 
 /*
  * Default journal batch times
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2fab5ad..0bccf0d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -986,9 +986,7 @@ got:
 	}
 
 	inode->i_uid = current_fsuid();
-	if (test_opt(sb, GRPID))
-		inode->i_gid = dir->i_gid;
-	else if (dir->i_mode & S_ISGID) {
+	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9e45e62..7fb9e77 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -823,12 +823,6 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 
 	if (sbi->s_sb_block != 1)
 		seq_printf(seq, ",sb=%llu", sbi->s_sb_block);
-	if (test_opt(sb, MINIX_DF))
-		seq_puts(seq, ",minixdf");
-	if (test_opt(sb, GRPID) && !(def_mount_opts & EXT4_DEFM_BSDGROUPS))
-		seq_puts(seq, ",grpid");
-	if (!test_opt(sb, GRPID) && (def_mount_opts & EXT4_DEFM_BSDGROUPS))
-		seq_puts(seq, ",nogrpid");
 	if (sbi->s_resuid != EXT4_DEF_RESUID ||
 	    le16_to_cpu(es->s_def_resuid) != EXT4_DEF_RESUID) {
 		seq_printf(seq, ",resuid=%u", sbi->s_resuid);
@@ -1096,7 +1090,6 @@ static const struct export_operations ext4_export_ops = {
 };
 
 enum {
-	Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid,
 	Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_nouid32, Opt_debug, Opt_oldalloc, Opt_orlov,
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
@@ -1114,16 +1107,16 @@ enum {
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard,
+	Opt_discard, Opt_nodiscard, Opt_deprecated,
 };
 
 static const match_table_t tokens = {
-	{Opt_bsd_df, "bsddf"},
-	{Opt_minix_df, "minixdf"},
-	{Opt_grpid, "grpid"},
-	{Opt_grpid, "bsdgroups"},
-	{Opt_nogrpid, "nogrpid"},
-	{Opt_nogrpid, "sysvgroups"},
+	{Opt_deprecated, "bsddf"},
+	{Opt_deprecated, "minixdf"},
+	{Opt_deprecated, "grpid"},
+	{Opt_deprecated, "bsdgroups"},
+	{Opt_deprecated, "nogrpid"},
+	{Opt_deprecated, "sysvgroups"},
 	{Opt_resgid, "resgid=%u"},
 	{Opt_resuid, "resuid=%u"},
 	{Opt_sb, "sb=%u"},
@@ -1188,6 +1181,18 @@ static const match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
+static const match_table_t default_mountopt = {
+	{EXT4_DEFM_DEBUG, "debug"},
+	{EXT4_DEFM_BSDGROUPS, "bsdgroups"},
+	{EXT4_DEFM_XATTR_USER, "user_xattr"},
+	{EXT4_DEFM_ACL, "acl"},
+	{EXT4_DEFM_UID16, "uid16"},
+	{EXT4_DEFM_JMODE_WBACK, "journal_data_writeback"},
+	{EXT4_DEFM_JMODE_DATA, "journal_data"},
+	{EXT4_DEFM_JMODE_ORDERED, "journal_data_ordered"},
+	{0, NULL},
+};
+
 static ext4_fsblk_t get_sb_block(void **data)
 {
 	ext4_fsblk_t	sb_block;
@@ -1238,18 +1243,6 @@ static int parse_options(char *options, struct super_block *sb,
 
 		token = match_token(p, tokens, args);
 		switch (token) {
-		case Opt_bsd_df:
-			clear_opt(sbi->s_mount_opt, MINIX_DF);
-			break;
-		case Opt_minix_df:
-			set_opt(sbi->s_mount_opt, MINIX_DF);
-			break;
-		case Opt_grpid:
-			set_opt(sbi->s_mount_opt, GRPID);
-			break;
-		case Opt_nogrpid:
-			clear_opt(sbi->s_mount_opt, GRPID);
-			break;
 		case Opt_resuid:
 			if (match_int(&args[0], &option))
 				return 0;
@@ -1622,6 +1615,12 @@ set_qf_format:
 		case Opt_dioread_lock:
 			clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
 			break;
+		case Opt_deprecated:
+			ext4_msg(sb, KERN_ERR,
+				"Deprecated mount option \"%s\". "
+				"Please contact linux-ext4@vger.kernel.org if "
+				"you are still using it.", p);
+			return 0;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
@@ -2358,7 +2357,42 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 	}
 	return 1;
 }
+static int handle_deprecated_defmopt(struct super_block *sb, unsigned int opt)
+{
+	int first = 1;
+	/*
+	 * When deprecated options are found they are not cleared from
+	 * super block by default. Just print error message and let
+	 * user clear it manually.
+	 */
+	printk(KERN_ERR "EXT4-fs (%s) Deprecated default mount options:",
+		sb->s_id);
+	/*
+	 * It is impossible to use simple bit traversing because,
+	 * some options use shared bits.
+	 */
+	opt &= EXT4_DEFM_DEPRECATED;
+	while (opt) {
+		const struct match_token *mt = default_mountopt;
+		while (mt->pattern != NULL) {
+			if ((opt & mt->token) == mt->token)
+				break;
+			mt++;
+		}
+		if (mt->pattern == NULL) {
+			printk("%s unknown", !first ? "," : "");
+			break;
+		} else {
+			printk("%s %s", !first ? "," : "", mt->pattern);
+			opt &= ~mt->token;
+		}
+		first = 0;
+	}
+	printk(". Please use tune2fs to disable it, or contact "
+		"linux-ext4@vger.kernel.org if you are still need it.");
 
+	return 1;
+}
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				__releases(kernel_lock)
 				__acquires(kernel_lock)
@@ -2443,10 +2477,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
+	if (def_mount_opts & EXT4_DEFM_DEPRECATED) {
+		if (handle_deprecated_defmopt(sb, def_mount_opts))
+			goto failed_mount;
+	}
 	if (def_mount_opts & EXT4_DEFM_DEBUG)
 		set_opt(sbi->s_mount_opt, DEBUG);
-	if (def_mount_opts & EXT4_DEFM_BSDGROUPS)
-		set_opt(sbi->s_mount_opt, GRPID);
 	if (def_mount_opts & EXT4_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
 #ifdef CONFIG_EXT4_FS_XATTR
@@ -3668,9 +3704,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct ext4_super_block *es = sbi->s_es;
 	u64 fsid;
 
-	if (test_opt(sb, MINIX_DF)) {
-		sbi->s_overhead_last = 0;
-	} else if (sbi->s_blocks_last != ext4_blocks_count(es)) {
+	if (sbi->s_blocks_last != ext4_blocks_count(es)) {
 		ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 		ext4_fsblk_t overhead = 0;
 
-- 
1.6.6


--=-=-=--
