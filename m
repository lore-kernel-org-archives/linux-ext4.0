From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: deprecate obsoleted mount options v2
Date: Tue, 23 Feb 2010 22:23:45 +0300
Message-ID: <87bpffpxha.fsf_-_@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
	<1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
	<E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
	<20100218205218.GL5337@thunk.org> <87d401jnml.fsf_-_@openvz.org>
	<57C5D8FD-F729-4C01-8485-6E76E7D2BDE6@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41225 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0BWTXw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 14:23:52 -0500
In-Reply-To: <57C5D8FD-F729-4C01-8485-6E76E7D2BDE6@sun.com> (Andreas Dilger's
	message of "Mon, 22 Feb 2010 17:28:12 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Andreas Dilger <adilger@sun.com> writes:

> On 2010-02-19, at 07:39, Dmitry Monakhov wrote:
>> This patch deprecate some obsoleted functions.
>> It is not obvious what should we do in case of deprecated options on
>> mount.
>> Just printk and continue or fail the mount, i've implemented the
>> last one.
>> BTW: Do we need similar patch for e2fslib?
>
> I think deprecating an option is not the same as removing it entirely.
Ohh.. I've hoped to reuse freed bits for new crap.
> Even though I don't think these options are in wide usage,  I'd still
> prefer to add a printk() to the parsing code first, leave it  for a
> year, then remove them entirely after that.
So option deprecation result in code boosting instead of code shrinkage.
Indeed the second law of thermodynamics is absolutely true.
New version attached.


--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-deprecate-obsoleted-mount-options-v2.patch

>From 0d12e733a6dd87ed3bc4dea27126f6e814b5586b Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 23 Feb 2010 22:11:47 +0300
Subject: [PATCH] ext4: deprecate obsoleted mount options v2

Declare following list of mount options as deprecated:
 - bsddf, miniddf
 - grpid, bsdgroups, nogrpid, sysvgroups

Declare following list of default mount options as deprecated:
 - bsdgroups

Changes from v1
 - Mark options as deprecated instead of disabling it completely,
   they will be disabled after exportation period.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    2 +
 fs/ext4/super.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 67859fa..66ed482 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1185,6 +1185,8 @@ static inline void ext4_clear_inode_state(struct inode *inode, int bit)
 #define EXT4_DEFM_JMODE_DATA	0x0020
 #define EXT4_DEFM_JMODE_ORDERED	0x0040
 #define EXT4_DEFM_JMODE_WBACK	0x0060
+/* Deprecated default mount options mask */
+#define EXT4_DEFM_DEPRECATED	EXT4_DEFM_BSDGROUPS
 
 /*
  * Default journal batch times
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d5596ca..d07f506 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1114,7 +1114,7 @@ enum {
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard,
+	Opt_discard, Opt_nodiscard, Opt_deprecated, Opt_disabled,
 };
 
 static const match_table_t tokens = {
@@ -1188,6 +1188,18 @@ static const match_table_t tokens = {
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
@@ -1240,16 +1252,16 @@ static int parse_options(char *options, struct super_block *sb,
 		switch (token) {
 		case Opt_bsd_df:
 			clear_opt(sbi->s_mount_opt, MINIX_DF);
-			break;
+			goto deprecated;
 		case Opt_minix_df:
 			set_opt(sbi->s_mount_opt, MINIX_DF);
-			break;
+			goto deprecated;
 		case Opt_grpid:
 			set_opt(sbi->s_mount_opt, GRPID);
-			break;
+			goto deprecated;
 		case Opt_nogrpid:
 			clear_opt(sbi->s_mount_opt, GRPID);
-			break;
+			goto deprecated;
 		case Opt_resuid:
 			if (match_int(&args[0], &option))
 				return 0;
@@ -1622,6 +1634,21 @@ set_qf_format:
 		case Opt_dioread_lock:
 			clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
 			break;
+
+		case Opt_deprecated:
+deprecated:
+			ext4_msg(sb, KERN_ERR,
+				"Deprecated mount option \"%s\". Will be "
+				"removed soon. Please contact "
+				"linux-ext4@vger.kernel.org if you are still "
+				"using it.", p);
+			break;
+
+		case Opt_disabled:
+			ext4_msg(sb, KERN_ERR,
+				"Deprecated mount option \"%s\". And not "
+				"longer supported.", p);
+			return 0;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
@@ -2358,7 +2385,42 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
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
 
+	return 0;
+}
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				__releases(kernel_lock)
 				__acquires(kernel_lock)
@@ -2443,6 +2505,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
+	if (def_mount_opts & EXT4_DEFM_DEPRECATED) {
+		if (handle_deprecated_defmopt(sb, def_mount_opts))
+			goto failed_mount;
+	}
 	if (def_mount_opts & EXT4_DEFM_DEBUG)
 		set_opt(sbi->s_mount_opt, DEBUG);
 	if (def_mount_opts & EXT4_DEFM_BSDGROUPS)
-- 
1.6.6


--=-=-=--
