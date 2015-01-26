From: Jan Mrazek <email@honzamrazek.cz>
Subject: [PATCH 1/1] Fix of coding style
Date: Mon, 26 Jan 2015 08:24:14 -0800
Message-ID: <BLU436-SMTP226247403551FD98C6991B7D9350@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jiri Slaby <gep@mail.muni.cz>, Jan Mrazek <email@honzamrazek.cz>
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	trivial@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu004-omc1s2.hotmail.com ([65.55.116.13]:55799 "EHLO
	BLU004-OMC1S2.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbbAZQYu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2015 11:24:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- multiline strings changed to singleline (so it can be greped)

Signed-off-by: Jan Mrazek <email@honzamrazek.cz>
---
 fs/ext4/super.c | 378 ++++++++++++++++++++++++++------------------------------
 1 file changed, 172 insertions(+), 206 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 496214d..a58ff53 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -438,13 +438,11 @@ void __ext4_error_inode(struct inode *inode, const char *function,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 		if (block)
-			printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: "
-			       "inode #%lu: block %llu: comm %s: %pV\n",
+			printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: inode #%lu: block %llu: comm %s: %pV\n",
 			       inode->i_sb->s_id, function, line, inode->i_ino,
 			       block, current->comm, &vaf);
 		else
-			printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: "
-			       "inode #%lu: comm %s: %pV\n",
+			printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: inode #%lu: comm %s: %pV\n",
 			       inode->i_sb->s_id, function, line, inode->i_ino,
 			       current->comm, &vaf);
 		va_end(args);
@@ -474,14 +472,12 @@ void __ext4_error_file(struct file *file, const char *function,
 		vaf.va = &args;
 		if (block)
 			printk(KERN_CRIT
-			       "EXT4-fs error (device %s): %s:%d: inode #%lu: "
-			       "block %llu: comm %s: path %s: %pV\n",
+			       "EXT4-fs error (device %s): %s:%d: inode #%lu: block %llu: comm %s: path %s: %pV\n",
 			       inode->i_sb->s_id, function, line, inode->i_ino,
 			       block, current->comm, path, &vaf);
 		else
 			printk(KERN_CRIT
-			       "EXT4-fs error (device %s): %s:%d: inode #%lu: "
-			       "comm %s: path %s: %pV\n",
+			       "EXT4-fs error (device %s): %s:%d: inode #%lu: comm %s: path %s: %pV\n",
 			       inode->i_sb->s_id, function, line, inode->i_ino,
 			       current->comm, path, &vaf);
 		va_end(args);
@@ -673,7 +669,6 @@ __acquires(bitlock)
 	 * more appropriate error code.
 	 */
 	ext4_lock_group(sb, grp);
-	return;
 }
 
 void ext4_update_dynamic_rev(struct super_block *sb)
@@ -684,8 +679,7 @@ void ext4_update_dynamic_rev(struct super_block *sb)
 		return;
 
 	ext4_warning(sb,
-		     "updating to rev %d because of new feature flag, "
-		     "running e2fsck is recommended",
+		     "updating to rev %d because of new feature flag, running e2fsck is recommended",
 		     EXT4_DYNAMIC_REV);
 
 	es->s_first_ino = cpu_to_le32(EXT4_GOOD_OLD_FIRST_INO);
