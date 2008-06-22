From: FD Cami <francois.cami@free.fr>
Subject: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
Date: Sun, 22 Jun 2008 20:18:41 +0200
Message-ID: <20080622201841.669ff882@olorin>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kasper Sandberg <lkml@metanurb.dk>
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp5-g19.free.fr ([212.27.42.35]:50891 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYFVSSk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jun 2008 14:18:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

This patch takes a shot at replacing the direct use of printk(KERN_WARNING)
in extX by extX_warning. We now get the device number in the warning message :
"EXT3-fs warning (device hda1): ext3_setup_super: maximal mount count reached, running e2fsck is recommended"
It also adds the device information on a pair of printk(KERN_ERR) (this was
first suggested by Kasper two weeks ago).
It also adds the device information on the "mounted filesystem" message :
"EXT3-fs: hda1 is now mounted with ordered data mode."
It also replaces some whitespaces by tabs to increase consistency within
super.c .
One unused variable was removed in ext4/super.c .

I will work on replacing all printks in ext3/ext4 in the coming days if no one
/ beats / already has beaten / me to it.

Compile tested on ext4, compiled and booted on ext3, however not all string
changes have been tested. 

Signed-off-by: Francois Cami <francois.cami@free.fr>

diff -uprN -X linux-2.6.26-rc7/Documentation/dontdiff linux-2.6.26-rc7-vanilla/fs/ext3/super.c linux-2.6.26-rc7/fs/ext3/super.c
--- linux-2.6.26-rc7-vanilla/fs/ext3/super.c	2008-06-22 14:54:22.000000000 +0200
+++ linux-2.6.26-rc7/fs/ext3/super.c	2008-06-22 19:51:41.000000000 +0200
@@ -305,9 +305,9 @@ void ext3_update_dynamic_rev(struct supe
 		return;
 
 	ext3_warning(sb, __func__,
-		     "updating to rev %d because of new feature flag, "
-		     "running e2fsck is recommended",
-		     EXT3_DYNAMIC_REV);
+			"updating to rev %d because of new feature flag, "
+			"running e2fsck is recommended",
+			EXT3_DYNAMIC_REV);
 
 	es->s_first_ino = cpu_to_le32(EXT3_GOOD_OLD_FIRST_INO);
 	es->s_inode_size = cpu_to_le16(EXT3_GOOD_OLD_INODE_SIZE);
@@ -1192,31 +1192,33 @@ static int ext3_setup_super(struct super
 	int res = 0;
 
 	if (le32_to_cpu(es->s_rev_level) > EXT3_MAX_SUPP_REV) {
-		printk (KERN_ERR "EXT3-fs warning: revision level too high, "
-			"forcing read-only mode\n");
+		printk (KERN_ERR "EXT3-fs on %s warning: revision level too high, "
+				"forcing read-only mode\n", sb->s_id);
 		res = MS_RDONLY;
 	}
 	if (read_only)
 		return res;
 	if (!(sbi->s_mount_state & EXT3_VALID_FS))
-		printk (KERN_WARNING "EXT3-fs warning: mounting unchecked fs, "
-			"running e2fsck is recommended\n");
+		ext3_warning(sb, __func__,
+				"mounting unchecked fs, running e2fsck is "
+				"recommended");
 	else if ((sbi->s_mount_state & EXT3_ERROR_FS))
-		printk (KERN_WARNING
-			"EXT3-fs warning: mounting fs with errors, "
-			"running e2fsck is recommended\n");
+		ext3_warning(sb, __func__,
+				"mounting fs with errors, running e2fsck is "
+				"recommended");
 	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
-		printk (KERN_WARNING
-			"EXT3-fs warning: maximal mount count reached, "
-			"running e2fsck is recommended\n");
+		ext3_warning(sb, __func__,
+				"maximal mount count reached, running e2fsck "
+				"is recommended");
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
 			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
-		printk (KERN_WARNING
-			"EXT3-fs warning: checktime reached, "
-			"running e2fsck is recommended\n");
+		ext3_warning(sb, __func__,
+				"checktime reached, running e2fsck is "
+				"recommended");
+
 #if 0
 		/* @@@ We _will_ want to clear the valid bit if we find
                    inconsistencies, to force a fsck at reboot.  But for
@@ -1342,8 +1344,8 @@ static void ext3_orphan_cleanup (struct 
 	}
 
 	if (bdev_read_only(sb->s_bdev)) {
-		printk(KERN_ERR "EXT3-fs: write access "
-			"unavailable, skipping orphan cleanup.\n");
+		printk(KERN_ERR "EXT3-fs on %s: write access "
+			"unavailable, skipping orphan cleanup.\n", sb->s_id);
 		return;
 	}
 
@@ -1601,9 +1603,9 @@ static int ext3_fill_super (struct super
 	    (EXT3_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT3_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT3_HAS_INCOMPAT_FEATURE(sb, ~0U)))
-		printk(KERN_WARNING
-		       "EXT3-fs warning: feature flags set on rev 0 fs, "
-		       "running e2fsck is recommended\n");
+		ext3_warning(sb, __func__,
+				"feature flags set on rev 0 fs, running "
+				"e2fsck is recommended");
 	/*
 	 * Check feature flags regardless of the revision level, since we
 	 * previously didn't change the revision level when setting the flags,
@@ -1737,8 +1739,7 @@ static int ext3_fill_super (struct super
 		printk(KERN_ERR "EXT3-fs: filesystem on %s:"
 			" too large to mount safely\n", sb->s_id);
 		if (sizeof(sector_t) < 8)
-			printk(KERN_WARNING "EXT3-fs: CONFIG_LBD not "
-					"enabled\n");
+			ext3_warning(sb, __func__, "CONFIG_LBD not enabled");
 		goto failed_mount;
 	}
 
@@ -1869,8 +1870,9 @@ static int ext3_fill_super (struct super
 
 	if (test_opt(sb, NOBH)) {
 		if (!(test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)) {
-			printk(KERN_WARNING "EXT3-fs: Ignoring nobh option - "
-				"its supported only with writeback mode\n");
+			ext3_warning(sb, __func__,
+					"Ignoring nobh option - it is only "
+					"supported with writeback mode");
 			clear_opt(sbi->s_mount_opt, NOBH);
 		}
 	}
@@ -1913,7 +1915,8 @@ static int ext3_fill_super (struct super
 	if (needs_recovery)
 		printk (KERN_INFO "EXT3-fs: recovery complete.\n");
 	ext3_mark_recovery_complete(sb, es);
-	printk (KERN_INFO "EXT3-fs: mounted filesystem with %s data mode.\n",
+	printk (KERN_INFO "EXT3-fs: %s is now mounted with %s data mode.\n",
+		sb->s_id,
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
@@ -2301,11 +2304,12 @@ static void ext3_clear_journal_err(struc
 		char nbuf[16];
 
 		errstr = ext3_decode_error(sb, j_errno, nbuf);
-		ext3_warning(sb, __func__, "Filesystem error recorded "
-			     "from previous mount: %s", errstr);
-		ext3_warning(sb, __func__, "Marking fs in need of "
-			     "filesystem check.");
-
+		ext3_warning(sb, __func__,
+			"Filesystem error recorded from previous mount: %s",
+			errstr);
+		ext3_warning(sb, __func__,
+			"Marking fs in need of filesystem check.");
+					
 		EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT3_ERROR_FS);
 		ext3_commit_super (sb, es, 1);
@@ -2773,9 +2777,9 @@ static int ext3_quota_on(struct super_bl
 	}
 	/* Quotafile not in fs root? */
 	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
-		printk(KERN_WARNING
-			"EXT3-fs: Quota file not on filesystem root. "
-			"Journalled quota will not work.\n");
+		ext3_warning(sb, __func__,
+ 			"Quota file not on filesystem root. "
+ 			"Journalled quota will not work.");
 	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path, remount);
 }
