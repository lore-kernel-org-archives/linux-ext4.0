From: amir73il@users.sourceforge.net
Subject: [PATCH v1 32/36] ext4: snapshot exclude - the exclude bitmap
Date: Tue,  7 Jun 2011 18:07:59 +0300
Message-ID: <1307459283-22130-33-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab1FGPKY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:24 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:23 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Mark all snapshot blocks excluded from COW (i.e., mark that
they do not need to be COWed).  The excluded blocks appear as not
allocated inside the snapshot image (no snapshots of snapshot files).
Excluding snapshot file blocks is essential for efficient cleanup
of deleted snapshot files.
Excluding blocks is done by setting their bit in the exclude bitmap.
There is one exclude bitmap block per block group, which is allocated
on mkfs when setting the exclude_bitmap feature.  The exclude bitmap
location is stored in the group descriptor.
The exclude_bitmap feature is backward compatible, but online resize
support with exclude_bitmap was not yet implemented.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/balloc.c         |  107 ++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h           |   12 ++++-
 fs/ext4/mballoc.c        |   69 +++++++++++++++++++++++
 fs/ext4/resize.c         |    6 ++
 fs/ext4/snapshot.c       |  136 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot.h       |   28 ++++++++++
 fs/ext4/snapshot_ctl.c   |    7 +++
 fs/ext4/snapshot_inode.c |   11 ++++
 fs/ext4/super.c          |   35 ++++++++++++-
 9 files changed, 408 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1c140e4..b1303f2 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -65,6 +65,11 @@ static int ext4_group_used_meta_blocks(struct super_block *sb,
 	/* block bitmap, inode bitmap, and inode table blocks */
 	int used_blocks = sbi->s_itb_per_group + 2;
 
+	if (EXT4_HAS_COMPAT_FEATURE(sb,
+				    EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		/* exclude bitmap */
+		used_blocks += 1;
+
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
 		if (!ext4_block_in_group(sb, ext4_block_bitmap(sb, gdp),
 					block_group))
@@ -157,6 +162,14 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		tmp = ext4_block_bitmap(sb, gdp);
 		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
 			ext4_set_bit(tmp - start, bh->b_data);
+		if (EXT4_HAS_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+			tmp = ext4_exclude_bitmap(sb, gdp);
+			if (!flex_bg ||
+			    ext4_block_in_group(sb, tmp, block_group))
+				ext4_set_bit(tmp - start, bh->b_data);
+		}
+
 		tmp = ext4_inode_bitmap(sb, gdp);
 		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
 			ext4_set_bit(tmp - start, bh->b_data);
@@ -361,6 +374,100 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 	return bh;
 }
 
+/* Initializes an uninitialized exclude bitmap if given, and returns 0 */
+unsigned ext4_init_exclude_bitmap(struct super_block *sb,
+				  struct buffer_head *bh,
+				  ext4_group_t block_group,
+				  struct ext4_group_desc *gdp)
+{
+	if (!bh)
+		/* we can return no. of blocks in exclude bitmap */
+		return 0;
+
+	J_ASSERT_BH(bh, buffer_locked(bh));
+	memset(bh->b_data, 0, sb->s_blocksize);
+	return 0;
+}
+
+/**
+ * read_exclude_bitmap()
+ * @sb:			super block
+ * @block_group:	given block group
+ *
+ * Read the exclude bitmap for a given block_group
+ *
+ * Return buffer_head on success or NULL in case of failure.
+ */
+struct buffer_head *
+ext4_read_exclude_bitmap(struct super_block *sb, ext4_group_t block_group)
+{
+	struct ext4_group_desc *desc;
+	struct buffer_head *bh = NULL;
+	ext4_fsblk_t bitmap_blk;
+
+	desc = ext4_get_group_desc(sb, block_group, NULL);
+	if (!desc)
+		return NULL;
+	bitmap_blk = ext4_exclude_bitmap(sb, desc);
+	if (!bitmap_blk)
+		return NULL;
+	bh = sb_getblk(sb, bitmap_blk);
+	if (unlikely(!bh)) {
+		ext4_error(sb, "Cannot read exclude bitmap - "
+			    "block_group = %d, exclude_bitmap = %llu",
+			    block_group, bitmap_blk);
+		return NULL;
+	}
+
+	if (bitmap_uptodate(bh))
+		return bh;
+
+	lock_buffer(bh);
+	if (bitmap_uptodate(bh)) {
+		unlock_buffer(bh);
+		return bh;
+	}
+
+	ext4_lock_group(sb, block_group);
+	if (desc->bg_flags & cpu_to_le16(EXT4_BG_EXCLUDE_UNINIT)) {
+		ext4_init_exclude_bitmap(sb, bh, block_group, desc);
+		set_bitmap_uptodate(bh);
+		set_buffer_uptodate(bh);
+		ext4_unlock_group(sb, block_group);
+		unlock_buffer(bh);
+		return bh;
+	}
+	ext4_unlock_group(sb, block_group);
+	if (buffer_uptodate(bh)) {
+		/*
+		 * if not uninit if bh is uptodate,
+		 * bitmap is also uptodate
+		 */
+		set_bitmap_uptodate(bh);
+		unlock_buffer(bh);
+		return bh;
+	}
+	/*
+	 * submit the buffer_head for read. We can
+	 * safely mark the bitmap as uptodate now.
+	 * We do it here so the bitmap uptodate bit
+	 * get set with buffer lock held.
+	 */
+	set_bitmap_uptodate(bh);
+	if (bh_submit_read(bh) < 0) {
+		put_bh(bh);
+		ext4_error(sb, "Cannot read exclude bitmap - "
+			    "block_group = %u, block_bitmap = %llu",
+			    block_group, bitmap_blk);
+		return NULL;
+	}
+	/*
+	 * file system mounted not to panic on error,
+	 * continue with corrupt bitmap
+	 */
+	return bh;
+}
+
 /**
  * ext4_has_free_blocks()
  * @sbi:	in-core super block structure.
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0599fef..34aaade 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -269,7 +269,8 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count_lo;/* Free inodes count */
 	__le16	bg_used_dirs_count_lo;	/* Directories count */
 	__le16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
-	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
+	__le32	bg_exclude_bitmap_lo;	/* Exclude bitmap block */
+	__u32	bg_reserved[1];		/* Likely block/inode bitmap checksum */
 	__le16  bg_itable_unused_lo;	/* Unused inodes count */
 	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
@@ -279,7 +280,8 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
 	__le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
-	__u32	bg_reserved2[3];
+	__le32	bg_exclude_bitmap_hi;	/* Exclude bitmap block MSB */
+	__u32	bg_reserved2[2];
 };
 
 /*
@@ -295,6 +297,7 @@ struct flex_groups {
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
 #define EXT4_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not in use */
 #define EXT4_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
+#define EXT4_BG_EXCLUDE_UNINIT	0x0008 /* Exclude bitmap not in use */
 
 /*
  * Macro-instructions used to manage group descriptors
@@ -1433,6 +1436,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_COMPAT_EXT_ATTR		0x0008
 #define EXT4_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT4_FEATURE_COMPAT_DIR_INDEX		0x0020
+#define EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP	0x0100 /* Has exclude bitmap */
 
 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -1775,6 +1779,8 @@ extern unsigned ext4_init_block_bitmap(struct super_block *sb,
 				       struct ext4_group_desc *desc);
 #define ext4_free_blocks_after_init(sb, group, desc)			\
 		ext4_init_block_bitmap(sb, NULL, group, desc)
+extern struct buffer_head *ext4_read_exclude_bitmap(struct super_block *sb,
+					       unsigned int block_group);
 
 /* dir.c */
 extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
@@ -1936,6 +1942,8 @@ extern ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
+extern ext4_fsblk_t ext4_exclude_bitmap(struct super_block *sb,
+				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 				     struct ext4_group_desc *bg);
 extern __u32 ext4_free_blks_count(struct super_block *sb,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 899c12c..50d2c9d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2846,6 +2846,11 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (err)
 		goto out_err;
 
+	if (EXT4_SNAPSHOTS(sb) && ext4_snapshot_excluded(ac->ac_inode)) {
+		err = ext4_snapshot_exclude_blocks(handle, sb, block, ac->ac_b_ex.fe_len);
+		if (err < 0)
+			goto out_err;
+	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
@@ -4515,6 +4520,12 @@ void __ext4_free_blocks(const char *where, unsigned int line, handle_t *handle,
 	int err = 0;
 	int ret;
 	int maxblocks;
+	struct buffer_head *exclude_bitmap_bh = NULL;
+	int  exclude_bitmap_dirty = 0;
+	/* excluded_block is determined by testing exclude bitmap */
+	int excluded_block;
+	/* excluded_file is an attribute of the inode */
+	int excluded_file = ext4_snapshot_excluded(inode);
 
 	if (bh) {
 		if (block)
@@ -4634,6 +4645,26 @@ do_more:
 	err = ext4_journal_get_write_access(handle, gd_bh);
 	if (err)
 		goto error_return;
+	/*
+	 * we may be freeing blocks of snapshot/excluded file
+	 * which we would need to clear from exclude bitmap -
+	 * try to read exclude bitmap and if it fails
+	 * skip the exclude bitmap update
+	 */
+	if (EXT4_SNAPSHOTS(sb)) {
+		brelse(exclude_bitmap_bh);
+		exclude_bitmap_bh = ext4_read_exclude_bitmap(sb, block_group);
+		if (!exclude_bitmap_bh) {
+			err = -EIO;
+			goto error_return;
+		}
+		err = ext4_journal_get_write_access_exclude(handle,
+						    exclude_bitmap_bh);
+		if (err)
+			goto error_return;
+		exclude_bitmap_dirty = 0;
+	}
+
 #ifdef AGGRESSIVE_CHECK
 	{
 		int i;
@@ -4641,6 +4672,29 @@ do_more:
 			BUG_ON(!mb_test_bit(bit + i, bitmap_bh->b_data));
 	}
 #endif
+	if (exclude_bitmap_bh) {
+		unsigned long i;
+
+		if (excluded_file)
+			i = mb_find_next_zero_bit(exclude_bitmap_bh->b_data,
+						  bit + count, bit) - bit;
+		else
+			i = mb_find_next_bit(exclude_bitmap_bh->b_data,
+					     bit + count, bit) - bit;
+		if (i < count) {
+			EXT4_SET_FLAGS(sb, EXT4_FLAGS_FIX_EXCLUDE);
+			ext4_error(sb, "%sexcluded file (ino=%lu)"
+				   " block [%lu-%lu/%u, %llu] was %sexcluded!"
+				   " - run fsck to fix exclude bitmap.\n",
+				   excluded_file ? "" : "non-",
+				   inode ? inode->i_ino : 0,
+				   bit + i, bit + count,
+				   block_group, block + i,
+				   excluded_file ? "not " : "");
+			if (!excluded_file)
+				excluded_block = 1;
+		}
+	}
 	trace_ext4_mballoc_free(sb, inode, block_group, bit, count);
 
 	err = ext4_mb_load_buddy(sb, block_group, &e4b);
@@ -4675,6 +4729,14 @@ do_more:
 		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		mb_free_blocks(inode, &e4b, bit, count);
 	}
+		/*
+		 * A free block should never be excluded from snapshot, so we
+		 * always clear exclude bitmap just to be on the safe side.
+		 */
+	if (exclude_bitmap_bh && (excluded_file || excluded_block)) {
+		mb_clear_bits(exclude_bitmap_bh->b_data, bit, count);
+		exclude_bitmap_dirty = 1;
+	}
 
 	ret = ext4_free_blks_count(sb, gdp) + count;
 	ext4_free_blks_set(sb, gdp, ret);
@@ -4694,6 +4756,12 @@ do_more:
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
+	if (exclude_bitmap_bh && exclude_bitmap_dirty) {
+		ret = ext4_handle_dirty_metadata(handle, NULL,
+						 exclude_bitmap_bh);
+		if (!err)
+			err = ret;
+	}
 
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
@@ -4711,6 +4779,7 @@ do_more:
 error_return:
 	if (freed)
 		dquot_free_block(inode, freed);
+	brelse(exclude_bitmap_bh);
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
 	return;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index d341a5c..741d72c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -753,6 +753,12 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	gdb_num = input->group / EXT4_DESC_PER_BLOCK(sb);
 	gdb_off = input->group % EXT4_DESC_PER_BLOCK(sb);
 
+	if (EXT4_HAS_COMPAT_FEATURE(sb,
+				EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+		ext4_warning(sb, "Can't resize filesystem with exclude bitmap");
+		return -ENOTSUPP;
+	}
+
 	if (gdb_off == 0 && !EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
 		ext4_warning(sb, "Can't resize non-sparse filesystem further");
diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index a1e4175..58ec349 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -187,6 +187,7 @@ ext4_snapshot_init_cow_bitmap(struct super_block *sb,
 		unsigned int block_group, struct buffer_head *cow_bh)
 {
 	struct buffer_head *bitmap_bh;
+	struct buffer_head *exclude_bitmap_bh = NULL;
 	char *dst, *src, *mask = NULL;
 
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
@@ -194,6 +195,10 @@ ext4_snapshot_init_cow_bitmap(struct super_block *sb,
 		return -EIO;
 
 	src = bitmap_bh->b_data;
+	exclude_bitmap_bh = ext4_read_exclude_bitmap(sb, block_group);
+	if (exclude_bitmap_bh)
+		/* mask block bitmap with exclude bitmap */
+		mask = exclude_bitmap_bh->b_data;
 	/*
 	 * Another COWing task may be changing this block bitmap
 	 * (allocating active snapshot blocks) while we are trying
@@ -214,6 +219,7 @@ ext4_snapshot_init_cow_bitmap(struct super_block *sb,
 
 	ext4_unlock_group(sb, block_group);
 
+	brelse(exclude_bitmap_bh);
 	brelse(bitmap_bh);
 	return 0;
 }
@@ -420,10 +426,129 @@ ext4_snapshot_test_cow_bitmap(handle_t *handle, struct inode *snapshot,
 
 	ret = ext4_mb_test_bit_range(bit, cow_bh->b_data, maxblocks);
 
+	if (ret && excluded) {
+		int i, inuse = *maxblocks;
+
+		/*
+		 * We should never get here because excluded file blocks should
+		 * be excluded from COW bitmap.  The blocks will not be COWed
+		 * anyway, but this can indicate a messed up exclude bitmap.
+		 * Mark that exclude bitmap needs to be fixed and clear blocks
+		 * from COW bitmap.
+		 */
+		EXT4_SET_FLAGS(excluded->i_sb, EXT4_FLAGS_FIX_EXCLUDE);
+		ext4_warning(excluded->i_sb,
+			"clearing excluded file (ino=%lu) blocks [%d-%d/%lu] "
+			"from COW bitmap! - running fsck to fix exclude bitmap "
+			"is recommended.\n",
+			excluded->i_ino, bit, bit+inuse-1, block_group);
+		for (i = 0; i < inuse; i++)
+			ext4_clear_bit(bit+i, cow_bh->b_data);
+		ret = ext4_jbd2_file_inode(handle, snapshot);
+		mark_buffer_dirty(cow_bh);
+	}
+
 	brelse(cow_bh);
 	return ret;
 }
 /*
+ * ext4_snapshot_test_and_exclude() marks blocks in exclude bitmap
+ * @where:	name of caller function
+ * @handle:	JBD handle
+ * @sb:		super block handle
+ * @block:	address of first block to exclude
+ * @maxblocks:	max. blocks to exclude
+ * @exclude:	if false, return -EIO if block needs to be excluded
+ *
+ * Return values:
+ * >= 0 - no. of blocks set in exclude bitmap
+ * < 0 - error
+ */
+int ext4_snapshot_test_and_exclude(const char *where, handle_t *handle,
+		struct super_block *sb, ext4_fsblk_t block, int count,
+		int exclude)
+{
+	struct buffer_head *exclude_bitmap_bh = NULL;
+	struct buffer_head *gdp_bh = NULL;
+	struct ext4_group_desc *gdp = NULL;
+	ext4_group_t block_group = SNAPSHOT_BLOCK_GROUP(block);
+	ext4_grpblk_t bit = SNAPSHOT_BLOCK_GROUP_OFFSET(block);
+	int err = 0, n = 0, excluded = 0, exclude_uninit;
+
+	err = -EIO;
+	gdp = ext4_get_group_desc(sb, block_group, &gdp_bh);
+	if (!gdp)
+		goto out;
+
+	exclude_uninit = gdp->bg_flags & cpu_to_le16(EXT4_BG_EXCLUDE_UNINIT);
+	if (exclude && exclude_uninit) {
+		err = ext4_journal_get_write_access(handle, gdp_bh);
+		if (err)
+			goto out;
+	}
+
+	exclude_bitmap_bh = ext4_read_exclude_bitmap(sb, block_group);
+	if (!exclude_bitmap_bh)
+		return 0;
+
+	if (exclude)
+		err = ext4_journal_get_write_access_exclude(handle,
+							    exclude_bitmap_bh);
+	if (err)
+		goto out;
+
+	while (count > 0 && bit < SNAPSHOT_BLOCKS_PER_GROUP) {
+		if (!ext4_set_bit_atomic(sb_bgl_lock(EXT4_SB(sb),
+						block_group),
+					bit, exclude_bitmap_bh->b_data)) {
+			n++;
+			if (!exclude)
+				break;
+		} else if (n) {
+			snapshot_debug(2, "excluded blocks: [%d-%d/%d]\n",
+					bit-n, bit-1, block_group);
+			excluded += n;
+			n = 0;
+		}
+		bit++;
+		count--;
+	}
+
+	if (n && !exclude) {
+		EXT4_SET_FLAGS(sb, EXT4_FLAGS_FIX_EXCLUDE);
+		ext4_error(sb, where,
+			"snapshot file block [%d/%d] not in exclude bitmap! - "
+			"running fsck to fix exclude bitmap is recommended.\n",
+			bit, block_group);
+		err = -EIO;
+		goto out;
+	}
+
+	if (n) {
+		snapshot_debug(2, "excluded blocks: [%d-%d/%d]\n",
+				bit-n, bit-1, block_group);
+		excluded += n;
+	}
+
+	if (exclude && excluded) {
+		err = ext4_handle_dirty_metadata(handle,
+						 NULL, exclude_bitmap_bh);
+		if (err)
+			goto out;
+
+		if (exclude_uninit) {
+			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_EXCLUDE_UNINIT);
+			err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
+		}
+
+		trace_cow_add(handle, excluded, excluded);
+	}
+out:
+	brelse(exclude_bitmap_bh);
+	return err ? err : excluded;
+}
+
+/*
  * COW functions
  */
 
@@ -732,6 +857,13 @@ test_pending_cow:
 cowed:
 	/* mark the buffer COWed in the current transaction */
 	ext4_snapshot_mark_cowed(handle, bh);
+	if (clear) {
+		/* mark COWed block in exclude bitmap */
+		clear = ext4_snapshot_exclude_blocks(handle, sb,
+				block, 1);
+		if (clear < 0)
+			err = clear;
+	}
 out:
 	brelse(sbh);
 	/* END COWing */
@@ -854,6 +986,10 @@ int ext4_snapshot_test_and_move(const char *where, handle_t *handle,
 	 */
 	if (inode)
 		dquot_free_block(inode, count);
+	/* mark moved blocks in exclude bitmap */
+	excluded = ext4_snapshot_exclude_blocks(handle, sb, block, count);
+	if (excluded < 0)
+		err = excluded;
 	trace_cow_add(handle, moved, count);
 out:
 	/* END moving */
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 3282fe7..11fa43d 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -341,6 +341,34 @@ static inline int ext4_snapshot_get_delete_access(handle_t *handle,
 
 	return ext4_snapshot_move(handle, inode, block, pcount, 1);
 }
+extern int ext4_snapshot_test_and_exclude(const char *where, handle_t *handle,
+		struct super_block *sb, ext4_fsblk_t block, int maxblocks,
+		int exclude);
+
+/*
+ * ext4_snapshot_exclude_blocks() - exclude snapshot blocks
+ *
+ * Called from ext4_snapshot_test_and_{cow,move}() when copying/moving
+ * blocks to active snapshot.
+ *
+ * Return <0 on error.
+ */
+#define ext4_snapshot_exclude_blocks(handle, sb, block, count) \
+	ext4_snapshot_test_and_exclude(__func__, (handle), (sb), \
+			(block), (count), 1)
+
+/*
+ * ext4_snapshot_test_excluded() - test that snapshot blocks are excluded
+ *
+ * Called from ext4_count_branches() and
+ * ext4_count_blocks() under snapshot_mutex.
+ *
+ * Return <0 on error or if snapshot blocks are not excluded.
+ */
+#define ext4_snapshot_test_excluded(inode, block, count) \
+	ext4_snapshot_test_and_exclude(__func__, NULL, (inode)->i_sb, \
+			(block), (count), 0)
+
 
 extern void init_ext4_snapshot_cow_cache(void);
 
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 298405a..9e39c04 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -886,6 +886,7 @@ int ext4_snapshot_take(struct inode *inode)
 	struct ext4_super_block *es = NULL;
 	struct buffer_head *es_bh = NULL;
 	struct buffer_head *sbh = NULL;
+	struct buffer_head *exclude_bitmap_bh = NULL;
 	struct buffer_head *bhs[COPY_INODE_BLOCKS_NUM] = { NULL };
 	const char *mask = NULL;
 	struct inode *curr_inode;
@@ -1027,6 +1028,11 @@ copy_inode_blocks:
 	brelse(bhs[COPY_INODE_BITMAP]);
 	bhs[COPY_INODE_BITMAP] = sb_bread(sb,
 			ext4_inode_bitmap(sb, desc));
+	brelse(exclude_bitmap_bh);
+	exclude_bitmap_bh = ext4_read_exclude_bitmap(sb, iloc.block_group);
+	if (exclude_bitmap_bh)
+		/* mask block bitmap with exclude bitmap */
+		mask = exclude_bitmap_bh->b_data;
 	err = -EIO;
 	for (i = 0; i < COPY_INODE_BLOCKS_NUM; i++) {
 		brelse(sbh);
@@ -1134,6 +1140,7 @@ out_unlockfs:
 			inode->i_generation);
 
 out_err:
+	brelse(exclude_bitmap_bh);
 	brelse(es_bh);
 	brelse(sbh);
 	for (i = 0; i < COPY_INODE_BLOCKS_NUM; i++)
diff --git a/fs/ext4/snapshot_inode.c b/fs/ext4/snapshot_inode.c
index f2311e4..3d6cb7b 100644
--- a/fs/ext4/snapshot_inode.c
+++ b/fs/ext4/snapshot_inode.c
@@ -149,6 +149,7 @@ static int ext4_snapshot_get_blockdev_access(struct super_block *sb,
 	unsigned long block_group = SNAPSHOT_BLOCK_GROUP(bh->b_blocknr);
 	ext4_grpblk_t bit = SNAPSHOT_BLOCK_GROUP_OFFSET(bh->b_blocknr);
 	struct buffer_head *bitmap_bh;
+	struct buffer_head *exclude_bitmap_bh = NULL;
 	int err = 0;
 
 	if (PageReadahead(bh->b_page))
@@ -166,6 +167,16 @@ static int ext4_snapshot_get_blockdev_access(struct super_block *sb,
 		return -EIO;
 	}
 
+	exclude_bitmap_bh = ext4_read_exclude_bitmap(sb, block_group);
+	if (exclude_bitmap_bh &&
+		ext4_test_bit(bit, exclude_bitmap_bh->b_data)) {
+		snapshot_debug(2, "warning: attempt to read through to "
+				"excluded block [%d/%lu] - read ahead?\n",
+				bit, block_group);
+		err = -EIO;
+	}
+
+	brelse(exclude_bitmap_bh);
 	brelse(bitmap_bh);
 	return err;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a1c4728..7f15983 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -126,6 +126,18 @@ ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
 		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32 : 0);
 }
 
+ext4_fsblk_t ext4_exclude_bitmap(struct super_block *sb,
+			       struct ext4_group_desc *bg)
+{
+	if (!EXT4_HAS_COMPAT_FEATURE(sb,
+				EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		return 0;
+
+	return le32_to_cpu(bg->bg_exclude_bitmap_lo) |
+		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
+		 (ext4_fsblk_t)le32_to_cpu(bg->bg_exclude_bitmap_hi) << 32 : 0);
+}
+
 ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 			      struct ext4_group_desc *bg)
 {
@@ -2067,6 +2079,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 	ext4_fsblk_t block_bitmap;
 	ext4_fsblk_t inode_bitmap;
 	ext4_fsblk_t inode_table;
+	ext4_fsblk_t exclude_bitmap;
 	int flexbg_flag = 0;
 	ext4_group_t i, grp = sbi->s_groups_count;
 
@@ -2110,10 +2123,23 @@ static int ext4_check_descriptors(struct super_block *sb,
 			       "(block %llu)!", i, inode_table);
 			return 0;
 		}
+		if (EXT4_HAS_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+			exclude_bitmap = ext4_exclude_bitmap(sb, gdp);
+			if (exclude_bitmap < first_block ||
+			    exclude_bitmap > last_block) {
+				ext4_msg(sb, KERN_ERR,
+					 "ext4_check_descriptors: "
+					 "Exclude bitmap for group %u "
+					 "not in group (block %llu)!",
+					 i, exclude_bitmap);
+				return 0;
+			}
+		}
 		ext4_lock_group(sb, i);
 		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
-				 "Checksum for group %u failed (%u!=%u)",
+				 "Checksum for group %u failed (%x!=%x)",
 				 i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
 				     gdp)), le16_to_cpu(gdp->bg_checksum));
 			if (!(sb->s_flags & MS_RDONLY)) {
@@ -2653,6 +2679,13 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 				"features: meta_bg, 64bit");
 			return 0;
 		}
+		if (!EXT4_HAS_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+			ext4_msg(sb, KERN_ERR,
+				"exclude_bitmap feature is required "
+				"for snapshots");
+			return 0;
+		}
 		if (EXT4_TEST_FLAGS(sb, EXT4_FLAGS_IS_SNAPSHOT)) {
 			ext4_msg(sb, KERN_ERR,
 				"A snapshot image must be mounted read-only. "
-- 
1.7.4.1