@@ -731,6 +725,7 @@ static void ext4_blkdev_put(struct block_device *bdev)
 static void ext4_blkdev_remove(struct ext4_sb_info *sbi)
 {
 	struct block_device *bdev;
+
 	bdev = sbi->journal_bdev;
 	if (bdev) {
 		ext4_blkdev_put(bdev);
@@ -753,8 +748,8 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
 	printk(KERN_ERR "sb_info orphan list:\n");
 	list_for_each(l, &sbi->s_orphan) {
 		struct inode *inode = orphan_list_entry(l);
-		printk(KERN_ERR "  "
-		       "inode %s:%lu at %p: mode %o, nlink %d, next %d\n",
+
+		printk(KERN_ERR "  inode %s:%lu at %p: mode %o, nlink %d, next %d\n",
 		       inode->i_sb->s_id, inode->i_ino, inode,
 		       inode->i_mode, inode->i_nlink,
 		       NEXT_ORPHAN(inode));
@@ -908,6 +903,7 @@ static int ext4_drop_inode(struct inode *inode)
 static void ext4_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
+
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
@@ -1269,13 +1265,12 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
 	if (sb_any_quota_loaded(sb) &&
 		!sbi->s_qf_names[qtype]) {
 		ext4_msg(sb, KERN_ERR,
-			"Cannot change journaled "
-			"quota options when quota turned on");
+			"Cannot change journaled quota options when quota turned on");
 		return -1;
 	}
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) {
-		ext4_msg(sb, KERN_ERR, "Cannot set journaled quota options "
-			 "when QUOTA feature is enabled");
+		ext4_msg(sb, KERN_ERR,
+			"Cannot set journaled quota options when QUOTA feature is enabled");
 		return -1;
 	}
 	qname = match_strdup(args);
@@ -1313,8 +1308,8 @@ static int clear_qf_name(struct super_block *sb, int qtype)
 
 	if (sb_any_quota_loaded(sb) &&
 		sbi->s_qf_names[qtype]) {
-		ext4_msg(sb, KERN_ERR, "Cannot change journaled quota options"
-			" when quota turned on");
+		ext4_msg(sb, KERN_ERR,
+			"Cannot change journaled quota options when quota turned on");
 		return -1;
 	}
 	kfree(sbi->s_qf_names[qtype]);
@@ -1477,8 +1472,9 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			break;
 
 	if (m->token == Opt_err) {
-		ext4_msg(sb, KERN_ERR, "Unrecognized mount option \"%s\" "
-			 "or missing value", opt);
+		ext4_msg(sb, KERN_ERR,
+			 "Unrecognized mount option \"%s\" or missing value",
+			 opt);
 		return -1;
 	}
 
@@ -1502,8 +1498,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	if (m->flags & MOPT_CLEAR_ERR)
 		clear_opt(sb, ERRORS_MASK);
 	if (token == Opt_noquota && sb_any_quota_loaded(sb)) {
-		ext4_msg(sb, KERN_ERR, "Cannot change quota "
-			 "options when quota turned on");
+		ext4_msg(sb, KERN_ERR, "Cannot change quota options when quota turned on");
 		return -1;
 	}
 
@@ -1520,8 +1515,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (token == Opt_inode_readahead_blks) {
 		if (arg && (arg > (1 << 30) || !is_power_of_2(arg))) {
 			ext4_msg(sb, KERN_ERR,
-				 "EXT4-fs: inode_readahead_blks must be "
-				 "0 or a power of 2 smaller than 2^31");
+				 "EXT4-fs: inode_readahead_blks must be 0 or a power of 2 smaller than 2^31");
 			return -1;
 		}
 		sbi->s_inode_readahead_blks = arg;
@@ -1568,23 +1562,23 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		}
 		journal_path = match_strdup(&args[0]);
 		if (!journal_path) {
-			ext4_msg(sb, KERN_ERR, "error: could not dup "
-				"journal device string");
+			ext4_msg(sb, KERN_ERR,
+				"error: could not dup journal device string");
 			return -1;
 		}
 
 		error = kern_path(journal_path, LOOKUP_FOLLOW, &path);
 		if (error) {
-			ext4_msg(sb, KERN_ERR, "error: could not find "
-				"journal device path: error %d", error);
+			ext4_msg(sb, KERN_ERR,
+				"error: could not find journal device path: error %d", error);
 			kfree(journal_path);
 			return -1;
 		}
 
 		journal_inode = path.dentry->d_inode;
 		if (!S_ISBLK(journal_inode->i_mode)) {
-			ext4_msg(sb, KERN_ERR, "error: journal path %s "
-				"is not a block device", journal_path);
+			ext4_msg(sb, KERN_ERR,
+				"error: journal path %s is not a block device", journal_path);
 			path_put(&path);
 			kfree(journal_path);
 			return -1;
@@ -1595,8 +1589,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		kfree(journal_path);
 	} else if (token == Opt_journal_ioprio) {
 		if (arg > 7) {
-			ext4_msg(sb, KERN_ERR, "Invalid journal IO priority"
-				 " (must be 0-7)");
+			ext4_msg(sb, KERN_ERR,
+				"Invalid journal IO priority (must be 0-7)");
 			return -1;
 		}
 		*journal_ioprio =
@@ -1604,7 +1598,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (m->flags & MOPT_DATAJ) {
 		if (is_remount) {
 			if (!sbi->s_journal)
-				ext4_msg(sb, KERN_WARNING, "Remounting file system with no journal so ignoring journalled data option");
+				ext4_msg(sb, KERN_WARNING,
+					"Remounting file system with no journal so ignoring journalled data option");
 			else if (test_opt(sb, DATA_FLAGS) != m->mount_opt) {
 				ext4_msg(sb, KERN_ERR,
 					 "Cannot change data mode on remount");
@@ -1618,15 +1613,14 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (m->flags & MOPT_QFMT) {
 		if (sb_any_quota_loaded(sb) &&
 		    sbi->s_jquota_fmt != m->mount_opt) {
-			ext4_msg(sb, KERN_ERR, "Cannot change journaled "
-				 "quota options when quota turned on");
+			ext4_msg(sb, KERN_ERR,
+				"Cannot change journaled quota options when quota turned on");
 			return -1;
 		}
 		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					       EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 			ext4_msg(sb, KERN_ERR,
-				 "Cannot set journaled quota options "
-				 "when QUOTA feature is enabled");
+				 "Cannot set journaled quota options when QUOTA feature is enabled");
 			return -1;
 		}
 		sbi->s_jquota_fmt = m->mount_opt;
@@ -1684,8 +1678,8 @@ static int parse_options(char *options, struct super_block *sb,
 #ifdef CONFIG_QUOTA
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
 	    (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
-		ext4_msg(sb, KERN_ERR, "Cannot set quota options when QUOTA "
-			 "feature is enabled");
+		ext4_msg(sb, KERN_ERR,
+			"Cannot set quota options when QUOTA feature is enabled");
 		return 0;
 	}
 	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
@@ -1696,14 +1690,14 @@ static int parse_options(char *options, struct super_block *sb,
 			clear_opt(sb, GRPQUOTA);
 
 		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
-			ext4_msg(sb, KERN_ERR, "old and new quota "
-					"format mixing");
+			ext4_msg(sb, KERN_ERR,
+				"old and new quota format mixing");
 			return 0;
 		}
 
 		if (!sbi->s_jquota_fmt) {
-			ext4_msg(sb, KERN_ERR, "journaled quota format "
-					"not specified");
+			ext4_msg(sb, KERN_ERR,
+				"journaled quota format not specified");
 			return 0;
 		}
 	}
@@ -1713,15 +1707,15 @@ static int parse_options(char *options, struct super_block *sb,
 			BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
 		if (blocksize < PAGE_CACHE_SIZE) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "dioread_nolock if block size != PAGE_SIZE");
+			ext4_msg(sb, KERN_ERR,
+				"can't mount with dioread_nolock if block size != PAGE_SIZE");
 			return 0;
 		}
 	}
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA &&
 	    test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
-		ext4_msg(sb, KERN_ERR, "can't mount with journal_async_commit "
-			 "in data=ordered mode");
+		ext4_msg(sb, KERN_ERR,
+			"can't mount with journal_async_commit in data=ordered mode");
 		return 0;
 	}
 	return 1;
@@ -1790,6 +1784,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 
 	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
 		int want_set = m->flags & MOPT_SET;
+
 		if (((m->flags & (MOPT_SET|MOPT_CLEAR)) == 0) ||
 		    (m->flags & MOPT_CLEAR_ERR))
 			continue;
@@ -1886,31 +1881,26 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	int res = 0;
 
 	if (le32_to_cpu(es->s_rev_level) > EXT4_MAX_SUPP_REV) {
-		ext4_msg(sb, KERN_ERR, "revision level too high, "
-			 "forcing read-only mode");
+		ext4_msg(sb, KERN_ERR, "revision level too high, forcing read-only mode");
 		res = MS_RDONLY;
 	}
 	if (read_only)
 		goto done;
 	if (!(sbi->s_mount_state & EXT4_VALID_FS))
-		ext4_msg(sb, KERN_WARNING, "warning: mounting unchecked fs, "
-			 "running e2fsck is recommended");
+		ext4_msg(sb, KERN_WARNING, "warning: mounting unchecked fs, running e2fsck is recommended");
 	else if (sbi->s_mount_state & EXT4_ERROR_FS)
 		ext4_msg(sb, KERN_WARNING,
-			 "warning: mounting fs with errors, "
-			 "running e2fsck is recommended");
+			 "warning: mounting fs with errors, running e2fsck is recommended");
 	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) > 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
 		ext4_msg(sb, KERN_WARNING,
-			 "warning: maximal mount count reached, "
-			 "running e2fsck is recommended");
+			 "warning: maximal mount count reached, running e2fsck is recommended");
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
 			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
 		ext4_msg(sb, KERN_WARNING,
-			 "warning: checktime reached, "
-			 "running e2fsck is recommended");
+			 "warning: checktime reached, running e2fsck is recommended");
 	if (!sbi->s_journal)
 		es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
