From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext2: Parse mount options into a dedicated structure
Date: Mon,  9 Oct 2017 17:00:41 +0200
Message-ID: <20171009150042.31293-2-jack@suse.cz>
References: <20171009150042.31293-1-jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jia-Ju Bai <baijiaju1990@163.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47461 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754622AbdJIPAw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 9 Oct 2017 11:00:52 -0400
In-Reply-To: <20171009150042.31293-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of parsing mount options directly into the superblock (and
restoring options in case of error), parse the options into a dedicated
structure and only copy everything when we know we can safely switch
options. This will allow us to simplify locking and do option parsing
without holding sb->s_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c | 157 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 76 insertions(+), 81 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1458706bd2ec..05eae20d133f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -479,10 +479,10 @@ static const match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
-static int parse_options(char *options, struct super_block *sb)
+static int parse_options(char *options, struct super_block *sb,
+			 struct ext2_mount_options *opts)
 {
 	char *p;
-	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 	kuid_t uid;
@@ -499,16 +499,16 @@ static int parse_options(char *options, struct super_block *sb)
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
-			clear_opt (sbi->s_mount_opt, MINIX_DF);
+			clear_opt (opts->s_mount_opt, MINIX_DF);
 			break;
 		case Opt_minix_df:
-			set_opt (sbi->s_mount_opt, MINIX_DF);
+			set_opt (opts->s_mount_opt, MINIX_DF);
 			break;
 		case Opt_grpid:
-			set_opt (sbi->s_mount_opt, GRPID);
+			set_opt (opts->s_mount_opt, GRPID);
 			break;
 		case Opt_nogrpid:
-			clear_opt (sbi->s_mount_opt, GRPID);
+			clear_opt (opts->s_mount_opt, GRPID);
 			break;
 		case Opt_resuid:
 			if (match_int(&args[0], &option))
@@ -519,7 +519,7 @@ static int parse_options(char *options, struct super_block *sb)
 				return 0;
 
 			}
-			sbi->s_resuid = uid;
+			opts->s_resuid = uid;
 			break;
 		case Opt_resgid:
 			if (match_int(&args[0], &option))
@@ -529,51 +529,51 @@ static int parse_options(char *options, struct super_block *sb)
 				ext2_msg(sb, KERN_ERR, "Invalid gid value %d", option);
 				return 0;
 			}
-			sbi->s_resgid = gid;
+			opts->s_resgid = gid;
 			break;
 		case Opt_sb:
 			/* handled by get_sb_block() instead of here */
 			/* *sb_block = match_int(&args[0]); */
 			break;
 		case Opt_err_panic:
-			clear_opt (sbi->s_mount_opt, ERRORS_CONT);
-			clear_opt (sbi->s_mount_opt, ERRORS_RO);
-			set_opt (sbi->s_mount_opt, ERRORS_PANIC);
+			clear_opt (opts->s_mount_opt, ERRORS_CONT);
+			clear_opt (opts->s_mount_opt, ERRORS_RO);
+			set_opt (opts->s_mount_opt, ERRORS_PANIC);
 			break;
 		case Opt_err_ro:
-			clear_opt (sbi->s_mount_opt, ERRORS_CONT);
-			clear_opt (sbi->s_mount_opt, ERRORS_PANIC);
-			set_opt (sbi->s_mount_opt, ERRORS_RO);
+			clear_opt (opts->s_mount_opt, ERRORS_CONT);
+			clear_opt (opts->s_mount_opt, ERRORS_PANIC);
+			set_opt (opts->s_mount_opt, ERRORS_RO);
 			break;
 		case Opt_err_cont:
-			clear_opt (sbi->s_mount_opt, ERRORS_RO);
-			clear_opt (sbi->s_mount_opt, ERRORS_PANIC);
-			set_opt (sbi->s_mount_opt, ERRORS_CONT);
+			clear_opt (opts->s_mount_opt, ERRORS_RO);
+			clear_opt (opts->s_mount_opt, ERRORS_PANIC);
+			set_opt (opts->s_mount_opt, ERRORS_CONT);
 			break;
 		case Opt_nouid32:
-			set_opt (sbi->s_mount_opt, NO_UID32);
+			set_opt (opts->s_mount_opt, NO_UID32);
 			break;
 		case Opt_nocheck:
-			clear_opt (sbi->s_mount_opt, CHECK);
+			clear_opt (opts->s_mount_opt, CHECK);
 			break;
 		case Opt_debug:
-			set_opt (sbi->s_mount_opt, DEBUG);
+			set_opt (opts->s_mount_opt, DEBUG);
 			break;
 		case Opt_oldalloc:
-			set_opt (sbi->s_mount_opt, OLDALLOC);
+			set_opt (opts->s_mount_opt, OLDALLOC);
 			break;
 		case Opt_orlov:
-			clear_opt (sbi->s_mount_opt, OLDALLOC);
+			clear_opt (opts->s_mount_opt, OLDALLOC);
 			break;
 		case Opt_nobh:
