From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: Change all super.c messages to print the device
Date: Wed, 20 May 2009 16:32:01 -0500
Message-ID: <4A1476D1.9080206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56280 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbZETVcE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 17:32:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Do the same for ext4 as Andi did for ext3:

"This patch changes ext4 super.c to include the device name with all 
warning/error messages, by using a new utility function ext4_msg. 
It's a rather large patch, but very mechanic. I left debug printks
alone."

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/ext4.h
===================================================================
--- linux-2.6.orig/fs/ext4/ext4.h
+++ linux-2.6/fs/ext4/ext4.h
@@ -1123,6 +1123,8 @@ extern void ext4_abort(struct super_bloc
 	__attribute__ ((format (printf, 3, 4)));
 extern void ext4_warning(struct super_block *, const char *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
+extern void ext4_msg(struct super_block *, const char *, const char *, ...)
+	__attribute__ ((format (printf, 3, 4)));
 extern void ext4_grp_locked_error(struct super_block *, ext4_group_t,
 				const char *, const char *, ...)
 	__attribute__ ((format (printf, 4, 5)));
Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c
+++ linux-2.6/fs/ext4/super.c
@@ -302,7 +302,7 @@ static void ext4_handle_error(struct sup
 			jbd2_journal_abort(journal, -EIO);
 	}
 	if (test_opt(sb, ERRORS_RO)) {
-		printk(KERN_CRIT "Remounting filesystem read-only\n");
+		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		sb->s_flags |= MS_RDONLY;
 	}
 	ext4_commit_super(sb, es, 1);
@@ -395,8 +395,6 @@ void ext4_abort(struct super_block *sb, 
 {
 	va_list args;
 
-	printk(KERN_CRIT "ext4_abort called.\n");
-
 	va_start(args, fmt);
 	printk(KERN_CRIT "EXT4-fs error (device %s): %s: ", sb->s_id, function);
 	vprintk(fmt, args);
@@ -409,7 +407,7 @@ void ext4_abort(struct super_block *sb, 
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
-	printk(KERN_CRIT "Remounting filesystem read-only\n");
+	ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 	sb->s_flags |= MS_RDONLY;
 	EXT4_SB(sb)->s_mount_opt |= EXT4_MOUNT_ABORT;
@@ -417,6 +415,18 @@ void ext4_abort(struct super_block *sb, 
 		jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 }
 
+void ext4_msg (struct super_block * sb, const char *prefix,
+		   const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	printk("%sEXT4-fs (%s): ", prefix, sb->s_id);
+	vprintk(fmt, args);
+	printk("\n");
+	va_end(args);
+}
+
 void ext4_warning(struct super_block *sb, const char *function,
 		  const char *fmt, ...)
 {
@@ -496,7 +506,7 @@ void ext4_update_dynamic_rev(struct supe
 /*
  * Open the external journal device
  */
-static struct block_device *ext4_blkdev_get(dev_t dev)
+static struct block_device *ext4_blkdev_get(dev_t dev, struct super_block *sb)
 {
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];
@@ -507,7 +517,7 @@ static struct block_device *ext4_blkdev_
 	return bdev;
 
 fail:
-	printk(KERN_ERR "EXT4-fs: failed to open journal device %s: %ld\n",
+	ext4_msg(sb, KERN_ERR, "failed to open journal device %s: %ld",
 			__bdevname(dev, b), PTR_ERR(bdev));
 	return NULL;
 }
@@ -1206,8 +1216,7 @@ static int parse_options(char *options, 
 #else
 		case Opt_user_xattr:
 		case Opt_nouser_xattr:
-			printk(KERN_ERR "EXT4 (no)user_xattr options "
-			       "not supported\n");
+			ext4_msg(sb, KERN_ERR, "(no)user_xattr options not supported");
 			break;
 #endif
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
@@ -1220,8 +1229,7 @@ static int parse_options(char *options, 
 #else
 		case Opt_acl:
 		case Opt_noacl:
-			printk(KERN_ERR "EXT4 (no)acl options "
-			       "not supported\n");
+			ext4_msg(sb, KERN_ERR, "(no)acl options not supported");
 			break;
 #endif
 		case Opt_journal_update:
@@ -1231,16 +1239,16 @@ static int parse_options(char *options, 
 			   user to specify an existing inode to be the
 			   journal file. */
 			if (is_remount) {
-				printk(KERN_ERR "EXT4-fs: cannot specify "
-				       "journal on remount\n");
+				ext4_msg(sb, KERN_ERR,
+					 "Cannot specify journal on remount");
 				return 0;
 			}
 			set_opt(sbi->s_mount_opt, UPDATE_JOURNAL);
 			break;
 		case Opt_journal_dev:
 			if (is_remount) {
-				printk(KERN_ERR "EXT4-fs: cannot specify "
-				       "journal on remount\n");
+				ext4_msg(sb, KERN_ERR,
+					"Cannot specify journal on remount");
 				return 0;
 			}
 			if (match_int(&args[0], &option))
@@ -1294,9 +1302,8 @@ static int parse_options(char *options, 
 			if (is_remount) {
 				if ((sbi->s_mount_opt & EXT4_MOUNT_DATA_FLAGS)
 						!= data_opt) {
-					printk(KERN_ERR
-						"EXT4-fs: cannot change data "
-						"mode on remount\n");
+					ext4_msg(sb, KERN_ERR,
+						"Cannot change data mode on remount");
 					return 0;
 				}
 			} else {
@@ -1319,31 +1326,31 @@ static int parse_options(char *options, 
 set_qf_name:
 			if (sb_any_quota_loaded(sb) &&
 			    !sbi->s_qf_names[qtype]) {
-				printk(KERN_ERR
-				       "EXT4-fs: Cannot change journaled "
-				       "quota options when quota turned on.\n");
+				ext4_msg(sb, KERN_ERR,
+				       "Cannot change journaled "
+				       "quota options when quota turned on");
 				return 0;
 			}
 			qname = match_strdup(&args[0]);
 			if (!qname) {
-				printk(KERN_ERR
-					"EXT4-fs: not enough memory for "
-					"storing quotafile name.\n");
+				ext4_msg(sb, KERN_ERR,
+					"Not enough memory for "
+					"storing quotafile name");
 				return 0;
 			}
 			if (sbi->s_qf_names[qtype] &&
 			    strcmp(sbi->s_qf_names[qtype], qname)) {
-				printk(KERN_ERR
-					"EXT4-fs: %s quota file already "
-					"specified.\n", QTYPE2NAME(qtype));
+				ext4_msg(sb, KERN_ERR,
+					"%s quota file already "
+					"specified", QTYPE2NAME(qtype));
 				kfree(qname);
 				return 0;
 			}
 			sbi->s_qf_names[qtype] = qname;
 			if (strchr(sbi->s_qf_names[qtype], '/')) {
-				printk(KERN_ERR
-					"EXT4-fs: quotafile must be on "
-					"filesystem root.\n");
+				ext4_msg(sb, KERN_ERR,
+					"quotafile must be on "
+					"filesystem root");
 				kfree(sbi->s_qf_names[qtype]);
 				sbi->s_qf_names[qtype] = NULL;
 				return 0;
@@ -1358,9 +1365,9 @@ set_qf_name:
 clear_qf_name:
 			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_qf_names[qtype]) {
-				printk(KERN_ERR "EXT4-fs: Cannot change "
+				ext4_msg(sb, KERN_ERR, "Cannot change "
 					"journaled quota options when "
-					"quota turned on.\n");
+					"quota turned on");
 				return 0;
 			}
 			/*
@@ -1377,9 +1384,9 @@ clear_qf_name:
 set_qf_format:
 			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
-				printk(KERN_ERR "EXT4-fs: Cannot change "
+				ext4_msg(sb, KERN_ERR, "Cannot change "
 					"journaled quota options when "
-					"quota turned on.\n");
+					"quota turned on");
 				return 0;
 			}
 			sbi->s_jquota_fmt = qfmt;
@@ -1395,8 +1402,8 @@ set_qf_format:
 			break;
 		case Opt_noquota:
 			if (sb_any_quota_loaded(sb)) {
-				printk(KERN_ERR "EXT4-fs: Cannot change quota "
-					"options when quota turned on.\n");
+				ext4_msg(sb, KERN_ERR, "Cannot change quota "
+					"options when quota turned on");
 				return 0;
 			}
 			clear_opt(sbi->s_mount_opt, QUOTA);
@@ -1407,8 +1414,8 @@ set_qf_format:
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
-			printk(KERN_ERR
-				"EXT4-fs: quota options not supported.\n");
+			ext4_msg(sb, KERN_ERR,
+				"quota options not supported");
 			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
@@ -1416,9 +1423,8 @@ set_qf_format:
 		case Opt_offgrpjquota:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
-			printk(KERN_ERR
-				"EXT4-fs: journaled quota options not "
-				"supported.\n");
+			ext4_msg(sb, KERN_ERR,
+				"journaled quota options not supported");
 			break;
 		case Opt_noquota:
 			break;
@@ -1443,8 +1449,9 @@ set_qf_format:
 			break;
 		case Opt_resize:
 			if (!is_remount) {
-				printk("EXT4-fs: resize option only available "
-					"for remount\n");
+				ext4_msg(sb, KERN_ERR,
+					"resize option only available "
+					"for remount");
 				return 0;
 			}
 			if (match_int(&args[0], &option) != 0)
@@ -1480,8 +1487,9 @@ set_qf_format:
 			if (option < 0 || option > (1 << 30))
 				return 0;
 			if (option & (option - 1)) {
-				printk(KERN_ERR "EXT4-fs: inode_readahead_blks"
-				       " must be a power of 2\n");
+				ext4_msg(sb, KERN_ERR,
+					"EXT4-fs: inode_readahead_blks"
+				       " must be a power of 2");
 				return 0;
 			}
 			sbi->s_inode_readahead_blks = option;
@@ -1508,9 +1516,9 @@ set_qf_format:
 				set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
 		default:
-			printk(KERN_ERR
-			       "EXT4-fs: Unrecognized mount option \"%s\" "
-			       "or missing value\n", p);
+			ext4_msg(sb, KERN_ERR,
+			       "Unrecognized mount option \"%s\" "
+			       "or missing value", p);
 			return 0;
 		}
 	}
@@ -1528,21 +1536,21 @@ set_qf_format:
 				(sbi->s_mount_opt & EXT4_MOUNT_GRPQUOTA)) ||
 		    (sbi->s_qf_names[GRPQUOTA] &&
 				(sbi->s_mount_opt & EXT4_MOUNT_USRQUOTA))) {
-			printk(KERN_ERR "EXT4-fs: old and new quota "
-					"format mixing.\n");
+			ext4_msg(sb, KERN_ERR, "old and new quota "
+					"format mixing");
 			return 0;
 		}
 
 		if (!sbi->s_jquota_fmt) {
-			printk(KERN_ERR "EXT4-fs: journaled quota format "
-					"not specified.\n");
+			ext4_msg(sb, KERN_ERR, "journaled quota format "
+					"not specified");
 			return 0;
 		}
 	} else {
 		if (sbi->s_jquota_fmt) {
-			printk(KERN_ERR "EXT4-fs: journaled quota format "
+			ext4_msg(sb, KERN_ERR, "journaled quota format "
 					"specified with no journaling "
-					"enabled.\n");
+					"enabled");
 			return 0;
 		}
 	}
@@ -1557,31 +1565,31 @@ static int ext4_setup_super(struct super
 	int res = 0;
 
 	if (le32_to_cpu(es->s_rev_level) > EXT4_MAX_SUPP_REV) {
-		printk(KERN_ERR "EXT4-fs warning: revision level too high, "
-		       "forcing read-only mode\n");
+		ext4_msg(sb, KERN_ERR, "revision level too high, "
+		       "forcing read-only mode");
 		res = MS_RDONLY;
 	}
 	if (read_only)
 		return res;
 	if (!(sbi->s_mount_state & EXT4_VALID_FS))
-		printk(KERN_WARNING "EXT4-fs warning: mounting unchecked fs, "
-		       "running e2fsck is recommended\n");
+		ext4_msg(sb, KERN_WARNING, "warning: mounting unchecked fs, "
+		       "running e2fsck is recommended");
 	else if ((sbi->s_mount_state & EXT4_ERROR_FS))
-		printk(KERN_WARNING
-		       "EXT4-fs warning: mounting fs with errors, "
-		       "running e2fsck is recommended\n");
+		ext4_msg(sb, KERN_WARNING,
+		       "warning: mounting fs with errors, "
+		       "running e2fsck is recommended");
 	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
-		printk(KERN_WARNING
-		       "EXT4-fs warning: maximal mount count reached, "
-		       "running e2fsck is recommended\n");
+		ext4_msg(sb, KERN_WARNING,
+		       "warning: maximal mount count reached, "
+		       "running e2fsck is recommended");
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
 			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
-		printk(KERN_WARNING
-		       "EXT4-fs warning: checktime reached, "
-		       "running e2fsck is recommended\n");
+		ext4_msg(sb, KERN_WARNING,
+		       "warning: checktime reached, "
+		       "running e2fsck is recommended");
 	if (!sbi->s_journal) 
 		es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
@@ -1603,11 +1611,11 @@ static int ext4_setup_super(struct super
 			sbi->s_mount_opt);
 
 	if (EXT4_SB(sb)->s_journal) {
-		printk(KERN_INFO "EXT4 FS on %s, %s journal on %s\n",
-		       sb->s_id, EXT4_SB(sb)->s_journal->j_inode ? "internal" :
+		ext4_msg(sb, KERN_INFO, "%s journal on %s",
+		       EXT4_SB(sb)->s_journal->j_inode ? "internal" :
 		       "external", EXT4_SB(sb)->s_journal->j_devname);
 	} else {
-		printk(KERN_INFO "EXT4 FS on %s, no journal\n", sb->s_id);
+		ext4_msg(sb, KERN_INFO, "no journal");
 	}
 	return res;
 }
@@ -1637,8 +1645,8 @@ static int ext4_fill_flex_info(struct su
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
-		printk(KERN_ERR "EXT4-fs: not enough memory for "
-				"%u flex groups\n", flex_group_count);
+		ext4_msg(sb, KERN_ERR, "not enough memory for "
+				"%u flex groups", flex_group_count);
 		goto failed;
 	}
 
@@ -1724,30 +1732,30 @@ static int ext4_check_descriptors(struct
 
 		block_bitmap = ext4_block_bitmap(sb, gdp);
 		if (block_bitmap < first_block || block_bitmap > last_block) {
-			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 			       "Block bitmap for group %u not in group "
-			       "(block %llu)!\n", i, block_bitmap);
+			       "(block %llu)!", i, block_bitmap);
 			return 0;
 		}
 		inode_bitmap = ext4_inode_bitmap(sb, gdp);
 		if (inode_bitmap < first_block || inode_bitmap > last_block) {
-			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 			       "Inode bitmap for group %u not in group "
-			       "(block %llu)!\n", i, inode_bitmap);
+			       "(block %llu)!", i, inode_bitmap);
 			return 0;
 		}
 		inode_table = ext4_inode_table(sb, gdp);
 		if (inode_table < first_block ||
 		    inode_table + sbi->s_itb_per_group - 1 > last_block) {
-			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
 			       "Inode table for group %u not in group "
-			       "(block %llu)!\n", i, inode_table);
+			       "(block %llu)!", i, inode_table);
 			return 0;
 		}
 		spin_lock(sb_bgl_lock(sbi, i));
 		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
-			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
-			       "Checksum for group %u failed (%u!=%u)\n",
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
+			       "Checksum for group %u failed (%u!=%u)",
 			       i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
 			       gdp)), le16_to_cpu(gdp->bg_checksum));
 			if (!(sb->s_flags & MS_RDONLY)) {
@@ -1796,8 +1804,8 @@ static void ext4_orphan_cleanup(struct s
 	}
 
 	if (bdev_read_only(sb->s_bdev)) {
-		printk(KERN_ERR "EXT4-fs: write access "
-			"unavailable, skipping orphan cleanup.\n");
+		ext4_msg(sb, KERN_ERR, "write access "
+			"unavailable, skipping orphan cleanup");
 		return;
 	}
 
@@ -1811,8 +1819,7 @@ static void ext4_orphan_cleanup(struct s
 	}
 
 	if (s_flags & MS_RDONLY) {
-		printk(KERN_INFO "EXT4-fs: %s: orphan cleanup on readonly fs\n",
-		       sb->s_id);
+		ext4_msg(sb, KERN_INFO, "orphan cleanup on readonly fs");
 		sb->s_flags &= ~MS_RDONLY;
 	}
 #ifdef CONFIG_QUOTA
@@ -1823,9 +1830,9 @@ static void ext4_orphan_cleanup(struct s
 		if (EXT4_SB(sb)->s_qf_names[i]) {
 			int ret = ext4_quota_on_mount(sb, i);
 			if (ret < 0)
-				printk(KERN_ERR
-					"EXT4-fs: Cannot turn on journaled "
-					"quota: error %d\n", ret);
+				ext4_msg(sb, KERN_ERR,
+					"Cannot turn on journaled "
+					"quota: error %d", ret);
 		}
 	}
 #endif
@@ -1842,16 +1849,16 @@ static void ext4_orphan_cleanup(struct s
 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
 		vfs_dq_init(inode);
 		if (inode->i_nlink) {
-			printk(KERN_DEBUG
-				"%s: truncating inode %lu to %lld bytes\n",
+			ext4_msg(sb, KERN_DEBUG,
+				"%s: truncating inode %lu to %lld bytes",
 				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
 			ext4_truncate(inode);
 			nr_truncates++;
 		} else {
-			printk(KERN_DEBUG
-				"%s: deleting unreferenced inode %lu\n",
+			ext4_msg(sb, KERN_DEBUG,
+				"%s: deleting unreferenced inode %lu",
 				__func__, inode->i_ino);
 			jbd_debug(2, "deleting unreferenced inode %lu\n",
 				  inode->i_ino);
@@ -1863,11 +1870,11 @@ static void ext4_orphan_cleanup(struct s
 #define PLURAL(x) (x), ((x) == 1) ? "" : "s"
 
 	if (nr_orphans)
-		printk(KERN_INFO "EXT4-fs: %s: %d orphan inode%s deleted\n",
-		       sb->s_id, PLURAL(nr_orphans));
+		ext4_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
+		       PLURAL(nr_orphans));
 	if (nr_truncates)
-		printk(KERN_INFO "EXT4-fs: %s: %d truncate%s cleaned up\n",
-		       sb->s_id, PLURAL(nr_truncates));
+		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
+		       PLURAL(nr_truncates));
 #ifdef CONFIG_QUOTA
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
@@ -2256,7 +2263,7 @@ static int ext4_fill_super(struct super_
 
 	blocksize = sb_min_blocksize(sb, EXT4_MIN_BLOCK_SIZE);
 	if (!blocksize) {
-		printk(KERN_ERR "EXT4-fs: unable to set blocksize\n");
+		ext4_msg(sb, KERN_ERR, "unable to set blocksize");
 		goto out_fail;
 	}
 
@@ -2272,7 +2279,7 @@ static int ext4_fill_super(struct super_
 	}
 
 	if (!(bh = sb_bread(sb, logical_sb_block))) {
-		printk(KERN_ERR "EXT4-fs: unable to read superblock\n");
+		ext4_msg(sb, KERN_ERR, "unable to read superblock");
 		goto out_fail;
 	}
 	/*
@@ -2342,9 +2349,9 @@ static int ext4_fill_super(struct super_
 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT4_HAS_INCOMPAT_FEATURE(sb, ~0U)))
-		printk(KERN_WARNING
-		       "EXT4-fs warning: feature flags set on rev 0 fs, "
-		       "running e2fsck is recommended\n");
+		ext4_msg(sb, KERN_WARNING,
+		       "feature flags set on rev 0 fs, "
+		       "running e2fsck is recommended");
 
 	/*
 	 * Check feature flags regardless of the revision level, since we
@@ -2353,16 +2360,18 @@ static int ext4_fill_super(struct super_
 	 */
 	features = EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT4_FEATURE_INCOMPAT_SUPP);
 	if (features) {
-		printk(KERN_ERR "EXT4-fs: %s: couldn't mount because of "
-		       "unsupported optional features (%x).\n", sb->s_id,
+		ext4_msg(sb, KERN_ERR,
+			"Couldn't mount because of "
+			"unsupported optional features (%x)",
 			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) &
 			~EXT4_FEATURE_INCOMPAT_SUPP));
 		goto failed_mount;
 	}
 	features = EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP);
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "EXT4-fs: %s: couldn't mount RDWR because of "
-		       "unsupported optional features (%x).\n", sb->s_id,
+		ext4_msg(sb, KERN_ERR,
+			"Couldn't mount RDWR because of "
+			"unsupported optional features (%x)",
 			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) &
 			~EXT4_FEATURE_RO_COMPAT_SUPP));
 		goto failed_mount;
@@ -2376,9 +2385,9 @@ static int ext4_fill_super(struct super_
 		 */
 		if (sizeof(root->i_blocks) < sizeof(u64) &&
 				!(sb->s_flags & MS_RDONLY)) {
-			printk(KERN_ERR "EXT4-fs: %s: Filesystem with huge "
+			ext4_msg(sb, KERN_ERR, "Filesystem with huge "
 					"files cannot be mounted read-write "
-					"without CONFIG_LBD.\n", sb->s_id);
+					"without CONFIG_LBD");
 			goto failed_mount;
 		}
 	}
@@ -2386,9 +2395,8 @@ static int ext4_fill_super(struct super_
 
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
-		printk(KERN_ERR
-		       "EXT4-fs: Unsupported filesystem blocksize %d on %s.\n",
-		       blocksize, sb->s_id);
+		ext4_msg(sb, KERN_ERR,
+		       "Unsupported filesystem blocksize %d", blocksize);
 		goto failed_mount;
 	}
 
@@ -2396,7 +2404,7 @@ static int ext4_fill_super(struct super_
 
 		/* Validate the filesystem blocksize */
 		if (!sb_set_blocksize(sb, blocksize)) {
-			printk(KERN_ERR "EXT4-fs: bad block size %d.\n",
+			ext4_msg(sb, KERN_ERR, "bad block size %d",
 					blocksize);
 			goto failed_mount;
 		}
@@ -2406,15 +2414,15 @@ static int ext4_fill_super(struct super_
 		offset = do_div(logical_sb_block, blocksize);
 		bh = sb_bread(sb, logical_sb_block);
 		if (!bh) {
-			printk(KERN_ERR
-			       "EXT4-fs: Can't read superblock on 2nd try.\n");
+			ext4_msg(sb, KERN_ERR,
+			       "Can't read superblock on 2nd try");
 			goto failed_mount;
 		}
 		es = (struct ext4_super_block *)(((char *)bh->b_data) + offset);
 		sbi->s_es = es;
 		if (es->s_magic != cpu_to_le16(EXT4_SUPER_MAGIC)) {
-			printk(KERN_ERR
-			       "EXT4-fs: Magic mismatch, very weird !\n");
+			ext4_msg(sb, KERN_ERR,
+			       "Magic mismatch, very weird!");
 			goto failed_mount;
 		}
 	}
@@ -2432,8 +2440,8 @@ static int ext4_fill_super(struct super_
 		if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
 		    (!is_power_of_2(sbi->s_inode_size)) ||
 		    (sbi->s_inode_size > blocksize)) {
-			printk(KERN_ERR
-			       "EXT4-fs: unsupported inode size: %d\n",
+			ext4_msg(sb, KERN_ERR,
+			       "unsupported inode size: %d",
 			       sbi->s_inode_size);
 			goto failed_mount;
 		}
@@ -2445,8 +2453,8 @@ static int ext4_fill_super(struct super_
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
 		    sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
 		    !is_power_of_2(sbi->s_desc_size)) {
-			printk(KERN_ERR
-			       "EXT4-fs: unsupported descriptor size %lu\n",
+			ext4_msg(sb, KERN_ERR,
+			       "unsupported descriptor size %lu",
 			       sbi->s_desc_size);
 			goto failed_mount;
 		}
@@ -2483,25 +2491,24 @@ static int ext4_fill_super(struct super_
 	}
 
 	if (sbi->s_blocks_per_group > blocksize * 8) {
-		printk(KERN_ERR
-		       "EXT4-fs: #blocks per group too big: %lu\n",
+		ext4_msg(sb, KERN_ERR,
+		       "#blocks per group too big: %lu",
 		       sbi->s_blocks_per_group);
 		goto failed_mount;
 	}
 	if (sbi->s_inodes_per_group > blocksize * 8) {
-		printk(KERN_ERR
-		       "EXT4-fs: #inodes per group too big: %lu\n",
+		ext4_msg(sb, KERN_ERR,
+		       "#inodes per group too big: %lu",
 		       sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
 
 	if (ext4_blocks_count(es) >
 		    (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
-		printk(KERN_ERR "EXT4-fs: filesystem on %s:"
-			" too large to mount safely\n", sb->s_id);
+		ext4_msg(sb, KERN_ERR, "filesystem"
+			" too large to mount safely");
 		if (sizeof(sector_t) < 8)
-			printk(KERN_WARNING "EXT4-fs: CONFIG_LBD not "
-					"enabled\n");
+			ext4_msg(sb, KERN_WARNING, "CONFIG_LBD not enabled");
 		goto failed_mount;
 	}
 
@@ -2511,8 +2518,8 @@ static int ext4_fill_super(struct super_
 	/* check blocks count against device size */
 	blocks_count = sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
 	if (blocks_count && ext4_blocks_count(es) > blocks_count) {
-		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu "
-		       "exceeds size of device (%llu blocks)\n",
+		ext4_msg(sb, KERN_WARNING, "bad geometry: block count %llu "
+		       "exceeds size of device (%llu blocks)",
 		       ext4_blocks_count(es), blocks_count);
 		goto failed_mount;
 	}
@@ -2522,8 +2529,8 @@ static int ext4_fill_super(struct super_
          * of the filesystem.
          */
         if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
-                printk(KERN_WARNING "EXT4-fs: bad geometry: first data"
-		       "block %u is beyond end of filesystem (%llu)\n",
+                ext4_msg(sb, KERN_WARNING, "bad geometry: first data"
+		       "block %u is beyond end of filesystem (%llu)",
 		       le32_to_cpu(es->s_first_data_block),
 		       ext4_blocks_count(es));
 		goto failed_mount;
@@ -2533,9 +2540,9 @@ static int ext4_fill_super(struct super_
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
 	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
-		printk(KERN_WARNING "EXT4-fs: groups count too large: %u "
+		ext4_msg(sb, KERN_WARNING, "groups count too large: %u "
 		       "(block count %llu, first data block %u, "
-		       "blocks per group %lu)\n", sbi->s_groups_count,
+		       "blocks per group %lu)", sbi->s_groups_count,
 		       ext4_blocks_count(es),
 		       le32_to_cpu(es->s_first_data_block),
 		       EXT4_BLOCKS_PER_GROUP(sb));
@@ -2547,7 +2554,7 @@ static int ext4_fill_super(struct super_
 	sbi->s_group_desc = kmalloc(db_count * sizeof(struct buffer_head *),
 				    GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
-		printk(KERN_ERR "EXT4-fs: not enough memory\n");
+		ext4_msg(sb, KERN_ERR, "not enough memory");
 		goto failed_mount;
 	}
 
@@ -2562,21 +2569,21 @@ static int ext4_fill_super(struct super_
 		block = descriptor_loc(sb, logical_sb_block, i);
 		sbi->s_group_desc[i] = sb_bread(sb, block);
 		if (!sbi->s_group_desc[i]) {
-			printk(KERN_ERR "EXT4-fs: "
-			       "can't read group descriptor %d\n", i);
+			ext4_msg(sb, KERN_ERR,
+			       "can't read group descriptor %d", i);
 			db_count = i;
 			goto failed_mount2;
 		}
 	}
 	if (!ext4_check_descriptors(sb)) {
-		printk(KERN_ERR "EXT4-fs: group descriptors corrupted!\n");
+		ext4_msg(sb, KERN_ERR, "group descriptors corrupted!");
 		goto failed_mount2;
 	}
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
 		if (!ext4_fill_flex_info(sb)) {
-			printk(KERN_ERR
-			       "EXT4-fs: unable to initialize "
-			       "flex_bg meta info!\n");
+			ext4_msg(sb, KERN_ERR,
+			       "unable to initialize "
+			       "flex_bg meta info!");
 			goto failed_mount2;
 		}
 
@@ -2598,7 +2605,7 @@ static int ext4_fill_super(struct super_
 		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
 	}
 	if (err) {
-		printk(KERN_ERR "EXT4-fs: insufficient memory\n");
+		ext4_msg(sb, KERN_ERR, "insufficient memory");
 		goto failed_mount3;
 	}
 
@@ -2632,13 +2639,13 @@ static int ext4_fill_super(struct super_
 			goto failed_mount3;
 		if (!(sb->s_flags & MS_RDONLY) &&
 		    EXT4_SB(sb)->s_journal->j_failed_commit) {
-			printk(KERN_CRIT "EXT4-fs error (device %s): "
+			ext4_msg(sb, KERN_CRIT, "error: "
 			       "ext4_fill_super: Journal transaction "
-			       "%u is corrupt\n", sb->s_id,
+			       "%u is corrupt",
 			       EXT4_SB(sb)->s_journal->j_failed_commit);
 			if (test_opt(sb, ERRORS_RO)) {
-				printk(KERN_CRIT
-				       "Mounting filesystem read-only\n");
+				ext4_msg(sb, KERN_CRIT,
+				       "Mounting filesystem read-only");
 				sb->s_flags |= MS_RDONLY;
 				EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 				es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
@@ -2652,8 +2659,8 @@ static int ext4_fill_super(struct super_
 		}
 	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
 	      EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
-		printk(KERN_ERR "EXT4-fs: required journal recovery "
-		       "suppressed and not mounted read-only\n");
+		ext4_msg(sb, KERN_ERR, "required journal recovery "
+		       "suppressed and not mounted read-only");
 		goto failed_mount4;
 	} else {
 		clear_opt(sbi->s_mount_opt, DATA_FLAGS);
@@ -2666,7 +2673,7 @@ static int ext4_fill_super(struct super_
 	if (ext4_blocks_count(es) > 0xffffffffULL &&
 	    !jbd2_journal_set_features(EXT4_SB(sb)->s_journal, 0, 0,
 				       JBD2_FEATURE_INCOMPAT_64BIT)) {
-		printk(KERN_ERR "EXT4-fs: Failed to set 64-bit journal feature\n");
+		ext4_msg(sb, KERN_ERR, "Failed to set 64-bit journal feature");
 		goto failed_mount4;
 	}
 
@@ -2704,8 +2711,8 @@ static int ext4_fill_super(struct super_
 	case EXT4_MOUNT_WRITEBACK_DATA:
 		if (!jbd2_journal_check_available_features
 		    (sbi->s_journal, 0, 0, JBD2_FEATURE_INCOMPAT_REVOKE)) {
-			printk(KERN_ERR "EXT4-fs: Journal does not support "
-			       "requested data journaling mode\n");
+			ext4_msg(sb, KERN_ERR, "Journal does not support "
+			       "requested data journaling mode");
 			goto failed_mount4;
 		}
 	default:
@@ -2717,8 +2724,8 @@ no_journal:
 
 	if (test_opt(sb, NOBH)) {
 		if (!(test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)) {
-			printk(KERN_WARNING "EXT4-fs: Ignoring nobh option - "
-				"its supported only with writeback mode\n");
+			ext4_msg(sb, KERN_WARNING, "Ignoring nobh option - "
+				"its supported only with writeback mode");
 			clear_opt(sbi->s_mount_opt, NOBH);
 		}
 	}
@@ -2729,18 +2736,18 @@ no_journal:
 
 	root = ext4_iget(sb, EXT4_ROOT_INO);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "EXT4-fs: get root inode failed\n");
+		ext4_msg(sb, KERN_ERR, "get root inode failed");
 		ret = PTR_ERR(root);
 		goto failed_mount4;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
 		iput(root);
-		printk(KERN_ERR "EXT4-fs: corrupt root inode, run e2fsck\n");
+		ext4_msg(sb, KERN_ERR, "corrupt root inode, run e2fsck");
 		goto failed_mount4;
 	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
-		printk(KERN_ERR "EXT4-fs: get root dentry failed\n");
+		ext4_msg(sb, KERN_ERR, "get root dentry failed");
 		iput(root);
 		ret = -ENOMEM;
 		goto failed_mount4;
@@ -2769,21 +2776,21 @@ no_journal:
 							sbi->s_inode_size) {
 		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
 						       EXT4_GOOD_OLD_INODE_SIZE;
-		printk(KERN_INFO "EXT4-fs: required extra inode space not"
-			"available.\n");
+		ext4_msg(sb, KERN_INFO, "required extra inode space not"
+			"available");
 	}
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
-				"requested data journaling mode\n");
+		ext4_msg(sb, KERN_WARNING, "Ignoring delalloc option - "
+				"requested data journaling mode");
 		clear_opt(sbi->s_mount_opt, DELALLOC);
 	} else if (test_opt(sb, DELALLOC))
-		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
+		ext4_msg(sb, KERN_INFO, "delayed allocation enabled");
 
 	ext4_ext_init(sb);
 	err = ext4_mb_init(sb, needs_recovery);
 	if (err) {
-		printk(KERN_ERR "EXT4-fs: failed to initalize mballoc (%d)\n",
+		ext4_msg(sb, KERN_ERR, "failed to initalize mballoc (%d)",
 		       err);
 		goto failed_mount4;
 	}
@@ -2810,7 +2817,7 @@ no_journal:
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
 	if (needs_recovery) {
-		printk(KERN_INFO "EXT4-fs: recovery complete.\n");
+		ext4_msg(sb, KERN_INFO, "recovery complete");
 		ext4_mark_recovery_complete(sb, es);
 	}
 	if (EXT4_SB(sb)->s_journal) {
@@ -2823,20 +2830,18 @@ no_journal:
 	} else
 		descr = "out journal";
 
-	printk(KERN_INFO "EXT4-fs: mounted filesystem %s with%s\n",
-	       sb->s_id, descr);
+	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s", descr);
 
 	lock_kernel();
 	return 0;
 
 cantfind_ext4:
 	if (!silent)
-		printk(KERN_ERR "VFS: Can't find ext4 filesystem on dev %s.\n",
-		       sb->s_id);
+		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
 	goto failed_mount;
 
 failed_mount4:
-	printk(KERN_ERR "EXT4-fs (device %s): mount failed\n", sb->s_id);
+	ext4_msg(sb, KERN_ERR, "mount failed");
 	if (sbi->s_journal) {
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
@@ -2906,27 +2911,27 @@ static journal_t *ext4_get_journal(struc
 
 	journal_inode = ext4_iget(sb, journal_inum);
 	if (IS_ERR(journal_inode)) {
-		printk(KERN_ERR "EXT4-fs: no journal found.\n");
+		ext4_msg(sb, KERN_ERR, "no journal found");
 		return NULL;
 	}
 	if (!journal_inode->i_nlink) {
 		make_bad_inode(journal_inode);
 		iput(journal_inode);
-		printk(KERN_ERR "EXT4-fs: journal inode is deleted.\n");
+		ext4_msg(sb, KERN_ERR, "journal inode is deleted");
 		return NULL;
 	}
 
 	jbd_debug(2, "Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
 	if (!S_ISREG(journal_inode->i_mode)) {
-		printk(KERN_ERR "EXT4-fs: invalid journal inode.\n");
+		ext4_msg(sb, KERN_ERR, "invalid journal inode");
 		iput(journal_inode);
 		return NULL;
 	}
 
 	journal = jbd2_journal_init_inode(journal_inode);
 	if (!journal) {
-		printk(KERN_ERR "EXT4-fs: Could not load journal inode\n");
+		ext4_msg(sb, KERN_ERR, "Could not load journal inode");
 		iput(journal_inode);
 		return NULL;
 	}
@@ -2950,13 +2955,13 @@ static journal_t *ext4_get_dev_journal(s
 
 	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
 
-	bdev = ext4_blkdev_get(j_dev);
+	bdev = ext4_blkdev_get(j_dev, sb);
 	if (bdev == NULL)
 		return NULL;
 
 	if (bd_claim(bdev, sb)) {
-		printk(KERN_ERR
-			"EXT4-fs: failed to claim external journal device.\n");
+		ext4_msg(sb, KERN_ERR,
+			"failed to claim external journal device");
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
 		return NULL;
 	}
@@ -2964,8 +2969,8 @@ static journal_t *ext4_get_dev_journal(s
 	blocksize = sb->s_blocksize;
 	hblock = bdev_hardsect_size(bdev);
 	if (blocksize < hblock) {
-		printk(KERN_ERR
-			"EXT4-fs: blocksize too small for journal device.\n");
+		ext4_msg(sb, KERN_ERR,
+			"blocksize too small for journal device");
 		goto out_bdev;
 	}
 
@@ -2973,8 +2978,8 @@ static journal_t *ext4_get_dev_journal(s
 	offset = EXT4_MIN_BLOCK_SIZE % blocksize;
 	set_blocksize(bdev, blocksize);
 	if (!(bh = __bread(bdev, sb_block, blocksize))) {
-		printk(KERN_ERR "EXT4-fs: couldn't read superblock of "
-		       "external journal\n");
+		ext4_msg(sb, KERN_ERR, "couldn't read superblock of "
+		       "external journal");
 		goto out_bdev;
 	}
 
@@ -2982,14 +2987,14 @@ static journal_t *ext4_get_dev_journal(s
 	if ((le16_to_cpu(es->s_magic) != EXT4_SUPER_MAGIC) ||
 	    !(le32_to_cpu(es->s_feature_incompat) &
 	      EXT4_FEATURE_INCOMPAT_JOURNAL_DEV)) {
-		printk(KERN_ERR "EXT4-fs: external journal has "
-					"bad superblock\n");
+		ext4_msg(sb, KERN_ERR, "external journal has "
+					"bad superblock");
 		brelse(bh);
 		goto out_bdev;
 	}
 
 	if (memcmp(EXT4_SB(sb)->s_es->s_journal_uuid, es->s_uuid, 16)) {
-		printk(KERN_ERR "EXT4-fs: journal UUID does not match\n");
+		ext4_msg(sb, KERN_ERR, "journal UUID does not match");
 		brelse(bh);
 		goto out_bdev;
 	}
@@ -3001,19 +3006,19 @@ static journal_t *ext4_get_dev_journal(s
 	journal = jbd2_journal_init_dev(bdev, sb->s_bdev,
 					start, len, blocksize);
 	if (!journal) {
-		printk(KERN_ERR "EXT4-fs: failed to create device journal\n");
+		ext4_msg(sb, KERN_ERR, "failed to create device journal");
 		goto out_bdev;
 	}
 	journal->j_private = sb;
 	ll_rw_block(READ, 1, &journal->j_sb_buffer);
 	wait_on_buffer(journal->j_sb_buffer);
 	if (!buffer_uptodate(journal->j_sb_buffer)) {
-		printk(KERN_ERR "EXT4-fs: I/O error on journal device\n");
+		ext4_msg(sb, KERN_ERR, "I/O error on journal device");
 		goto out_journal;
 	}
 	if (be32_to_cpu(journal->j_superblock->s_nr_users) != 1) {
-		printk(KERN_ERR "EXT4-fs: External journal has more than one "
-					"user (unsupported) - %d\n",
+		ext4_msg(sb, KERN_ERR, "External journal has more than one "
+					"user (unsupported) - %d",
 			be32_to_cpu(journal->j_superblock->s_nr_users));
 		goto out_journal;
 	}
@@ -3041,8 +3046,8 @@ static int ext4_load_journal(struct supe
 
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
-		printk(KERN_INFO "EXT4-fs: external journal device major/minor "
-			"numbers have changed\n");
+		ext4_msg(sb, KERN_INFO, "external journal device major/minor "
+			"numbers have changed");
 		journal_dev = new_decode_dev(journal_devnum);
 	} else
 		journal_dev = new_decode_dev(le32_to_cpu(es->s_journal_dev));
@@ -3057,21 +3062,21 @@ static int ext4_load_journal(struct supe
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
 		if (sb->s_flags & MS_RDONLY) {
-			printk(KERN_INFO "EXT4-fs: INFO: recovery "
-					"required on readonly filesystem.\n");
+			ext4_msg(sb, KERN_INFO, "INFO: recovery "
+					"required on readonly filesystem");
 			if (really_read_only) {
-				printk(KERN_ERR "EXT4-fs: write access "
-					"unavailable, cannot proceed.\n");
+				ext4_msg(sb, KERN_ERR, "write access "
+					"unavailable, cannot proceed");
 				return -EROFS;
 			}
-			printk(KERN_INFO "EXT4-fs: write access will "
-			       "be enabled during recovery.\n");
+			ext4_msg(sb, KERN_INFO, "write access will "
+			       "be enabled during recovery");
 		}
 	}
 
 	if (journal_inum && journal_dev) {
-		printk(KERN_ERR "EXT4-fs: filesystem has both journal "
-		       "and inode journals!\n");
+		ext4_msg(sb, KERN_ERR, "filesystem has both journal "
+		       "and inode journals!");
 		return -EINVAL;
 	}
 
@@ -3084,14 +3089,14 @@ static int ext4_load_journal(struct supe
 	}
 
 	if (journal->j_flags & JBD2_BARRIER)
-		printk(KERN_INFO "EXT4-fs: barriers enabled\n");
+		ext4_msg(sb, KERN_INFO, "barriers enabled");
 	else
-		printk(KERN_INFO "EXT4-fs: barriers disabled\n");
+		ext4_msg(sb, KERN_INFO, "barriers disabled");
 
 	if (!really_read_only && test_opt(sb, UPDATE_JOURNAL)) {
 		err = jbd2_journal_update_format(journal);
 		if (err)  {
-			printk(KERN_ERR "EXT4-fs: error updating journal.\n");
+			ext4_msg(sb, KERN_ERR, "error updating journal");
 			jbd2_journal_destroy(journal);
 			return err;
 		}
@@ -3103,7 +3108,7 @@ static int ext4_load_journal(struct supe
 		err = jbd2_journal_load(journal);
 
 	if (err) {
-		printk(KERN_ERR "EXT4-fs: error loading journal.\n");
+		ext4_msg(sb, KERN_ERR, "error loading journal");
 		jbd2_journal_destroy(journal);
 		return err;
 	}
@@ -3140,8 +3145,8 @@ static int ext4_commit_super(struct supe
 		 * be remapped.  Nothing we can do but to retry the
 		 * write and hope for the best.
 		 */
-		printk(KERN_ERR "EXT4-fs: previous I/O error to "
-		       "superblock detected for %s.\n", sb->s_id);
+		ext4_msg(sb, KERN_ERR, "previous I/O error to "
+		       "superblock detected");
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
@@ -3164,8 +3169,8 @@ static int ext4_commit_super(struct supe
 
 		error = buffer_write_io_error(sbh);
 		if (error) {
-			printk(KERN_ERR "EXT4-fs: I/O error while writing "
-			       "superblock for %s.\n", sb->s_id);
+			ext4_msg(sb, KERN_ERR, "I/O error while writing "
+			       "superblock");
 			clear_buffer_write_io_error(sbh);
 			set_buffer_uptodate(sbh);
 		}
@@ -3445,9 +3450,9 @@ static int ext4_remount(struct super_blo
 			int ret;
 			if ((ret = EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					~EXT4_FEATURE_RO_COMPAT_SUPP))) {
-				printk(KERN_WARNING "EXT4-fs: %s: couldn't "
+				ext4_msg(sb, KERN_WARNING, "couldn't "
 				       "remount RDWR because of unsupported "
-				       "optional features (%x).\n", sb->s_id,
+				       "optional features (%x)",
 				(le32_to_cpu(sbi->s_es->s_feature_ro_compat) &
 					~EXT4_FEATURE_RO_COMPAT_SUPP));
 				err = -EROFS;
@@ -3464,9 +3469,8 @@ static int ext4_remount(struct super_blo
 					ext4_get_group_desc(sb, g, NULL);
 
 				if (!ext4_group_desc_csum_verify(sbi, g, gdp)) {
-					printk(KERN_ERR
-	       "EXT4-fs: ext4_remount: "
-		"Checksum for group %u failed (%u!=%u)\n",
+					ext4_msg(sb, KERN_ERR,
+	       "ext4_remount: Checksum for group %u failed (%u!=%u)",
 		g, le16_to_cpu(ext4_group_desc_csum(sbi, g, gdp)),
 					       le16_to_cpu(gdp->bg_checksum));
 					err = -EINVAL;
@@ -3480,11 +3484,10 @@ static int ext4_remount(struct super_blo
 			 * require a full umount/remount for now.
 			 */
 			if (es->s_last_orphan) {
-				printk(KERN_WARNING "EXT4-fs: %s: couldn't "
+				ext4_msg(sb, KERN_WARNING, "Couldn't "
 				       "remount RDWR because of unprocessed "
 				       "orphan inode list.  Please "
-				       "umount/remount instead.\n",
-				       sb->s_id);
+				       "umount/remount instead");
 				err = -EINVAL;
 				goto restore_opts;
 			}
@@ -3738,9 +3741,9 @@ static int ext4_quota_on(struct super_bl
 	if (EXT4_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not in fs root? */
 		if (path.dentry->d_parent != sb->s_root)
-			printk(KERN_WARNING
-				"EXT4-fs: Quota file not on filesystem root. "
-				"Journaled quota will not work.\n");
+			ext4_msg(sb, KERN_WARNING,
+				"Quota file not on filesystem root. "
+				"Journaled quota will not work");
 	}
 
 	/*
@@ -3823,8 +3826,8 @@ static ssize_t ext4_quota_write(struct s
 	handle_t *handle = journal_current_handle();
 
 	if (EXT4_SB(sb)->s_journal && !handle) {
-		printk(KERN_WARNING "EXT4-fs: Quota write (off=%llu, len=%llu)"
-			" cancelled because transaction is not started.\n",
+		ext4_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
+			" cancelled because transaction is not started",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
@@ -3896,10 +3899,10 @@ static struct file_system_type ext4_fs_t
 static int ext4dev_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	printk(KERN_WARNING "EXT4-fs: Update your userspace programs "
-	       "to mount using ext4\n");
-	printk(KERN_WARNING "EXT4-fs: ext4dev backwards compatibility "
-	       "will go away by 2.6.31\n");
+	printk(KERN_WARNING "EXT4-fs (%s): Update your userspace programs "
+	       "to mount using ext4\n", dev_name);
+	printk(KERN_WARNING "EXT4-fs (%s): ext4dev backwards compatibility "
+	       "will go away by 2.6.31\n", dev_name);
 	return get_sb_bdev(fs_type, flags, dev_name, data, ext4_fill_super, mnt);
 }
 