@@ -1924,8 +1914,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	ext4_commit_super(sb, 1);
 done:
 	if (test_opt(sb, DEBUG))
-		printk(KERN_INFO "[EXT4 FS bs=%lu, gc=%u, "
-				"bpg=%lu, ipg=%lu, mo=%04x, mo2=%04x]\n",
+		printk(KERN_INFO "[EXT4 FS bs=%lu, gc=%u, bpg=%lu, ipg=%lu, mo=%04x, mo2=%04x]\n",
 			sb->s_blocksize,
 			sbi->s_groups_count,
 			EXT4_BLOCKS_PER_GROUP(sb),
@@ -2101,30 +2090,26 @@ static int ext4_check_descriptors(struct super_block *sb,
 
 		block_bitmap = ext4_block_bitmap(sb, gdp);
 		if (block_bitmap < first_block || block_bitmap > last_block) {
-			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-			       "Block bitmap for group %u not in group "
-			       "(block %llu)!", i, block_bitmap);
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: Block bitmap for group %u not in group (block %llu)!",
+				 i, block_bitmap);
 			return 0;
 		}
 		inode_bitmap = ext4_inode_bitmap(sb, gdp);
 		if (inode_bitmap < first_block || inode_bitmap > last_block) {
-			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-			       "Inode bitmap for group %u not in group "
-			       "(block %llu)!", i, inode_bitmap);
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: Inode bitmap for group %u not in group (block %llu)!",
+				i, inode_bitmap);
 			return 0;
 		}
 		inode_table = ext4_inode_table(sb, gdp);
 		if (inode_table < first_block ||
 		    inode_table + sbi->s_itb_per_group - 1 > last_block) {
-			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-			       "Inode table for group %u not in group "
-			       "(block %llu)!", i, inode_table);
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: Inode table for group %u not in group (block %llu)!",
+				i, inode_table);
 			return 0;
 		}
 		ext4_lock_group(sb, i);
 		if (!ext4_group_desc_csum_verify(sb, i, gdp)) {
-			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-				 "Checksum for group %u failed (%u!=%u)",
+			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: Checksum for group %u failed (%u!=%u)",
 				 i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
 				     gdp)), le16_to_cpu(gdp->bg_checksum));
 			if (!(sb->s_flags & MS_RDONLY)) {
@@ -2172,23 +2157,20 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 	}
 
 	if (bdev_read_only(sb->s_bdev)) {
-		ext4_msg(sb, KERN_ERR, "write access "
-			"unavailable, skipping orphan cleanup");
+		ext4_msg(sb, KERN_ERR, "write access unavailable, skipping orphan cleanup");
 		return;
 	}
 
 	/* Check if feature set would not allow a r/w mount */
 	if (!ext4_feature_set_ok(sb, 0)) {
-		ext4_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
-			 "unknown ROCOMPAT features");
+		ext4_msg(sb, KERN_INFO, "Skipping orphan cleanup due to unknown ROCOMPAT features");
 		return;
 	}
 
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 		/* don't clear list on RO mount w/ errors */
 		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