@@ -2836,8 +2840,9 @@ static ssize_t ext3_quota_write(struct s
 	handle_t *handle = journal_current_handle();
 
 	if (!handle) {
-		printk(KERN_WARNING "EXT3-fs: Quota write (off=%Lu, len=%Lu)"
-			" cancelled because transaction is not started.\n",
+		ext3_warning(sb, __func__,
+			"Quota write (off=%Lu, len=%Lu) cancelled because "
+			"transaction is not started.",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
diff -uprN -X linux-2.6.26-rc7/Documentation/dontdiff linux-2.6.26-rc7-vanilla/fs/ext4/super.c linux-2.6.26-rc7/fs/ext4/super.c
--- linux-2.6.26-rc7-vanilla/fs/ext4/super.c	2008-06-22 14:54:24.000000000 +0200
+++ linux-2.6.26-rc7/fs/ext4/super.c	2008-06-22 19:56:24.000000000 +0200
@@ -355,9 +355,9 @@ void ext4_update_dynamic_rev(struct supe
 		return;
 
 	ext4_warning(sb, __func__,
-		     "updating to rev %d because of new feature flag, "
-		     "running e2fsck is recommended",
-		     EXT4_DYNAMIC_REV);
+			"updating to rev %d because of new feature flag, "
+			"running e2fsck is recommended",
+			EXT4_DYNAMIC_REV);
 
 	es->s_first_ino = cpu_to_le32(EXT4_GOOD_OLD_FIRST_INO);
 	es->s_inode_size = cpu_to_le16(EXT4_GOOD_OLD_INODE_SIZE);
@@ -671,7 +671,6 @@ static int ext4_show_options(struct seq_
 	unsigned long def_mount_opts;
 	struct super_block *sb = vfs->mnt_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	journal_t *journal = sbi->s_journal;
 	struct ext4_super_block *es = sbi->s_es;
 
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
@@ -1388,24 +1387,25 @@ static int ext4_setup_super(struct super
 	if (read_only)
 		return res;
 	if (!(sbi->s_mount_state & EXT4_VALID_FS))
-		printk (KERN_WARNING "EXT4-fs warning: mounting unchecked fs, "
-			"running e2fsck is recommended\n");
+		ext4_warning(sb, __func__,
+				"mounting unchecked fs, running e2fsck is "
+				"recommended");
 	else if ((sbi->s_mount_state & EXT4_ERROR_FS))
-		printk (KERN_WARNING
-			"EXT4-fs warning: mounting fs with errors, "
-			"running e2fsck is recommended\n");
+		ext4_warning(sb, __func__,
+				"mounting fs with errors, running e2fsck is "
+				"recommended");
 	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
-		printk (KERN_WARNING
-			"EXT4-fs warning: maximal mount count reached, "
-			"running e2fsck is recommended\n");
+		ext4_warning(sb, __func__,
+				"maximal mount count reached, running e2fsck "
+				"is recommended");
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
 			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
-		printk (KERN_WARNING
-			"EXT4-fs warning: checktime reached, "
-			"running e2fsck is recommended\n");
+		ext4_warning(sb, __func__,
+				"checktime reached, running e2fsck is "
+				"recommended");
 #if 0
 		/* @@@ We _will_ want to clear the valid bit if we find
 		 * inconsistencies, to force a fsck at reboot.  But for
@@ -1578,8 +1578,8 @@ static void ext4_orphan_cleanup (struct 
 	}
 
 	if (bdev_read_only(sb->s_bdev)) {
-		printk(KERN_ERR "EXT4-fs: write access "
-			"unavailable, skipping orphan cleanup.\n");
+		printk(KERN_ERR "EXT4-fs on %s: write access "
+			"unavailable, skipping orphan cleanup.\n", sb->s_id);
 		return;
 	}
 
@@ -1939,17 +1939,17 @@ static int ext4_fill_super (struct super
 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT4_HAS_INCOMPAT_FEATURE(sb, ~0U)))
-		printk(KERN_WARNING
-		       "EXT4-fs warning: feature flags set on rev 0 fs, "
-		       "running e2fsck is recommended\n");
+		ext4_warning(sb, __func__,
+				"feature flags set on rev 0 fs, running "
+				"e2fsck is recommended");
 
 	/*
 	 * Since ext4 is still considered development code, we require
 	 * that the TEST_FILESYS flag in s->flags be set.
 	 */
 	if (!(le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)) {
-		printk(KERN_WARNING "EXT4-fs: %s: not marked "
-		       "OK to use with test code.\n", sb->s_id);
+		ext4_warning(sb, __func__, 
+			"not marked OK to use with test code.");
 		goto failed_mount;
 	}
 
@@ -2090,8 +2090,8 @@ static int ext4_fill_super (struct super
 		printk(KERN_ERR "EXT4-fs: filesystem on %s:"
 			" too large to mount safely\n", sb->s_id);
 		if (sizeof(sector_t) < 8)
-			printk(KERN_WARNING "EXT4-fs: CONFIG_LBD not "
-					"enabled\n");
+			ext4_warning(sb, __func__,
+					"CONFIG_LBD not enabled");
 		goto failed_mount;
 	}
 
@@ -2101,8 +2101,9 @@ static int ext4_fill_super (struct super
 	/* ensure blocks_count calculation below doesn't sign-extend */
 	if (ext4_blocks_count(es) + EXT4_BLOCKS_PER_GROUP(sb) <
 	    le32_to_cpu(es->s_first_data_block) + 1) {
-		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu, "
-		       "first data block %u, blocks per group %lu\n",
+		ext4_warning(sb, __func__,
+			"bad geometry: block count %llu, first data block "
+			" %u, blocks per group %lu",
 			ext4_blocks_count(es),
 			le32_to_cpu(es->s_first_data_block),
 			EXT4_BLOCKS_PER_GROUP(sb));
@@ -2283,8 +2284,9 @@ static int ext4_fill_super (struct super
 
 	if (test_opt(sb, NOBH)) {
 		if (!(test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)) {
-			printk(KERN_WARNING "EXT4-fs: Ignoring nobh option - "
-				"its supported only with writeback mode\n");
+			ext4_warning(sb, __func__,
+				"Ignoring nobh option - it is only "
+				"supported with writeback mode");
 			clear_opt(sbi->s_mount_opt, NOBH);
 		}
 	}
@@ -2353,7 +2355,8 @@ static int ext4_fill_super (struct super
 	if (needs_recovery)
 		printk (KERN_INFO "EXT4-fs: recovery complete.\n");
 	ext4_mark_recovery_complete(sb, es);
-	printk (KERN_INFO "EXT4-fs: mounted filesystem with %s data mode.\n",
+	printk (KERN_INFO "EXT4-fs: %s is now mounted with %s data mode.\n",
+		sb->s_id,
 		test_opt(sb,DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ? "journal":
 		test_opt(sb,DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
@@ -2745,9 +2748,10 @@ static void ext4_clear_journal_err(struc
 
 		errstr = ext4_decode_error(sb, j_errno, nbuf);
 		ext4_warning(sb, __func__, "Filesystem error recorded "
-			     "from previous mount: %s", errstr);
+						"from previous mount: %s",
+						errstr);
 		ext4_warning(sb, __func__, "Marking fs in need of "
-			     "filesystem check.");
+						"filesystem check.");
 
 		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
@@ -2916,10 +2920,10 @@ static int ext4_remount (struct super_bl
 			__le32 ret;
 			if ((ret = EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					~EXT4_FEATURE_RO_COMPAT_SUPP))) {
-				printk(KERN_WARNING "EXT4-fs: %s: couldn't "
-				       "remount RDWR because of unsupported "
-				       "optional features (%x).\n",
-				       sb->s_id, le32_to_cpu(ret));
+				ext4_warning(sb, __func__,
+					"could not remount RDWR because of "
+					"unsupported optional features (%x).",
+					le32_to_cpu(ret));
 				err = -EROFS;
 				goto restore_opts;
 			}
@@ -2930,11 +2934,10 @@ static int ext4_remount (struct super_bl
 			 * require a full umount/remount for now.
 			 */
 			if (es->s_last_orphan) {
-				printk(KERN_WARNING "EXT4-fs: %s: couldn't "
-				       "remount RDWR because of unprocessed "
-				       "orphan inode list.  Please "
-				       "umount/remount instead.\n",
-				       sb->s_id);
+				ext4_warning(sb, __func__,
+					"could not remount RDWR because of "
+					"unprocessed orphan inode list. "
+					"Please umount/remount instead.");
 				err = -EINVAL;
 				goto restore_opts;
 			}
@@ -3219,9 +3222,9 @@ static int ext4_quota_on(struct super_bl
 	if (EXT4_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not of fs root? */
 		if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
-			printk(KERN_WARNING
-				"EXT4-fs: Quota file not on filesystem root. "
-				"Journaled quota will not work.\n");
+			ext4_warning(sb, __func__,
+				"Quota file not on filesystem root. "
+				"Journaled quota will not work.");
  	}
 
 	/*
@@ -3298,8 +3301,9 @@ static ssize_t ext4_quota_write(struct s
 	handle_t *handle = journal_current_handle();
 
 	if (!handle) {
-		printk(KERN_WARNING "EXT4-fs: Quota write (off=%Lu, len=%Lu)"
-			" cancelled because transaction is not started.\n",
+		ext4_warning(sb, __func__,
+			"Quota write (off=%Lu, len=%Lu) cancelled because "
+			"transaction is not started.",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