-			set_opt (sbi->s_mount_opt, NOBH);
+			set_opt (opts->s_mount_opt, NOBH);
 			break;
 #ifdef CONFIG_EXT2_FS_XATTR
 		case Opt_user_xattr:
-			set_opt (sbi->s_mount_opt, XATTR_USER);
+			set_opt (opts->s_mount_opt, XATTR_USER);
 			break;
 		case Opt_nouser_xattr:
-			clear_opt (sbi->s_mount_opt, XATTR_USER);
+			clear_opt (opts->s_mount_opt, XATTR_USER);
 			break;
 #else
 		case Opt_user_xattr:
@@ -584,10 +584,10 @@ static int parse_options(char *options, struct super_block *sb)
 #endif
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 		case Opt_acl:
-			set_opt(sbi->s_mount_opt, POSIX_ACL);
+			set_opt(opts->s_mount_opt, POSIX_ACL);
 			break;
 		case Opt_noacl:
-			clear_opt(sbi->s_mount_opt, POSIX_ACL);
+			clear_opt(opts->s_mount_opt, POSIX_ACL);
 			break;
 #else
 		case Opt_acl:
@@ -598,13 +598,13 @@ static int parse_options(char *options, struct super_block *sb)
 #endif
 		case Opt_xip:
 			ext2_msg(sb, KERN_INFO, "use dax instead of xip");
-			set_opt(sbi->s_mount_opt, XIP);
+			set_opt(opts->s_mount_opt, XIP);
 			/* Fall through */
 		case Opt_dax:
 #ifdef CONFIG_FS_DAX
 			ext2_msg(sb, KERN_WARNING,
 		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
-			set_opt(sbi->s_mount_opt, DAX);
+			set_opt(opts->s_mount_opt, DAX);
 #else
 			ext2_msg(sb, KERN_INFO, "dax option not supported");
 #endif
@@ -613,11 +613,11 @@ static int parse_options(char *options, struct super_block *sb)
 #if defined(CONFIG_QUOTA)
 		case Opt_quota:
 		case Opt_usrquota:
-			set_opt(sbi->s_mount_opt, USRQUOTA);
+			set_opt(opts->s_mount_opt, USRQUOTA);
 			break;
 
 		case Opt_grpquota:
-			set_opt(sbi->s_mount_opt, GRPQUOTA);
+			set_opt(opts->s_mount_opt, GRPQUOTA);
 			break;
 #else
 		case Opt_quota:
@@ -629,11 +629,11 @@ static int parse_options(char *options, struct super_block *sb)
 #endif
 
 		case Opt_reservation:
-			set_opt(sbi->s_mount_opt, RESERVATION);
+			set_opt(opts->s_mount_opt, RESERVATION);
 			ext2_msg(sb, KERN_INFO, "reservations ON");
 			break;
 		case Opt_noreservation:
-			clear_opt(sbi->s_mount_opt, RESERVATION);
+			clear_opt(opts->s_mount_opt, RESERVATION);
 			ext2_msg(sb, KERN_INFO, "reservations OFF");
 			break;
 		case Opt_ignore:
@@ -830,6 +830,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	int i, j;
 	__le32 features;
 	int err;
+	struct ext2_mount_options opts;
 
 	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
@@ -890,35 +891,39 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	if (def_mount_opts & EXT2_DEFM_DEBUG)
-		set_opt(sbi->s_mount_opt, DEBUG);
+		set_opt(opts.s_mount_opt, DEBUG);
 	if (def_mount_opts & EXT2_DEFM_BSDGROUPS)
-		set_opt(sbi->s_mount_opt, GRPID);
+		set_opt(opts.s_mount_opt, GRPID);
 	if (def_mount_opts & EXT2_DEFM_UID16)
-		set_opt(sbi->s_mount_opt, NO_UID32);
+		set_opt(opts.s_mount_opt, NO_UID32);
 #ifdef CONFIG_EXT2_FS_XATTR
 	if (def_mount_opts & EXT2_DEFM_XATTR_USER)
-		set_opt(sbi->s_mount_opt, XATTR_USER);
+		set_opt(opts.s_mount_opt, XATTR_USER);
 #endif
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 	if (def_mount_opts & EXT2_DEFM_ACL)
-		set_opt(sbi->s_mount_opt, POSIX_ACL);
+		set_opt(opts.s_mount_opt, POSIX_ACL);
 #endif
 	
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_PANIC)
-		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
+		set_opt(opts.s_mount_opt, ERRORS_PANIC);
 	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_CONTINUE)
-		set_opt(sbi->s_mount_opt, ERRORS_CONT);
+		set_opt(opts.s_mount_opt, ERRORS_CONT);
 	else
-		set_opt(sbi->s_mount_opt, ERRORS_RO);
+		set_opt(opts.s_mount_opt, ERRORS_RO);
 