-			ext4_msg(sb, KERN_INFO, "Errors on filesystem, "
-				  "clearing orphan list.\n");
+			ext4_msg(sb, KERN_INFO, "Errors on filesystem, clearing orphan list.\n");
 			es->s_last_orphan = 0;
 		}
 		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
@@ -2206,10 +2188,11 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
 		if (EXT4_SB(sb)->s_qf_names[i]) {
 			int ret = ext4_quota_on_mount(sb, i);
+
 			if (ret < 0)
 				ext4_msg(sb, KERN_ERR,
-					"Cannot turn on journaled "
-					"quota: error %d", ret);
+					"Cannot turn on journaled quota: error %d",
+					ret);
 		}
 	}
 #endif
@@ -2598,7 +2581,7 @@ static ssize_t sbi_deprecated_show(struct ext4_attr *a,
 	return snprintf(buf, PAGE_SIZE, "%d\n", a->u.deprecated_val);
 }
 
-#define EXT4_ATTR_OFFSET(_name,_mode,_show,_store,_elname) \
+#define EXT4_ATTR_OFFSET(_name, _mode, _show, _store, _elname) \
 static struct ext4_attr ext4_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
@@ -2608,7 +2591,7 @@ static struct ext4_attr ext4_attr_##_name = {			\
 	},							\
 }
 
-#define EXT4_ATTR_OFFSET_ES(_name,_mode,_show,_store,_elname)		\
+#define EXT4_ATTR_OFFSET_ES(_name, _mode, _show, _store, _elname)	\
 static struct ext4_attr ext4_attr_##_name = {				\
 	.attr = {.name = __stringify(_name), .mode = _mode },		\
 	.show	= _show,						\
@@ -2782,8 +2765,7 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 {
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT4_FEATURE_INCOMPAT_SUPP)) {
 		ext4_msg(sb, KERN_ERR,
-			"Couldn't mount because of "
-			"unsupported optional features (%x)",
+			"Couldn't mount because of unsupported optional features (%x)",
 			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) &
 			~EXT4_FEATURE_INCOMPAT_SUPP));
 		return 0;
@@ -2794,8 +2776,7 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 
 	/* Check that feature set is OK for a read-write mount */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP)) {
-		ext4_msg(sb, KERN_ERR, "couldn't mount RDWR because of "
-			 "unsupported optional features (%x)",
+		ext4_msg(sb, KERN_ERR, "couldn't mount RDWR because of unsupported optional features (%x)",
 			 (le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) &
 				~EXT4_FEATURE_RO_COMPAT_SUPP));
 		return 0;
@@ -2806,17 +2787,14 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 	 */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
 		if (sizeof(blkcnt_t) < sizeof(u64)) {
-			ext4_msg(sb, KERN_ERR, "Filesystem with huge files "
-				 "cannot be mounted RDWR without "
-				 "CONFIG_LBDAF");
+			ext4_msg(sb, KERN_ERR, "Filesystem with huge files cannot be mounted RDWR without CONFIG_LBDAF");
 			return 0;
 		}
 	}
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
 	    !EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		ext4_msg(sb, KERN_ERR,
-			 "Can't support bigalloc feature without "
-			 "extents feature\n");
+			 "Can't support bigalloc feature without extents feature\n");
 		return 0;
 	}
 
@@ -2824,8 +2802,7 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
 	    !readonly) {
 		ext4_msg(sb, KERN_ERR,
-			 "Filesystem with quota feature cannot be mounted RDWR "
-			 "without CONFIG_QUOTA");
+			 "Filesystem with quota feature cannot be mounted RDWR without CONFIG_QUOTA");
 		return 0;
 	}
 #endif  /* CONFIG_QUOTA */
