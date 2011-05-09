From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 27/30] ext4: snapshot exclude - the exclude bitmap
Date: Mon,  9 May 2011 19:41:45 +0300
Message-ID: <1304959308-11122-28-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab1EIQoa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:44:30 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:44:30 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
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
 fs/ext4/balloc.c  |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h    |   12 ++++++-
 fs/ext4/mballoc.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/resize.c  |    6 +++
 fs/ext4/super.c   |   35 +++++++++++++++++++-
 5 files changed, 230 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 7d22e50..37ea965 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -359,6 +359,100 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
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
index bf5aa4d..37c608b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -282,7 +282,8 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count_lo;/* Free inodes count */
 	__le16	bg_used_dirs_count_lo;	/* Directories count */
 	__le16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
-	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
+	__le32	bg_exclude_bitmap_lo;	/* Exclude bitmap block */
+	__u32	bg_reserved[1];		/* Likely block/inode bitmap checksum */
 	__le16  bg_itable_unused_lo;	/* Unused inodes count */
 	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
@@ -292,7 +293,8 @@ struct ext4_group_desc
 	__le16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
 	__le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
-	__u32	bg_reserved2[3];
+	__le32	bg_exclude_bitmap_hi;	/* Exclude bitmap block MSB */
+	__u32	bg_reserved2[2];
 };
 
 /*
@@ -308,6 +310,7 @@ struct flex_groups {
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
 #define EXT4_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not in use */
 #define EXT4_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
+#define EXT4_BG_EXCLUDE_UNINIT	0x0008 /* Exclude bitmap not in use */
 
 /*
  * Macro-instructions used to manage group descriptors
@@ -1459,6 +1462,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_COMPAT_EXT_ATTR		0x0008
 #define EXT4_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT4_FEATURE_COMPAT_DIR_INDEX		0x0020
+#define EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP	0x0100 /* Has exclude bitmap */
 
 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
@@ -1786,6 +1790,8 @@ extern unsigned ext4_init_block_bitmap(struct super_block *sb,
 				       struct ext4_group_desc *desc);
 #define ext4_free_blocks_after_init(sb, group, desc)			\
 		ext4_init_block_bitmap(sb, NULL, group, desc)
+extern struct buffer_head *ext4_read_exclude_bitmap(struct super_block *sb,
+					       unsigned int block_group);
 
 /* dir.c */
 extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
@@ -1947,6 +1953,8 @@ extern ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
+extern ext4_fsblk_t ext4_exclude_bitmap(struct super_block *sb,
+				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 				     struct ext4_group_desc *bg);
 extern __u32 ext4_free_blks_count(struct super_block *sb,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4813b15..46bfb7e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2753,6 +2753,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	struct super_block *sb;
 	ext4_fsblk_t block;
 	int err, len;
+	struct buffer_head *exclude_bitmap_bh = NULL;
 
 	BUG_ON(ac->ac_status != AC_STATUS_FOUND);
 	BUG_ON(ac->ac_b_ex.fe_len <= 0);
@@ -2761,6 +2762,22 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	sbi = EXT4_SB(sb);
 
 	err = -EIO;
+	if (EXT4_SNAPSHOTS(sb) && ext4_snapshot_excluded(ac->ac_inode)) {
+		/*
+		 * try to read exclude bitmap
+		 */
+		exclude_bitmap_bh = ext4_read_exclude_bitmap(sb,
+							ac->ac_b_ex.fe_group);
+		if (!exclude_bitmap_bh)
+			goto out_err;
+		err = ext4_journal_get_write_access_exclude(handle,
+							    exclude_bitmap_bh);
+		if (err) {
+			brelse(exclude_bitmap_bh);
+			goto out_err;
+		}
+	}
+
 	bitmap_bh = ext4_read_block_bitmap(sb, ac->ac_b_ex.fe_group);
 	if (!bitmap_bh)
 		goto out_err;
@@ -2813,6 +2830,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	}
 #endif
 	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,ac->ac_b_ex.fe_len);
+	if (exclude_bitmap_bh)
+		mb_set_bits(exclude_bitmap_bh->b_data, ac->ac_b_ex.fe_start,
+			    ac->ac_b_ex.fe_len);
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 		ext4_free_blks_set(sb, gdp,
@@ -2840,6 +2860,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
+	if (!err && exclude_bitmap_bh)
+		err = ext4_handle_dirty_metadata(handle, NULL,
+					     exclude_bitmap_bh);
 	if (err)
 		goto out_err;
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
@@ -2847,6 +2870,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 out_err:
 	ext4_mark_super_dirty(sb);
 	brelse(bitmap_bh);
+	brelse(exclude_bitmap_bh);
 	return err;
 }
 
@@ -4509,6 +4533,12 @@ void __ext4_free_blocks(const char *where, unsigned int line, handle_t *handle,
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
@@ -4628,6 +4658,26 @@ do_more:
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
@@ -4635,6 +4685,27 @@ do_more:
 			BUG_ON(!mb_test_bit(bit + i, bitmap_bh->b_data));
 	}
 #endif
+	if (exclude_bitmap_bh) {
+		int i;
+		if (excluded_file)
+			i = mb_find_next_zero_bit(exclude_bitmap_bh->b_data,
+						  bit + count, bit) - bit;
+		else
+			i = mb_find_next_bit(exclude_bitmap_bh->b_data,
+					     bit + count, bit) - bit;
+		if (i < count) {
+			EXT4_SET_FLAGS(sb, EXT4_FLAGS_FIX_EXCLUDE);
+			ext4_error(sb, "%sexcluded file (ino=%lu)"
+				   " block [%d/%u] was %sexcluded!"
+				   " - run fsck to fix exclude bitmap.\n",
+				   excluded_file ? "" : "non-",
+				   inode ? inode->i_ino : 0,
+				   bit + i, block_group,
+				   excluded_block ? "" : "not ");
+			if (!excluded_file)
+				excluded_block = 1;
+		}
+	}
 	trace_ext4_mballoc_free(sb, inode, block_group, bit, count);
 
 	err = ext4_mb_load_buddy(sb, block_group, &e4b);
@@ -4669,6 +4740,14 @@ do_more:
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
@@ -4688,6 +4767,12 @@ do_more:
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
@@ -4705,6 +4790,7 @@ do_more:
 error_return:
 	if (freed)
 		dquot_free_block(inode, freed);
+	brelse(exclude_bitmap_bh);
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
 	return;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index dff9b5d..57c421a 100644
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
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 461653c..68c4d18 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -110,6 +110,18 @@ ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
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
@@ -2054,6 +2066,7 @@ static int ext4_check_descriptors(struct super_block *sb,
 	ext4_fsblk_t block_bitmap;
 	ext4_fsblk_t inode_bitmap;
 	ext4_fsblk_t inode_table;
+	ext4_fsblk_t exclude_bitmap;
 	int flexbg_flag = 0;
 	ext4_group_t i, grp = sbi->s_groups_count;
 
@@ -2097,10 +2110,23 @@ static int ext4_check_descriptors(struct super_block *sb,
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
@@ -2640,6 +2666,13 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
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
1.7.0.4

