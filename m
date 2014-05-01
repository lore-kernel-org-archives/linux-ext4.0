From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/5] ext4: enforce ext5 feature set and mount options
Date: Thu, 01 May 2014 16:17:53 -0700
Message-ID: <20140501231753.892.65406.stgit@birch.djwong.org>
References: <20140501231720.892.58712.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29620 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaEAXSA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:18:00 -0400
In-Reply-To: <20140501231720.892.58712.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Having defined "ext5" to be a set of required features and mount
options, check that all the required featues are present and disable
all but a handful of mount options.  See the e2fsprogs part of this
patch for the list of features and mount options that make up ext5.

Again, this is not a fork, just a way to tie some features together
and reduce our testing matrix.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h  |   52 +++++++++++++++++
 fs/ext4/super.c |  173 +++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 176 insertions(+), 49 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fde4a27..a19f826 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1575,6 +1575,58 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_QUOTA)
 
+/* ext5 features */
+#define EXT5_FEATURE_COMPAT_REQD_MASK	(EXT4_FEATURE_COMPAT_RESIZE_INODE|\
+					 EXT4_FEATURE_COMPAT_DIR_INDEX|\
+					 EXT4_FEATURE_COMPAT_EXT_ATTR|\
+					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2)
+
+#define EXT5_FEATURE_COMPAT_REQD	(EXT4_FEATURE_COMPAT_DIR_INDEX|\
+					 EXT4_FEATURE_COMPAT_EXT_ATTR|\
+					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2)
+
+#define EXT5_FEATURE_INCOMPAT_REQD_MASK	(EXT4_FEATURE_INCOMPAT_FILETYPE|\
+					 EXT4_FEATURE_INCOMPAT_META_BG|\
+					 EXT4_FEATURE_INCOMPAT_EXTENTS|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
+
+#define EXT5_FEATURE_INCOMPAT_REQD	(EXT4_FEATURE_INCOMPAT_FILETYPE|\
+					 EXT4_FEATURE_INCOMPAT_META_BG|\
+					 EXT4_FEATURE_INCOMPAT_EXTENTS|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
+
+#define EXT5_FEATURE_RO_COMPAT_REQD_MASK (EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER|\
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+
+#define EXT5_FEATURE_RO_COMPAT_REQD	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER|\
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+
+#define EXT5_DEF_MNTOPT_MASK		(EXT4_DEFM_XATTR_USER|\
+					 EXT4_DEFM_ACL|\
+					 EXT4_DEFM_UID16|\
+					 EXT4_DEFM_NOBARRIER|\
+					 EXT4_DEFM_BLOCK_VALIDITY|\
+					 EXT4_DEFM_NODELALLOC)
+
+#define EXT5_DEF_MNTOPT			(EXT4_DEFM_XATTR_USER|\
+					 EXT4_DEFM_ACL|\
+					 EXT4_DEFM_BLOCK_VALIDITY)
+
+#define EXT5_MINOR_REV_LEVEL		(2)
+
 /*
  * Default values for user and/or group using reserved blocks
  */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32967cb..508e78f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -116,6 +116,17 @@ MODULE_ALIAS("ext3");
 #define IS_EXT3_SB(sb) (0)
 #endif
 
+static struct file_system_type ext5_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "ext5",
+	.mount		= ext4_mount,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+MODULE_ALIAS_FS("ext5");
+MODULE_ALIAS("ext5");
+#define IS_EXT5_SB(sb) ((sb)->s_bdev->bd_holder == &ext5_fs_type)
+
 static int ext4_verify_csum_type(struct super_block *sb,
 				 struct ext4_super_block *es)
 {
@@ -386,6 +397,24 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
  * that error until we've noted it down and cleared it.
  */
 
+static int is_ext5_fs(struct super_block *sb)
+{
+	return (IS_EXT5_SB(sb) ||
+		le16_to_cpu(EXT4_SB(sb)->s_es->s_minor_rev_level) ==
+		EXT5_MINOR_REV_LEVEL);
+}
+
+static int ext4_level(struct super_block *sb)
+{
+	if (IS_EXT2_SB(sb))
+		return 2;
+	if (IS_EXT3_SB(sb))
+		return 3;
+	if (is_ext5_fs(sb))
+		return 5;
+	return 4;
+}
+
 static void ext4_handle_error(struct super_block *sb)
 {
 	if (sb->s_flags & MS_RDONLY)
@@ -408,8 +437,8 @@ static void ext4_handle_error(struct super_block *sb)
 		sb->s_flags |= MS_RDONLY;
 	}
 	if (test_opt(sb, ERRORS_PANIC))
-		panic("EXT4-fs (device %s): panic forced after error\n",
-			sb->s_id);
+		panic("EXT%d-fs (device %s): panic forced after error\n",
+			ext4_level(sb), sb->s_id);
 }
 
 #define ext4_error_ratelimit(sb)					\