@@ -3064,12 +3041,12 @@ static int ext4_run_lazyinit_thread(void)
 					 ext4_li_info, "ext4lazyinit");
 	if (IS_ERR(ext4_lazyinit_task)) {
 		int err = PTR_ERR(ext4_lazyinit_task);
+
 		ext4_clear_request_list();
 		kfree(ext4_li_info);
 		ext4_li_info = NULL;
-		printk(KERN_CRIT "EXT4-fs: error %d creating inode table "
-				 "initialization thread\n",
-				 err);
+		printk(KERN_CRIT "EXT4-fs: error %d creating inode table initialization thread\n",
+			err);
 		return err;
 	}
 	ext4_li_info->li_state |= EXT4_LAZYINIT_RUNNING;
@@ -3498,13 +3475,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
 	    EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		ext4_warning(sb, "metadata_csum and uninit_bg are "
-			     "redundant flags; please run fsck.");
+		ext4_warning(sb, "metadata_csum and uninit_bg are redundant flags; please run fsck.");
 
 	/* Check for a known checksum algorithm */
 	if (!ext4_verify_csum_type(sb, es)) {
-		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
-			 "unknown checksum algorithm.");
+		ext4_msg(sb, KERN_ERR,
+			"VFS: Found ext4 filesystem with unknown checksum algorithm.");
 		silent = 1;
 		goto cantfind_ext4;
 	}
@@ -3523,8 +3499,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Check superblock checksum */
 	if (!ext4_superblock_csum_verify(sb, es)) {
-		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
-			 "invalid superblock checksum.  Run e2fsck?");
+		ext4_msg(sb, KERN_ERR,
+			"VFS: Found ext4 filesystem with invalid superblock checksum.  Run e2fsck?");
 		silent = 1;
 		goto cantfind_ext4;
 	}
