From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] ext4/super.c whitespace cleanup
Date: Mon, 25 May 2009 11:23:25 -0600
Message-ID: <20090525172325.GE19035@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46191 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZEYRXk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 May 2009 13:23:40 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4PHNb8X017717
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2009 10:23:37 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KK700100MXA5200@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 25 May 2009 10:23:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cleanup of whitespace and formatting.  Initially driven by confusing indents
for the ext4_{block,inode}_bitmap() et. al. helper routines, but figured I'd
cleanup some other 80-column wrapping and other indenting problems at the
same time.

Signed-off-by: Andreas Dilger <adilger@sun.com>

=============================================================================
--- ./fs/ext4/super.c.orig	2009-04-08 19:13:13.000000000 -0600
+++ ./fs/ext4/super.c	2009-05-25 11:14:54.000000000 -0600
@@ -72,7 +72,7 @@ ext4_fsblk_t ext4_block_bitmap(struct su
 {
 	return le32_to_cpu(bg->bg_block_bitmap_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		(ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32 : 0);
+		 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32 : 0);
 }
 
 ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
@@ -80,7 +80,7 @@ ext4_fsblk_t ext4_inode_bitmap(struct su
 {
 	return le32_to_cpu(bg->bg_inode_bitmap_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		(ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32 : 0);
+		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32 : 0);
 }
 
 ext4_fsblk_t ext4_inode_table(struct super_block *sb,
@@ -88,7 +88,7 @@ ext4_fsblk_t ext4_inode_table(struct sup
 {
 	return le32_to_cpu(bg->bg_inode_table_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		(ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0);
+		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0);
 }
 
 __u32 ext4_free_blks_count(struct super_block *sb,
@@ -96,7 +96,7 @@ __u32 ext4_free_blks_count(struct super_
 {
 	return le16_to_cpu(bg->bg_free_blocks_count_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		(__u32)le16_to_cpu(bg->bg_free_blocks_count_hi) << 16 : 0);
+		 (__u32)le16_to_cpu(bg->bg_free_blocks_count_hi) << 16 : 0);
 }
 
 __u32 ext4_free_inodes_count(struct super_block *sb,
@@ -104,7 +104,7 @@ __u32 ext4_free_inodes_count(struct supe
 {
 	return le16_to_cpu(bg->bg_free_inodes_count_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		(__u32)le16_to_cpu(bg->bg_free_inodes_count_hi) << 16 : 0);
+		 (__u32)le16_to_cpu(bg->bg_free_inodes_count_hi) << 16 : 0);
 }
 
 __u32 ext4_used_dirs_count(struct super_block *sb,
@@ -112,7 +112,7 @@ __u32 ext4_used_dirs_count(struct super_
 {
 	return le16_to_cpu(bg->bg_used_dirs_count_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		(__u32)le16_to_cpu(bg->bg_used_dirs_count_hi) << 16 : 0);
+		 (__u32)le16_to_cpu(bg->bg_used_dirs_count_hi) << 16 : 0);
 }
 
 __u32 ext4_itable_unused_count(struct super_block *sb,
@@ -120,7 +120,7 @@ __u32 ext4_itable_unused_count(struct su
 {
 	return le16_to_cpu(bg->bg_itable_unused_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		(__u32)le16_to_cpu(bg->bg_itable_unused_hi) << 16 : 0);
+		 (__u32)le16_to_cpu(bg->bg_itable_unused_hi) << 16 : 0);
 }
 
 void ext4_block_bitmap_set(struct super_block *sb,
@@ -200,8 +200,7 @@ handle_t *ext4_journal_start_sb(struct s
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
 		if (is_journal_aborted(journal)) {
-			ext4_abort(sb, __func__,
-				   "Detected aborted journal");
+			ext4_abort(sb, __func__, "Detected aborted journal");
 			return ERR_PTR(-EROFS);
 		}
 		return jbd2_journal_start(journal, nblocks);
@@ -429,7 +428,7 @@ void ext4_warning(struct super_block *sb
 }
 
 void ext4_grp_locked_error(struct super_block *sb, ext4_group_t grp,
-				const char *function, const char *fmt, ...)
+			   const char *function, const char *fmt, ...)
 __releases(bitlock)
 __acquires(bitlock)
 {
@@ -465,7 +464,6 @@ __acquires(bitlock)
 	return;
 }
 
-
 void ext4_update_dynamic_rev(struct super_block *sb)
 {
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
@@ -616,7 +614,6 @@ static void ext4_put_super(struct super_
 	}
 	sb->s_fs_info = NULL;
 	kfree(sbi);
-	return;
 }
 
 static struct kmem_cache *ext4_inode_cachep;
@@ -631,6 +628,7 @@ static struct inode *ext4_alloc_inode(st
 	ei = kmem_cache_alloc(ext4_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
+
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	ei->i_acl = EXT4_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT4_ACL_NOT_CACHED;
@@ -651,6 +649,7 @@ static struct inode *ext4_alloc_inode(st
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
+
 	return &ei->vfs_inode;
 }
 
@@ -856,12 +855,12 @@ static int ext4_show_options(struct seq_
 		seq_puts(seq, ",data_err=abort");
 
 	ext4_show_quota_options(seq, sb);
+
 	return 0;
 }
 
-
 static struct inode *ext4_nfs_get_inode(struct super_block *sb,
-		u64 ino, u32 generation)
+					u64 ino, u32 generation)
 {
 	struct inode *inode;
 
@@ -890,14 +889,14 @@ static struct inode *ext4_nfs_get_inode(
 }
 
 static struct dentry *ext4_fh_to_dentry(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type)
+					int fh_len, int fh_type)
 {
 	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
 				    ext4_nfs_get_inode);
 }
 
 static struct dentry *ext4_fh_to_parent(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type)
+					int fh_len, int fh_type)
 {
 	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
 				    ext4_nfs_get_inode);
@@ -909,7 +908,8 @@ static struct dentry *ext4_fh_to_parent(
  * which would prevent try_to_free_buffers() from freeing them, we must use
  * jbd2 layer's try_to_free_buffers() function to release them.
  */
-static int bdev_try_to_free_page(struct super_block *sb, struct page *page, gfp_t wait)
+static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
+				 gfp_t wait)
 {
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 
@@ -1083,8 +1083,9 @@ static ext4_fsblk_t get_sb_block(void **
 
 	if (!options || strncmp(options, "sb=", 3) != 0)
 		return 1;	/* Default location */
+
 	options += 3;
-	/*todo: use simple_strtoll with >32bit ext4 */
+	/* TODO: use simple_strtoll with >32bit ext4 */
 	sb_block = simple_strtoul(options, &options, 0);
 	if (*options && *options != ',') {
 		printk(KERN_ERR "EXT4-fs: Invalid sb specification: %s\n",
@@ -1094,6 +1095,7 @@ static ext4_fsblk_t get_sb_block(void **
 	if (*options == ',')
 		options++;
 	*data = (void *) options;
+
 	return sb_block;
 }
 
@@ -1546,7 +1548,7 @@ static int ext4_setup_super(struct super
 		printk(KERN_WARNING
 		       "EXT4-fs warning: checktime reached, "
 		       "running e2fsck is recommended\n");
-	if (!sbi->s_journal) 
+	if (!sbi->s_journal)
 		es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT4_DFL_MAX_MNT_COUNT);
@@ -1723,7 +1725,7 @@ static int ext4_check_descriptors(struct
 	}
 
 	ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb));
-	sbi->s_es->s_free_inodes_count = cpu_to_le32(ext4_count_free_inodes(sb));
+	sbi->s_es->s_free_inodes_count =cpu_to_le32(ext4_count_free_inodes(sb));
 	return 1;
 }
 
@@ -1839,6 +1841,7 @@ static void ext4_orphan_cleanup(struct s
 #endif
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
 }
+
 /*
  * Maximal extent format file size.
  * Resulting logical blkno at s_maxbytes must fit in our on-disk
@@ -1889,19 +1892,19 @@ static loff_t ext4_max_bitmap_size(int b
 	loff_t res = EXT4_NDIR_BLOCKS;
 	int meta_blocks;
 	loff_t upper_limit;
-	/* This is calculated to be the largest file size for a
-	 * dense, bitmapped file such that the total number of
-	 * sectors in the file, including data and all indirect blocks,
-	 * does not exceed 2^48 -1
-	 * __u32 i_blocks_lo and _u16 i_blocks_high representing the
-	 * total number of  512 bytes blocks of the file
+	/* This is calculated to be the largest file size for a dense, block
+	 * mapped file such that the file's total number of 512-byte sectors,
+	 * including data and all indirect blocks, does not exceed (2^48 - 1).
+	 *
+	 * __u32 i_blocks_lo and _u16 i_blocks_high represent the total
+	 * number of 512-byte sectors of the file.
 	 */
 
 	if (!has_huge_files || sizeof(blkcnt_t) < sizeof(u64)) {
 		/*
-		 * !has_huge_files or CONFIG_LBD is not enabled
-		 * implies the inode i_block represent total blocks in
-		 * 512 bytes 32 == size of vfs inode i_blocks * 8
+		 * !has_huge_files or CONFIG_LBD not enabled implies that
+		 * the inode i_block field represents total file blocks in
+		 * 2^32 512-byte sectors == size of vfs inode i_blocks * 8
 		 */
 		upper_limit = (1LL << 32) - 1;
 
@@ -1943,7 +1946,7 @@ static loff_t ext4_max_bitmap_size(int b
 }
 
 static ext4_fsblk_t descriptor_loc(struct super_block *sb,
-				ext4_fsblk_t logical_sb_block, int nr)
+				   ext4_fsblk_t logical_sb_block, int nr)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t bg, first_meta_bg;
@@ -1957,6 +1960,7 @@ static ext4_fsblk_t descriptor_loc(struc
 	bg = sbi->s_desc_per_block * nr;
 	if (ext4_bg_has_super(sb, bg))
 		has_super = 1;
+
 	return (has_super + ext4_group_first_block_no(sb, bg));
 }
 
@@ -1992,7 +1996,6 @@ static unsigned long ext4_get_stripe_siz
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				__releases(kernel_lock)
 				__acquires(kernel_lock)
-
 {
 	struct buffer_head *bh;
 	struct ext4_super_block *es = NULL;
@@ -2108,7 +2111,6 @@ static int ext4_fill_super(struct super_
 	 */
 	set_opt(sbi->s_mount_opt, DELALLOC);
 
-
 	if (!parse_options((char *) data, sb, &journal_devnum,
 			   &journal_ioprio, NULL, 0))
 		goto failed_mount;
@@ -2171,7 +2173,6 @@ static int ext4_fill_super(struct super_
 	}
 
 	if (sb->s_blocksize != blocksize) {
-
 		/* Validate the filesystem blocksize */
 		if (!sb_set_blocksize(sb, blocksize)) {
 			printk(KERN_ERR "EXT4-fs: bad block size %d.\n",
@@ -2218,6 +2219,7 @@ static int ext4_fill_super(struct super_
 		if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE)
 			sb->s_time_gran = 1 << (EXT4_EPOCH_BITS - 2);
 	}
+
 	sbi->s_desc_size = le16_to_cpu(es->s_desc_size);
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT)) {
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
@@ -2230,10 +2232,12 @@ static int ext4_fill_super(struct super_
 		}
 	} else
 		sbi->s_desc_size = EXT4_MIN_DESC_SIZE;
+
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
 	if (EXT4_INODE_SIZE(sb) == 0 || EXT4_INODES_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
+
 	sbi->s_inodes_per_block = blocksize / EXT4_INODE_SIZE(sb);
 	if (sbi->s_inodes_per_block == 0)
 		goto cantfind_ext4;
@@ -2244,6 +2248,7 @@ static int ext4_fill_super(struct super_
 	sbi->s_mount_state = le16_to_cpu(es->s_state);
 	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
+
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
@@ -2286,12 +2291,12 @@ static int ext4_fill_super(struct super_
 	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 
-        /*
-         * It makes no sense for the first data block to be beyond the end
-         * of the filesystem.
-         */
-        if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
-                printk(KERN_WARNING "EXT4-fs: bad geometry: first data"
+	/*
+	 * It makes no sense for the first data block to be beyond the end
+	 * of the filesystem.
+	 */
+	if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
+		printk(KERN_WARNING "EXT4-fs: bad geometry: first data"
 		       "block %u is beyond end of filesystem (%llu)\n",
 		       le32_to_cpu(es->s_first_data_block),
 		       ext4_blocks_count(es));
@@ -2785,6 +2790,7 @@ static journal_t *ext4_get_dev_journal(s
 	EXT4_SB(sb)->journal_bdev = bdev;
 	ext4_init_journal_params(sb, journal);
 	return journal;
+
 out_journal:
 	jbd2_journal_destroy(journal);
 out_bdev:
@@ -2819,7 +2825,6 @@ static int ext4_load_journal(struct supe
 	 * crash?  For recovery, we need to check in advance whether we
 	 * can get read-write access to the device.
 	 */
-
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
 		if (sb->s_flags & MS_RDONLY) {
 			printk(KERN_INFO "EXT4-fs: INFO: recovery "
@@ -2934,7 +2939,6 @@ static int ext4_commit_super(struct supe
 	return error;
 }
 
-
 /*
  * Have we just finished recovery?  If so, and if we are mounting (or
  * remounting) the filesystem readonly, then we will end up with a
@@ -3217,8 +3221,7 @@ static int ext4_remount(struct super_blo
 
 			/*
 			 * Make sure the group descriptor checksums
-			 * are sane.  If they aren't, refuse to
-			 * remount r/w.
+			 * are sane.  If they aren't, refuse to remount r/w.
 			 */
 			for (g = 0; g < sbi->s_groups_count; g++) {
 				struct ext4_group_desc *gdp =
@@ -3276,6 +3279,7 @@ static int ext4_remount(struct super_blo
 			kfree(old_opts.s_qf_names[i]);
 #endif
 	return 0;
+
 restore_opts:
 	sb->s_flags = old_sb_flags;
 	sbi->s_mount_opt = old_opts.s_mount_opt;
@@ -3360,11 +3364,12 @@ static int ext4_statfs(struct dentry *de
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
+
 	return 0;
 }
 
-/* Helper function for writing quotas on sync - we need to start transaction before quota file
- * is locked for write. Otherwise the are possible deadlocks:
+/* Helper function for writing quotas on sync - we need to start transaction
+ * before quota file is locked for write. Otherwise the are possible deadlocks:
  * Process 1                         Process 2
  * ext4_create()                     quota_sync()
  *   jbd2_journal_start()                   write_dquot()
@@ -3426,7 +3431,7 @@ static int ext4_write_dquot(struct dquot
 
 	inode = dquot_to_inode(dquot);
 	handle = ext4_journal_start(inode,
-					EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit(dquot);
@@ -3442,7 +3447,7 @@ static int ext4_acquire_dquot(struct dqu
 	handle_t *handle;
 
 	handle = ext4_journal_start(dquot_to_inode(dquot),
-					EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_acquire(dquot);
@@ -3458,7 +3463,7 @@ static int ext4_release_dquot(struct dqu
 	handle_t *handle;
 
 	handle = ext4_journal_start(dquot_to_inode(dquot),
-					EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
+				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
 	if (IS_ERR(handle)) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
 		dquot_release(dquot);
@@ -3506,7 +3511,7 @@ static int ext4_write_info(struct super_
 static int ext4_quota_on_mount(struct super_block *sb, int type)
 {
 	return vfs_quota_on_mount(sb, EXT4_SB(sb)->s_qf_names[type],
-			EXT4_SB(sb)->s_jquota_fmt, type);
+				  EXT4_SB(sb)->s_jquota_fmt, type);
 }
 
 /*
@@ -3677,10 +3682,10 @@ out:
 
 #endif
 
-static int ext4_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+static int ext4_get_sb(struct file_system_type *fs_type, int flags,
+		       const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data, ext4_fill_super, mnt);
+	return get_sb_bdev(fs_type, flags, dev_name, data, ext4_fill_super,mnt);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -3698,7 +3703,7 @@ static int ext4_ui_proc_open(struct inod
 }
 
 static ssize_t ext4_ui_proc_write(struct file *file, const char __user *buf,
-			       size_t cnt, loff_t *ppos)
+				  size_t cnt, loff_t *ppos)
 {
 	unsigned long *p = PDE(file->f_path.dentry->d_inode)->data;
 	char str[32];
@@ -3731,14 +3736,14 @@ static struct file_system_type ext4_fs_t
 };
 
 #ifdef CONFIG_EXT4DEV_COMPAT
-static int ext4dev_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+static int ext4dev_get_sb(struct file_system_type *fs_type, int flags,
+			  const char *dev_name, void *data,struct vfsmount *mnt)
 {
 	printk(KERN_WARNING "EXT4-fs: Update your userspace programs "
 	       "to mount using ext4\n");
 	printk(KERN_WARNING "EXT4-fs: ext4dev backwards compatibility "
 	       "will go away by 2.6.31\n");
-	return get_sb_bdev(fs_type, flags, dev_name, data, ext4_fill_super, mnt);
+	return get_sb_bdev(fs_type, flags, dev_name, data, ext4_fill_super,mnt);
 }
 
 static struct file_system_type ext4dev_fs_type = {

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