-	sbi->s_resuid = make_kuid(&init_user_ns, le16_to_cpu(es->s_def_resuid));
-	sbi->s_resgid = make_kgid(&init_user_ns, le16_to_cpu(es->s_def_resgid));
+	opts.s_resuid = make_kuid(&init_user_ns, le16_to_cpu(es->s_def_resuid));
+	opts.s_resgid = make_kgid(&init_user_ns, le16_to_cpu(es->s_def_resgid));
 	
-	set_opt(sbi->s_mount_opt, RESERVATION);
+	set_opt(opts.s_mount_opt, RESERVATION);
 
-	if (!parse_options((char *) data, sb))
+	if (!parse_options((char *) data, sb, &opts))
 		goto failed_mount;
 
+	sbi->s_mount_opt = opts.s_mount_opt;
+	sbi->s_resuid = opts.s_resuid;
+	sbi->s_resgid = opts.s_resgid;
+
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((EXT2_SB(sb)->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ?
 		 MS_POSIXACL : 0);
@@ -1312,46 +1317,36 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 {
 	struct ext2_sb_info * sbi = EXT2_SB(sb);
 	struct ext2_super_block * es;
-	struct ext2_mount_options old_opts;
-	unsigned long old_sb_flags;
+	struct ext2_mount_options new_opts;
 	int err;
 
 	sync_filesystem(sb);
 	spin_lock(&sbi->s_lock);
 
-	/* Store the old options */
-	old_sb_flags = sb->s_flags;
-	old_opts.s_mount_opt = sbi->s_mount_opt;
-	old_opts.s_resuid = sbi->s_resuid;
-	old_opts.s_resgid = sbi->s_resgid;
+	new_opts.s_mount_opt = sbi->s_mount_opt;
+	new_opts.s_resuid = sbi->s_resuid;
+	new_opts.s_resgid = sbi->s_resgid;
 
 	/*
 	 * Allow the "check" option to be passed as a remount option.
 	 */
-	if (!parse_options(data, sb)) {
-		err = -EINVAL;
-		goto restore_opts;
+	if (!parse_options(data, sb, &new_opts)) {
+		spin_unlock(&sbi->s_lock);
+		return -EINVAL;
 	}
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
-
 	es = sbi->s_es;
-	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT2_MOUNT_DAX) {
+	if ((sbi->s_mount_opt ^ new_opts.s_mount_opt) & EXT2_MOUNT_DAX) {
 		ext2_msg(sb, KERN_WARNING, "warning: refusing change of "
 			 "dax flag with busy inodes while remounting");
-		sbi->s_mount_opt ^= EXT2_MOUNT_DAX;
-	}
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb)) {
-		spin_unlock(&sbi->s_lock);
-		return 0;
+		new_opts.s_mount_opt ^= EXT2_MOUNT_DAX;
 	}
+	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
+		goto out_set;
 	if (*flags & MS_RDONLY) {
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
-		    !(sbi->s_mount_state & EXT2_VALID_FS)) {
-			spin_unlock(&sbi->s_lock);
-			return 0;
-		}
+		    !(sbi->s_mount_state & EXT2_VALID_FS))
+			goto out_set;
 
 		/*
 		 * OK, we are remounting a valid rw partition rdonly, so set
@@ -1362,22 +1357,20 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		spin_unlock(&sbi->s_lock);
 
 		err = dquot_suspend(sb, -1);
-		if (err < 0) {
-			spin_lock(&sbi->s_lock);
-			goto restore_opts;
-		}
+		if (err < 0)
+			return err;
 
 		ext2_sync_super(sb, es, 1);
 	} else {
 		__le32 ret = EXT2_HAS_RO_COMPAT_FEATURE(sb,
 					       ~EXT2_FEATURE_RO_COMPAT_SUPP);
 		if (ret) {
+			spin_unlock(&sbi->s_lock);
 			ext2_msg(sb, KERN_WARNING,
 				"warning: couldn't remount RDWR because of "
 				"unsupported optional features (%x).",
 				le32_to_cpu(ret));
-			err = -EROFS;
-			goto restore_opts;
+			return -EROFS;
 		}
 		/*
 		 * Mounting a RDONLY partition read-write, so reread and
@@ -1394,14 +1387,16 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		dquot_resume(sb, -1);
 	}
 
-	return 0;
-restore_opts:
-	sbi->s_mount_opt = old_opts.s_mount_opt;
-	sbi->s_resuid = old_opts.s_resuid;
-	sbi->s_resgid = old_opts.s_resgid;
-	sb->s_flags = old_sb_flags;
+	spin_lock(&sbi->s_lock);
+out_set:
+	sbi->s_mount_opt = new_opts.s_mount_opt;
+	sbi->s_resuid = new_opts.s_resuid;
+	sbi->s_resgid = new_opts.s_resgid;
+	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+		((sbi->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 	spin_unlock(&sbi->s_lock);
-	return err;
+
+	return 0;
 }
 
 static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
-- 
2.12.3