@@ -3605,22 +3581,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
-			    "with data=journal disables delayed "
-			    "allocation and O_DIRECT support!\n");
+		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!\n");
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+			ext4_msg(sb, KERN_ERR, "can't mount with both data=journal and delalloc");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and dioread_nolock");
+			ext4_msg(sb, KERN_ERR, "can't mount with both data=journal and dioread_nolock");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DAX)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and dax");
+			ext4_msg(sb, KERN_ERR, "can't mount with both data=journal and dax");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -3635,8 +3606,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT4_HAS_INCOMPAT_FEATURE(sb, ~0U)))
 		ext4_msg(sb, KERN_WARNING,
-		       "feature flags set on rev 0 fs, "
-		       "running e2fsck is recommended");
+		       "feature flags set on rev 0 fs, running e2fsck is recommended");
 
 	if (es->s_creator_os == cpu_to_le32(EXT4_OS_HURD)) {
 		set_opt2(sb, HURD_COMPAT);
@@ -3650,22 +3620,22 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (IS_EXT2_SB(sb)) {
 		if (ext2_feature_set_ok(sb))
-			ext4_msg(sb, KERN_INFO, "mounting ext2 file system "
-				 "using the ext4 subsystem");
+			ext4_msg(sb, KERN_INFO,
+				"mounting ext2 file system using the ext4 subsystem");
 		else {
-			ext4_msg(sb, KERN_ERR, "couldn't mount as ext2 due "
-				 "to feature incompatibilities");
+			ext4_msg(sb, KERN_ERR,
+				"couldn't mount as ext2 due to feature incompatibilities");
 			goto failed_mount;
 		}
 	}
 
 	if (IS_EXT3_SB(sb)) {
 		if (ext3_feature_set_ok(sb))
-			ext4_msg(sb, KERN_INFO, "mounting ext3 file system "
-				 "using the ext4 subsystem");
+			ext4_msg(sb, KERN_INFO,
+				"mounting ext3 file system using the ext4 subsystem");
 		else {
-			ext4_msg(sb, KERN_ERR, "couldn't mount as ext3 due "
-				 "to feature incompatibilities");
+			ext4_msg(sb, KERN_ERR,
+				"couldn't mount as ext3 due to feature incompatibilities");
 			goto failed_mount;
 		}
 	}
@@ -3806,8 +3776,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (has_bigalloc) {
 		if (clustersize < blocksize) {
 			ext4_msg(sb, KERN_ERR,
-				 "cluster size (%d) smaller than "
-				 "block size (%d)", clustersize, blocksize);
+				"cluster size (%d) smaller than block size (%d)",
+				clustersize, blocksize);
 			goto failed_mount;
 		}
 		sbi->s_cluster_bits = le32_to_cpu(es->s_log_cluster_size) -
@@ -3822,17 +3792,18 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		if (sbi->s_blocks_per_group !=
 		    (sbi->s_clusters_per_group * (clustersize / blocksize))) {
-			ext4_msg(sb, KERN_ERR, "blocks per group (%lu) and "
-				 "clusters per group (%lu) inconsistent",
-				 sbi->s_blocks_per_group,
-				 sbi->s_clusters_per_group);
+			ext4_msg(sb, KERN_ERR,
+				"blocks per group (%lu) and clusters per group (%lu) inconsistent",
+				sbi->s_blocks_per_group,
+				sbi->s_clusters_per_group);
 			goto failed_mount;
 		}
 	} else {
 		if (clustersize != blocksize) {
-			ext4_warning(sb, "fragment/cluster size (%d) != "
-				     "block size (%d)", clustersize,
-				     blocksize);
+			ext4_warning(sb,
+				"fragment/cluster size (%d) != block size (%d)",
+				clustersize,
+				blocksize);
 			clustersize = blocksize;
 		}
 		if (sbi->s_blocks_per_group > blocksize * 8) {
@@ -3864,8 +3835,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	err = generic_check_addressable(sb->s_blocksize_bits,
 					ext4_blocks_count(es));
 	if (err) {
-		ext4_msg(sb, KERN_ERR, "filesystem"
-			 " too large to mount safely on this system");
+		ext4_msg(sb, KERN_ERR, "filesystem too large to mount safely on this system");
 		if (sizeof(sector_t) < 8)
 			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
 		goto failed_mount;
@@ -3877,9 +3847,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	/* check blocks count against device size */
 	blocks_count = sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
 	if (blocks_count && ext4_blocks_count(es) > blocks_count) {
-		ext4_msg(sb, KERN_WARNING, "bad geometry: block count %llu "
-		       "exceeds size of device (%llu blocks)",
-		       ext4_blocks_count(es), blocks_count);
+		ext4_msg(sb, KERN_WARNING,
+			"bad geometry: block count %llu exceeds size of device (%llu blocks)",
+			ext4_blocks_count(es), blocks_count);
 		goto failed_mount;
 	}
 
@@ -3888,8 +3858,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * of the filesystem.
 	 */
 	if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
-		ext4_msg(sb, KERN_WARNING, "bad geometry: first data "
-			 "block %u is beyond end of filesystem (%llu)",
+		ext4_msg(sb, KERN_WARNING, "bad geometry: first data block %u is beyond end of filesystem (%llu)",
 			 le32_to_cpu(es->s_first_data_block),
 			 ext4_blocks_count(es));
 		goto failed_mount;
@@ -3899,12 +3868,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
 	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
-		ext4_msg(sb, KERN_WARNING, "groups count too large: %u "
-		       "(block count %llu, first data block %u, "
-		       "blocks per group %lu)", sbi->s_groups_count,
-		       ext4_blocks_count(es),
-		       le32_to_cpu(es->s_first_data_block),
-		       EXT4_BLOCKS_PER_GROUP(sb));
+		ext4_msg(sb, KERN_WARNING,
+			"groups count too large: %u (block count %llu, first data block %u, blocks per group %lu)",
+			sbi->s_groups_count,
+			ext4_blocks_count(es),
+			le32_to_cpu(es->s_first_data_block),
+			EXT4_BLOCKS_PER_GROUP(sb));
 		goto failed_mount;
 	}
 	sbi->s_groups_count = blocks_count;
@@ -4000,8 +3969,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			goto failed_mount3a;
 	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
 	      EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
-		ext4_msg(sb, KERN_ERR, "required journal recovery "
-		       "suppressed and not mounted read-only");
+		ext4_msg(sb, KERN_ERR,
+			"required journal recovery suppressed and not mounted read-only");
 		goto failed_mount_wq;
 	} else {
 		clear_opt(sb, DATA_FLAGS);
@@ -4018,8 +3987,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (!set_journal_csum_feature_set(sb)) {
-		ext4_msg(sb, KERN_ERR, "Failed to set journal checksum "
-			 "feature set");
+		ext4_msg(sb, KERN_ERR,
+			"Failed to set journal checksum feature set");
 		goto failed_mount_wq;
 	}
 
@@ -4042,8 +4011,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	case EXT4_MOUNT_WRITEBACK_DATA:
 		if (!jbd2_journal_check_available_features
 		    (sbi->s_journal, 0, 0, JBD2_FEATURE_INCOMPAT_REVOKE)) {
-			ext4_msg(sb, KERN_ERR, "Journal does not support "
-			       "requested data journaling mode");
+			ext4_msg(sb, KERN_ERR,
+				"Journal does not support requested data journaling mode");
 			goto failed_mount_wq;
 		}
 	default:
@@ -4134,21 +4103,21 @@ no_journal:
 							sbi->s_inode_size) {
 		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
 						       EXT4_GOOD_OLD_INODE_SIZE;
-		ext4_msg(sb, KERN_INFO, "required extra inode space not"
-			 "available");
+		ext4_msg(sb, KERN_INFO, "required extra inode space not available");
 	}
 
 	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sb));
 	if (err) {
-		ext4_msg(sb, KERN_ERR, "failed to reserve %llu clusters for "
-			 "reserved pool", ext4_calculate_resv_clusters(sb));
+		ext4_msg(sb, KERN_ERR,
+			"failed to reserve %llu clusters for reserved pool",
+			ext4_calculate_resv_clusters(sb));
 		goto failed_mount4a;
 	}
 
 	err = ext4_setup_system_zone(sb);
 	if (err) {
-		ext4_msg(sb, KERN_ERR, "failed to initialize system "
-			 "zone (%d)", err);
+		ext4_msg(sb, KERN_ERR,
+			"failed to initialize system zone (%d)", err);
 		goto failed_mount4a;
 	}
 