@@ -427,8 +456,9 @@ void __ext4_error(struct super_block *sb, const char *function,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 		printk(KERN_CRIT
-		       "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
-		       sb->s_id, function, line, current->comm, &vaf);
+		       "EXT%d-fs error (device %s): %s:%d: comm %s: %pV\n",
+		       ext4_level(sb), sb->s_id, function, line, current->comm,
+		       &vaf);
 		va_end(args);
 	}
 	save_error_info(sb, function, line);
@@ -450,15 +480,17 @@ void __ext4_error_inode(struct inode *inode, const char *function,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 		if (block)
-			printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: "
+			printk(KERN_CRIT "EXT%d-fs error (device %s): %s:%d: "
 			       "inode #%lu: block %llu: comm %s: %pV\n",
-			       inode->i_sb->s_id, function, line, inode->i_ino,
-			       block, current->comm, &vaf);
+			       ext4_level(inode->i_sb), inode->i_sb->s_id,
+			       function, line, inode->i_ino, block,
+			       current->comm, &vaf);
 		else
-			printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: "
+			printk(KERN_CRIT "EXT%d-fs error (device %s): %s:%d: "
 			       "inode #%lu: comm %s: %pV\n",
-			       inode->i_sb->s_id, function, line, inode->i_ino,
-			       current->comm, &vaf);
+			       ext4_level(inode->i_sb), inode->i_sb->s_id,
+			       function, line, inode->i_ino, current->comm,
+			       &vaf);
 		va_end(args);
 	}
 	save_error_info(inode->i_sb, function, line);
@@ -486,16 +518,18 @@ void __ext4_error_file(struct file *file, const char *function,
 		vaf.va = &args;
 		if (block)
 			printk(KERN_CRIT
-			       "EXT4-fs error (device %s): %s:%d: inode #%lu: "
+			       "EXT%d-fs error (device %s): %s:%d: inode #%lu: "
 			       "block %llu: comm %s: path %s: %pV\n",
-			       inode->i_sb->s_id, function, line, inode->i_ino,
-			       block, current->comm, path, &vaf);
+			       ext4_level(inode->i_sb), inode->i_sb->s_id,
+			       function, line, inode->i_ino, block,
+			       current->comm, path, &vaf);
 		else
 			printk(KERN_CRIT
-			       "EXT4-fs error (device %s): %s:%d: inode #%lu: "
+			       "EXT%d-fs error (device %s): %s:%d: inode #%lu: "
 			       "comm %s: path %s: %pV\n",
-			       inode->i_sb->s_id, function, line, inode->i_ino,
-			       current->comm, path, &vaf);
+			       ext4_level(inode->i_sb), inode->i_sb->s_id,
+			       function, line, inode->i_ino, current->comm,
+			       path, &vaf);
 		va_end(args);
 	}
 	save_error_info(inode->i_sb, function, line);