@@ -4161,7 +4130,7 @@ no_journal:
 	}
 
 	block = ext4_count_free_clusters(sb);
-	ext4_free_blocks_count_set(sbi->s_es, 
+	ext4_free_blocks_count_set(sbi->s_es,
 				   EXT4_C2B(sbi, block));
 	err = percpu_counter_init(&sbi->s_freeclusters_counter, block,
 				  GFP_KERNEL);
@@ -4185,8 +4154,7 @@ no_journal:
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
 		if (!ext4_fill_flex_info(sb)) {
 			ext4_msg(sb, KERN_ERR,
-			       "unable to initialize "
-			       "flex_bg meta info!");
+			       "unable to initialize flex_bg meta info!");
 			goto failed_mount6;
 		}
 
@@ -4232,12 +4200,11 @@ no_journal:
 		struct request_queue *q = bdev_get_queue(sb->s_bdev);
 		if (!blk_queue_discard(q))
 			ext4_msg(sb, KERN_WARNING,
-				 "mounting with \"discard\" option, but "
-				 "the device does not support discard");
+				 "mounting with \"discard\" option, but the device does not support discard");
 	}
 
-	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
-		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
+	ext4_msg(sb, KERN_INFO,
+		"mounted filesystem with%s. Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
 		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
 
 	if (es->s_error_count)
@@ -4416,8 +4383,8 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	offset = EXT4_MIN_BLOCK_SIZE % blocksize;
 	set_blocksize(bdev, blocksize);
 	if (!(bh = __bread(bdev, sb_block, blocksize))) {
-		ext4_msg(sb, KERN_ERR, "couldn't read superblock of "
-		       "external journal");
+		ext4_msg(sb, KERN_ERR,
+			"couldn't read superblock of external journal");
 		goto out_bdev;
 	}
 
@@ -4425,8 +4392,8 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	if ((le16_to_cpu(es->s_magic) != EXT4_SUPER_MAGIC) ||
 	    !(le32_to_cpu(es->s_feature_incompat) &
 	      EXT4_FEATURE_INCOMPAT_JOURNAL_DEV)) {
-		ext4_msg(sb, KERN_ERR, "external journal has "
-					"bad superblock");
+		ext4_msg(sb, KERN_ERR,
+			"external journal has bad superblock");
 		brelse(bh);
 		goto out_bdev;
 	}
@@ -4434,8 +4401,8 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	if ((le32_to_cpu(es->s_feature_ro_compat) &
 	     EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
 	    es->s_checksum != ext4_superblock_csum(sb, es)) {
-		ext4_msg(sb, KERN_ERR, "external journal has "
-				       "corrupt superblock");
+		ext4_msg(sb, KERN_ERR,
+			"external journal has corrupt superblock");
 		brelse(bh);
 		goto out_bdev;
 	}
@@ -4464,8 +4431,8 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 		goto out_journal;
 	}
 	if (be32_to_cpu(journal->j_superblock->s_nr_users) != 1) {
-		ext4_msg(sb, KERN_ERR, "External journal has more than one "
-					"user (unsupported) - %d",
+		ext4_msg(sb, KERN_ERR,
+			"External journal has more than one user (unsupported) - %d",
 			be32_to_cpu(journal->j_superblock->s_nr_users));
 		goto out_journal;
 	}
@@ -4494,8 +4461,8 @@ static int ext4_load_journal(struct super_block *sb,
 
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
-		ext4_msg(sb, KERN_INFO, "external journal device major/minor "
-			"numbers have changed");
+		ext4_msg(sb, KERN_INFO,
+			"external journal device major/minor numbers have changed");
 		journal_dev = new_decode_dev(journal_devnum);
 	} else
 		journal_dev = new_decode_dev(le32_to_cpu(es->s_journal_dev));
@@ -4509,21 +4476,21 @@ static int ext4_load_journal(struct super_block *sb,
 	 */
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
 		if (sb->s_flags & MS_RDONLY) {
-			ext4_msg(sb, KERN_INFO, "INFO: recovery "
-					"required on readonly filesystem");
+			ext4_msg(sb, KERN_INFO,
+				"INFO: recovery required on readonly filesystem");
 			if (really_read_only) {
-				ext4_msg(sb, KERN_ERR, "write access "
-					"unavailable, cannot proceed");
+				ext4_msg(sb, KERN_ERR,
+					"write access unavailable, cannot proceed");
 				return -EROFS;
 			}
-			ext4_msg(sb, KERN_INFO, "write access will "
-			       "be enabled during recovery");
+			ext4_msg(sb, KERN_INFO,
+				"write access will be enabled during recovery");
 		}
 	}
 
 	if (journal_inum && journal_dev) {
-		ext4_msg(sb, KERN_ERR, "filesystem has both journal "
-		       "and inode journals!");
+		ext4_msg(sb, KERN_ERR,
+			"filesystem has both journal and inode journals!");
 		return -EINVAL;
 	}
 
@@ -4589,8 +4556,8 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 		 * be remapped.  Nothing we can do but to retry the
 		 * write and hope for the best.
 		 */
-		ext4_msg(sb, KERN_ERR, "previous I/O error to "
-		       "superblock detected");
+		ext4_msg(sb, KERN_ERR,
+			"previous I/O error to superblock detected");
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
@@ -4632,8 +4599,8 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 
 		error = buffer_write_io_error(sbh);
 		if (error) {
-			ext4_msg(sb, KERN_ERR, "I/O error while writing "
-			       "superblock");
+			ext4_msg(sb, KERN_ERR,
+				"I/O error while writing superblock");
 			clear_buffer_write_io_error(sbh);
 			set_buffer_uptodate(sbh);
 		}
@@ -4695,8 +4662,9 @@ static void ext4_clear_journal_err(struct super_block *sb,
 		char nbuf[16];
 
 		errstr = ext4_decode_error(sb, j_errno, nbuf);
-		ext4_warning(sb, "Filesystem error recorded "
-			     "from previous mount: %s", errstr);
+		ext4_warning(sb,
+			"Filesystem error recorded from previous mount: %s",
+			errstr);
 		ext4_warning(sb, "Marking fs in need of filesystem check.");
 
 		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
@@ -4889,30 +4857,30 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
-		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
-			 "during remount not supported");
+		ext4_msg(sb, KERN_ERR,
+			"changing journal_checksum during remount not supported");
 		err = -EINVAL;
 		goto restore_opts;
 	}
 
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
-		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
-			 "during remount not supported");
+		ext4_msg(sb, KERN_ERR,
+			"changing journal_checksum during remount not supported");
 		err = -EINVAL;
 		goto restore_opts;
 	}
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+			ext4_msg(sb, KERN_ERR,
+				"can't mount with both data=journal and delalloc");
 			err = -EINVAL;
 			goto restore_opts;
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and dioread_nolock");
+			ext4_msg(sb, KERN_ERR,
+				"can't mount with both data=journal and dioread_nolock");
 			err = -EINVAL;
 			goto restore_opts;
 		}