@@ -554,8 +588,8 @@ void __ext4_std_error(struct super_block *sb, const char *function,
 
 	if (ext4_error_ratelimit(sb)) {
 		errstr = ext4_decode_error(sb, errno, nbuf);
-		printk(KERN_CRIT "EXT4-fs error (device %s) in %s:%d: %s\n",
-		       sb->s_id, function, line, errstr);
+		printk(KERN_CRIT "EXT%d-fs error (device %s) in %s:%d: %s\n",
+		       ext4_level(sb), sb->s_id, function, line, errstr);
 	}
 
 	save_error_info(sb, function, line);
@@ -579,8 +613,8 @@ void __ext4_abort(struct super_block *sb, const char *function,
 
 	save_error_info(sb, function, line);
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: ", sb->s_id,
-	       function, line);
+	printk(KERN_CRIT "EXT%d-fs error (device %s): %s:%d: ",
+	       ext4_level(sb), sb->s_id, function, line);
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
@@ -599,7 +633,7 @@ void __ext4_abort(struct super_block *sb, const char *function,
 		save_error_info(sb, function, line);
 	}
 	if (test_opt(sb, ERRORS_PANIC))
-		panic("EXT4-fs panic from previous error\n");
+		panic("EXT%d-fs panic from previous error\n", ext4_level(sb));
 }
 
 void __ext4_msg(struct super_block *sb,
@@ -614,7 +648,8 @@ void __ext4_msg(struct super_block *sb,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk("%sEXT4-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
+	printk("%sEXT%d-fs (%s): %pV\n", prefix, ext4_level(sb), sb->s_id,
+	       &vaf);
 	va_end(args);
 }
 
@@ -631,8 +666,8 @@ void __ext4_warning(struct super_block *sb, const char *function,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_WARNING "EXT4-fs warning (device %s): %s:%d: %pV\n",
-	       sb->s_id, function, line, &vaf);
+	printk(KERN_WARNING "EXT%d-fs warning (device %s): %s:%d: %pV\n",
+	       ext4_level(sb), sb->s_id, function, line, &vaf);
 	va_end(args);
 }
 
@@ -655,8 +690,8 @@ __acquires(bitlock)
 		va_start(args, fmt);
 		vaf.fmt = fmt;
 		vaf.va = &args;
-		printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u, ",
-		       sb->s_id, function, line, grp);
+		printk(KERN_CRIT "EXT%d-fs error (device %s): %s:%d: group %u, ",
+		       ext4_level(sb), sb->s_id, function, line, grp);
 		if (ino)
 			printk(KERN_CONT "inode %lu: ", ino);
 		if (block)
@@ -1360,6 +1395,7 @@ static int clear_qf_name(struct super_block *sb, int qtype)
 #define MOPT_NO_EXT3	0x0200
 #define MOPT_EXT4_ONLY	(MOPT_NO_EXT2 | MOPT_NO_EXT3)
 #define MOPT_STRING	0x0400
+#define MOPT_EXT5_OPT	0x0800
 
 static const struct mount_opts {
 	int	token;
@@ -1370,27 +1406,27 @@ static const struct mount_opts {
 	{Opt_bsd_df, EXT4_MOUNT_MINIX_DF, MOPT_CLEAR},
 	{Opt_grpid, EXT4_MOUNT_GRPID, MOPT_SET},
 	{Opt_nogrpid, EXT4_MOUNT_GRPID, MOPT_CLEAR},
-	{Opt_block_validity, EXT4_MOUNT_BLOCK_VALIDITY, MOPT_SET},
+	{Opt_block_validity, EXT4_MOUNT_BLOCK_VALIDITY, MOPT_EXT5_OPT | MOPT_SET},
 	{Opt_noblock_validity, EXT4_MOUNT_BLOCK_VALIDITY, MOPT_CLEAR},
 	{Opt_dioread_nolock, EXT4_MOUNT_DIOREAD_NOLOCK,
 	 MOPT_EXT4_ONLY | MOPT_SET},
 	{Opt_dioread_lock, EXT4_MOUNT_DIOREAD_NOLOCK,
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
-	{Opt_discard, EXT4_MOUNT_DISCARD, MOPT_SET},
-	{Opt_nodiscard, EXT4_MOUNT_DISCARD, MOPT_CLEAR},
+	{Opt_discard, EXT4_MOUNT_DISCARD, MOPT_EXT5_OPT | MOPT_SET},
+	{Opt_nodiscard, EXT4_MOUNT_DISCARD, MOPT_EXT5_OPT | MOPT_CLEAR},
 	{Opt_delalloc, EXT4_MOUNT_DELALLOC,
 	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
 	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC,
 	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
-	 MOPT_EXT4_ONLY | MOPT_SET},
+	 MOPT_EXT5_OPT | MOPT_EXT4_ONLY | MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
 				    EXT4_MOUNT_JOURNAL_CHECKSUM),
 	 MOPT_EXT4_ONLY | MOPT_SET},
 	{Opt_noload, EXT4_MOUNT_NOLOAD, MOPT_NO_EXT2 | MOPT_SET},
-	{Opt_err_panic, EXT4_MOUNT_ERRORS_PANIC, MOPT_SET | MOPT_CLEAR_ERR},
-	{Opt_err_ro, EXT4_MOUNT_ERRORS_RO, MOPT_SET | MOPT_CLEAR_ERR},
-	{Opt_err_cont, EXT4_MOUNT_ERRORS_CONT, MOPT_SET | MOPT_CLEAR_ERR},
+	{Opt_err_panic, EXT4_MOUNT_ERRORS_PANIC, MOPT_EXT5_OPT | MOPT_SET | MOPT_CLEAR_ERR},
+	{Opt_err_ro, EXT4_MOUNT_ERRORS_RO, MOPT_EXT5_OPT | MOPT_SET | MOPT_CLEAR_ERR},
+	{Opt_err_cont, EXT4_MOUNT_ERRORS_CONT, MOPT_EXT5_OPT | MOPT_SET | MOPT_CLEAR_ERR},
 	{Opt_data_err_abort, EXT4_MOUNT_DATA_ERR_ABORT,
 	 MOPT_NO_EXT2 | MOPT_SET},
 	{Opt_data_err_ignore, EXT4_MOUNT_DATA_ERR_ABORT,
@@ -1408,24 +1444,24 @@ static const struct mount_opts {
 	{Opt_stripe, 0, MOPT_GTE0},
 	{Opt_resuid, 0, MOPT_GTE0},
 	{Opt_resgid, 0, MOPT_GTE0},
-	{Opt_journal_dev, 0, MOPT_GTE0},
-	{Opt_journal_path, 0, MOPT_STRING},
+	{Opt_journal_dev, 0, MOPT_EXT5_OPT | MOPT_GTE0},
+	{Opt_journal_path, 0, MOPT_EXT5_OPT | MOPT_STRING},
 	{Opt_journal_ioprio, 0, MOPT_GTE0},
-	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
-	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
+	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_EXT5_OPT | MOPT_NO_EXT2 | MOPT_DATAJ},
+	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_EXT5_OPT | MOPT_NO_EXT2 | MOPT_DATAJ},
 	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA,
-	 MOPT_NO_EXT2 | MOPT_DATAJ},
-	{Opt_user_xattr, EXT4_MOUNT_XATTR_USER, MOPT_SET},
+	 MOPT_EXT5_OPT | MOPT_NO_EXT2 | MOPT_DATAJ},
+	{Opt_user_xattr, EXT4_MOUNT_XATTR_USER, MOPT_EXT5_OPT | MOPT_SET},
 	{Opt_nouser_xattr, EXT4_MOUNT_XATTR_USER, MOPT_CLEAR},
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
-	{Opt_acl, EXT4_MOUNT_POSIX_ACL, MOPT_SET},
+	{Opt_acl, EXT4_MOUNT_POSIX_ACL, MOPT_EXT5_OPT | MOPT_SET},
 	{Opt_noacl, EXT4_MOUNT_POSIX_ACL, MOPT_CLEAR},
 #else
 	{Opt_acl, 0, MOPT_NOSUPPORT},
 	{Opt_noacl, 0, MOPT_NOSUPPORT},
 #endif
 	{Opt_nouid32, EXT4_MOUNT_NO_UID32, MOPT_SET},
-	{Opt_debug, EXT4_MOUNT_DEBUG, MOPT_SET},
+	{Opt_debug, EXT4_MOUNT_DEBUG, MOPT_EXT5_OPT | MOPT_SET},
 	{Opt_quota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA, MOPT_SET | MOPT_Q},
 	{Opt_usrquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA,
 							MOPT_SET | MOPT_Q},
@@ -1502,6 +1538,11 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			 "Mount option \"%s\" incompatible with ext3", opt);
 		return -1;
 	}
+	if (!(m->flags & MOPT_EXT5_OPT) && is_ext5_fs(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Mount option \"%s\" incompatible with ext5", opt);
+		return -1;
+	}
 
 	if (args->from && !(m->flags & MOPT_STRING) && match_int(args, &arg))
 		return -1;
@@ -1532,7 +1573,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (token == Opt_inode_readahead_blks) {
 		if (arg && (arg > (1 << 30) || !is_power_of_2(arg))) {
 			ext4_msg(sb, KERN_ERR,
-				 "EXT4-fs: inode_readahead_blks must be "
+				 "inode_readahead_blks must be "
 				 "0 or a power of 2 smaller than 2^31");
 			return -1;
 		}
@@ -2811,8 +2852,9 @@ static void print_daily_error_info(unsigned long arg)
 		ext4_msg(sb, KERN_NOTICE, "error count: %u",
 			 le32_to_cpu(es->s_error_count));
 	if (es->s_first_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): initial error at %u: %.*s:%d",
-		       sb->s_id, le32_to_cpu(es->s_first_error_time),
+		printk(KERN_NOTICE "EXT%d-fs (%s): initial error at %u: %.*s:%d",
+		       ext4_level(sb), sb->s_id,
+		       le32_to_cpu(es->s_first_error_time),
 		       (int) sizeof(es->s_first_error_func),
 		       es->s_first_error_func,
 		       le32_to_cpu(es->s_first_error_line));
@@ -2825,8 +2867,9 @@ static void print_daily_error_info(unsigned long arg)
 		printk("\n");
 	}
 	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: %.*s:%d",