@@ -5004,10 +4972,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			 * require a full umount/remount for now.
 			 */
 			if (es->s_last_orphan) {
-				ext4_msg(sb, KERN_WARNING, "Couldn't "
-				       "remount RDWR because of unprocessed "
-				       "orphan inode list.  Please "
-				       "umount/remount instead");
+				ext4_msg(sb, KERN_WARNING,
+					"Couldn't remount RDWR because of unprocessed orphan inode list.  Please umount/remount instead");
 				err = -EINVAL;
 				goto restore_opts;
 			}
@@ -5256,8 +5222,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 		/* Quotafile not in fs root? */
 		if (path->dentry->d_parent != sb->s_root)
 			ext4_msg(sb, KERN_WARNING,
-				"Quota file not on filesystem root. "
-				"Journaled quota will not work");
+				"Quota file not on filesystem root. Journaled quota will not work");
 	}
 
 	/*
@@ -5325,9 +5290,8 @@ static int ext4_enable_quotas(struct super_block *sb)
 						DQUOT_USAGE_ENABLED);
 			if (err) {
 				ext4_warning(sb,
-					"Failed to enable quota tracking "
-					"(type=%d, err=%d). Please run "
-					"e2fsck to fix.", type, err);
+					"Failed to enable quota tracking (type=%d, err=%d). Please run e2fsck to fix.",
+					 type, err);
 				return err;
 			}
 		}
@@ -5439,8 +5403,8 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	handle_t *handle = journal_current_handle();
 
 	if (EXT4_SB(sb)->s_journal && !handle) {
-		ext4_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
-			" cancelled because transaction is not started",
+		ext4_msg(sb, KERN_WARNING,
+			"Quota write (off=%llu, len=%llu) cancelled because transaction is not started",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
@@ -5449,8 +5413,8 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	 * then it is impossible to cross a block boundary.
 	 */
 	if (sb->s_blocksize - offset < len) {
-		ext4_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
-			" cancelled because not block aligned",
+		ext4_msg(sb, KERN_WARNING,
+			"Quota write (off=%llu, len=%llu) cancelled because not block aligned",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
@@ -5493,6 +5457,7 @@ static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 static inline void register_as_ext2(void)
 {
 	int err = register_filesystem(&ext2_fs_type);
+
 	if (err)
 		printk(KERN_WARNING
 		       "EXT4-fs: Unable to register as ext2 (%d)\n", err);
@@ -5523,6 +5488,7 @@ static inline int ext2_feature_set_ok(struct super_block *sb) { return 0; }
 static inline void register_as_ext3(void)
 {
 	int err = register_filesystem(&ext3_fs_type);
+
 	if (err)
 		printk(KERN_WARNING
 		       "EXT4-fs: Unable to register as ext3 (%d)\n", err);
-- 
1.9.1