-		       sb->s_id, le32_to_cpu(es->s_last_error_time),
+		printk(KERN_NOTICE "EXT%d-fs (%s): last error at %u: %.*s:%d",
+		       ext4_level(sb), sb->s_id,
+		       le32_to_cpu(es->s_last_error_time),
 		       (int) sizeof(es->s_last_error_func),
 		       es->s_last_error_func,
 		       le32_to_cpu(es->s_last_error_line));
@@ -3495,6 +3538,31 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sbi->s_csum_seed = ext4_chksum(sbi, ~0, es->s_uuid,
 					       sizeof(es->s_uuid));
 
+	/* check ext5 features and mount options */
+	if (IS_EXT5_SB(sb) &&
+	    le16_to_cpu(es->s_minor_rev_level) != EXT5_MINOR_REV_LEVEL) {
+		ext4_msg(sb, KERN_ERR, "VFS: Trying to mount non-ext5 "
+			 "filesystem as ext5?");
+		goto failed_mount;
+	}
+
+	if ((le16_to_cpu(es->s_minor_rev_level) == EXT5_MINOR_REV_LEVEL) &&
+	    ((le32_to_cpu(es->s_feature_incompat) &
+	      EXT5_FEATURE_INCOMPAT_REQD_MASK) != EXT5_FEATURE_INCOMPAT_REQD ||
+	     (le32_to_cpu(es->s_feature_ro_compat) &
+	      EXT5_FEATURE_RO_COMPAT_REQD_MASK) != EXT5_FEATURE_RO_COMPAT_REQD ||
+	     (le32_to_cpu(es->s_feature_compat) &
+	      EXT5_FEATURE_COMPAT_REQD_MASK) != EXT5_FEATURE_COMPAT_REQD ||
+	     (le32_to_cpu(es->s_default_mount_opts) &
+	      EXT5_DEF_MNTOPT_MASK) != EXT5_DEF_MNTOPT)) {
+		ext4_msg(sb, KERN_ERR, "VFS: Found ext5 filesystem with "
+			 "missing features.  Run e2fsck?");
+		goto failed_mount;
+	}
+
+	if (is_ext5_fs(sb))
+		set_opt(sb, JOURNAL_CHECKSUM);
+
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	set_opt(sb, INIT_INODE_TABLE);
@@ -3562,9 +3630,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
+		printk_once(KERN_WARNING "EXT%d-fs: Warning: mounting "
 			    "with data=journal disables delayed "
-			    "allocation and O_DIRECT support!\n");
+			    "allocation and O_DIRECT support!\n",
+			    ext4_level(sb));
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "both data=journal and delalloc");
@@ -4073,7 +4142,8 @@ no_journal:
 	EXT4_SB(sb)->rsv_conversion_wq =
 		alloc_workqueue("ext4-rsv-conversion", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
 	if (!EXT4_SB(sb)->rsv_conversion_wq) {
-		printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
+		printk(KERN_ERR "EXT%d-fs: failed to create workqueue\n",
+		       ext4_level(sb));
 		ret = -ENOMEM;
 		goto failed_mount4;
 	}
@@ -5563,6 +5633,9 @@ static int __init ext4_init_fs(void)
 		goto out1;
 	register_as_ext3();
 	register_as_ext2();
+	err = register_filesystem(&ext5_fs_type);
+	if (err)
+		goto out;
 	err = register_filesystem(&ext4_fs_type);
 	if (err)
 		goto out;
@@ -5571,6 +5644,7 @@ static int __init ext4_init_fs(void)
 out:
 	unregister_as_ext2();
 	unregister_as_ext3();
+	unregister_filesystem(&ext4_fs_type);
 	destroy_inodecache();
 out1:
 	ext4_mballoc_ready = 0;
@@ -5597,6 +5671,7 @@ static void __exit ext4_exit_fs(void)
 	unregister_as_ext2();
 	unregister_as_ext3();
 	unregister_filesystem(&ext4_fs_type);
+	unregister_filesystem(&ext5_fs_type);
 	destroy_inodecache();
 	ext4_exit_mballoc();
 	ext4_exit_feat_adverts();

