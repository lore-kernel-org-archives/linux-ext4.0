From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Thu, 6 Dec 2007 16:10:45 -0600
Message-ID: <20071206161045.1054bbe7@gara>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/6xuFrXKAaFL9I19txq2QF2T"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46055 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbXLFWKp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2007 17:10:45 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB6MAikp011482
	for <linux-ext4@vger.kernel.org>; Thu, 6 Dec 2007 17:10:45 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB6MAig9080526
	for <linux-ext4@vger.kernel.org>; Thu, 6 Dec 2007 15:10:44 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB6MAimM010873
	for <linux-ext4@vger.kernel.org>; Thu, 6 Dec 2007 15:10:44 -0700
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id lB6MAiix010854
	for <linux-ext4@vger.kernel.org>; Thu, 6 Dec 2007 15:10:44 -0700
Received: from gara (wecm-9-67-18-163.wecm.ibm.com [9.67.18.163])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id lB6MAghK035450
	for <linux-ext4@vger.kernel.org>; Thu, 6 Dec 2007 16:10:43 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--MP_/6xuFrXKAaFL9I19txq2QF2T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi folks,

New version of the Flex_BG ialloc allocation patch.

Changes from the last version:

- Size of the FLEX_BG in now written to the super block at mke2fs time
  instead of calculating at mount time (testing patch for e2fsprog's
  next branch attached).

- Rename a lots of the confusing "meta" terms as suggested by Andreas.

- Use the Orlov if the FLEX_BG size is 0.

- Use shift instead of divide in ext4_meta_group() as suggested by
  Andreas.

- Use sb_bgl_lock() instead of one spinlock per FLEX_BG as suggested by
  Andreas.  (Needs more perf testing)

- Remove some dead/prototype code.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b102b0e..7ef9787 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -600,6 +600,7 @@ void ext4_free_blocks_sb(handle_t *handle, struct super_block *sb,
 	struct ext4_sb_info *sbi;
 	int err = 0, ret;
 	ext4_grpblk_t group_freed;
+	ext4_group_t flex_group;
 
 	*pdquot_freed_blocks = 0;
 	sbi = EXT4_SB(sb);
@@ -745,6 +746,14 @@ do_more:
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    sbi->s_groups_per_flex_shift) {
+		flex_group = ext4_flex_group(sbi, block_group);
+		spin_lock(sb_bgl_lock(sbi, flex_group));
+		sbi->s_flex_groups[flex_group].free_blocks += count;
+		spin_unlock(sb_bgl_lock(sbi, flex_group));
+	}
+
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
@@ -1610,6 +1619,7 @@ ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
 	unsigned short windowsz = 0;
 	ext4_group_t ngroups;
 	unsigned long num = *count;
+	ext4_group_t flex_group;
 
 	*errp = -ENOSPC;
 	sb = inode->i_sb;
@@ -1815,6 +1825,14 @@ allocated:
 	spin_unlock(sb_bgl_lock(sbi, group_no));
 	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    sbi->s_groups_per_flex_shift) {
+		flex_group = ext4_flex_group(sbi, group_no);
+		spin_lock(sb_bgl_lock(sbi, flex_group));
+		sbi->s_flex_groups[flex_group].free_blocks -= num;
+		spin_unlock(sb_bgl_lock(sbi, flex_group));
+	}
+
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext4_journal_dirty_metadata(handle, gdp_bh);
 	if (!fatal)
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 17b5df1..35ab8ff 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -158,6 +158,7 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 	struct ext4_super_block * es;
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err;
+	ext4_group_t flex_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
 		printk ("ext4_free_inode: inode has count=%d\n",
@@ -235,6 +236,13 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 			if (is_directory)
 				percpu_counter_dec(&sbi->s_dirs_counter);
 
+			if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+			    sbi->s_groups_per_flex_shift) {
+				flex_group = ext4_flex_group(sbi, block_group);
+				spin_lock(sb_bgl_lock(sbi, flex_group));
+				sbi->s_flex_groups[flex_group].free_inodes++;
+				spin_unlock(sb_bgl_lock(sbi, flex_group));
+			}
 		}
 		BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
 		err = ext4_journal_dirty_metadata(handle, bh2);
@@ -289,6 +297,71 @@ static int find_group_dir(struct super_block *sb, struct inode *parent,
 	return ret;
 }
 
+#define free_block_ratio 10
+
+int find_group_flex(struct super_block *sb, struct inode *parent)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *desc;
+	struct buffer_head *bh;
+	struct flex_groups *flex_group = sbi->s_flex_groups;
+	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
+	ext4_group_t parent_fbg_group = ext4_flex_group(sbi, parent_group);
+	ext4_group_t ngroups = sbi->s_groups_count;
+	int flex_size = ext4_flex_bg_size(sbi);
+	ext4_group_t best_flex = -1;
+	ext4_group_t best_group = -1;
+	int blocks_per_flex = sbi->s_blocks_per_group * flex_size;
+	int flex_freeb_ratio;
+	ext4_group_t n_fbg_groups;
+	ext4_group_t i;
+
+	n_fbg_groups = (sbi->s_groups_count + flex_size - 1) / flex_size;
+	best_flex = parent_fbg_group;
+
+find_close_to_parent:
+	flex_freeb_ratio = flex_group[best_flex].free_blocks*100/blocks_per_flex;
+	if (flex_group[best_flex].free_inodes &&
+	    flex_freeb_ratio > free_block_ratio)
+		goto found_flexbg;
+
+	if (best_flex && best_flex == parent_fbg_group) {
+		best_flex--;
+		goto find_close_to_parent;
+	}
+
+	for (i = 0; i < n_fbg_groups; i++) {
+		if (i == parent_fbg_group || i == parent_fbg_group - 1)
+			continue;
+
+		flex_freeb_ratio = flex_group[i].free_blocks*100/blocks_per_flex;
+
+		if (flex_freeb_ratio > free_block_ratio &&
+		    flex_group[i].free_inodes) {
+			best_flex = i;
+			break;
+		}
+
+		if (best_flex < 0 ||
+		    (flex_group[i].free_blocks >
+		     flex_group[best_flex].free_blocks &&
+		     flex_group[i].free_inodes))
+			best_flex = i;
+	}
+
+found_flexbg:
+	for (i = best_flex * flex_size; i < ngroups &&
+		     i < (best_flex + 1) * flex_size; i++) {
+		desc = ext4_get_group_desc(sb, i, &bh);
+		if (le16_to_cpu(desc->bg_free_inodes_count)) {
+			best_group = i;
+			goto out;
+		}
+	}
+out:
+	return best_group;
+}
+
 /*
  * Orlov's allocator for directories.
  *
@@ -504,6 +577,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
+	ext4_group_t flex_group;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -517,6 +591,13 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 
 	sbi = EXT4_SB(sb);
 	es = sbi->s_es;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+		sbi->s_groups_per_flex_shift) {
+		group = find_group_flex(sb, dir);
+		goto got_group;
+	}
+
 	if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
 			ret2 = find_group_dir(sb, dir, &group);
@@ -525,6 +606,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	} else
 		ret2 = find_group_other(sb, dir, &group);
 
+got_group:
 	err = -ENOSPC;
 	if (ret2 == -1)
 		goto out;
@@ -681,6 +763,14 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    sbi->s_groups_per_flex_shift) {
+		flex_group = ext4_flex_group(sbi, group);
+		spin_lock(sb_bgl_lock(sbi, flex_group));
+		sbi->s_flex_groups[flex_group].free_inodes--;
+		spin_unlock(sb_bgl_lock(sbi, flex_group));
+	}
+
 	inode->i_uid = current->fsuid;
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b626339..81ad9b1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -518,6 +518,7 @@ static void ext4_put_super (struct super_block * sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
+	kfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -1423,6 +1424,61 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	return res;
 }
 
+static int ext4_fill_flex_info(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *gdp = NULL;
+	struct buffer_head *bh;
+	ext4_group_t flex_group_count;
+	ext4_group_t flex_group;
+	unsigned int shift;
+	int groups_per_flex = 0;
+	int tmp = 0;
+	__u64 block_bitmap = 0, cur_block_bitmap;
+	int i;
+
+	groups_per_flex = le16_to_cpu(sbi->s_es->s_flex_bg_size);
+
+	if (!groups_per_flex) {
+		sbi->s_groups_per_flex_shift = 0;
+		return 1;
+	}
+
+	shift = 0;
+	tmp = groups_per_flex;
+	while ((tmp >>= 1UL) != 0UL)
+		shift++;
+
+	sbi->s_groups_per_flex_shift = shift;
+	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
+		groups_per_flex;
+	sbi->s_flex_groups = kmalloc(flex_group_count *
+				     sizeof(struct flex_groups), GFP_KERNEL);
+	if (sbi->s_flex_groups == NULL) {
+		printk(KERN_ERR "EXT4-fs: not enough memory\n");
+		goto failed;
+	}
+	memset(sbi->s_flex_groups, 0, flex_group_count *
+	       sizeof(struct flex_groups));
+
+	gdp = ext4_get_group_desc(sb, 1, &bh);
+	block_bitmap = ext4_block_bitmap(sb, gdp) - 1;
+
+	for (i = 0; i < sbi->s_groups_count; i++) {
+		gdp = ext4_get_group_desc(sb, i, &bh);
+
+		flex_group = ext4_flex_group(sbi, i);
+		sbi->s_flex_groups[flex_group].free_inodes +=
+			le16_to_cpu(gdp->bg_free_inodes_count);
+		sbi->s_flex_groups[flex_group].free_blocks +=
+			le16_to_cpu(gdp->bg_free_blocks_count);
+	}
+
+	return 1;
+failed:
+	return 0;
+}
+
 __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 			    struct ext4_group_desc *gdp)
 {
@@ -2037,6 +2093,13 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		printk(KERN_ERR "EXT4-fs: group descriptors corrupted!\n");
 		goto failed_mount2;
 	}
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		if (!ext4_fill_flex_info(sb)) {
+			printk(KERN_ERR
+			       "EXT4-fs: unable to initialize flex_bg meta info!\n");
+			goto failed_mount2;
+		}
+
 	sbi->s_gdb_count = db_count;
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index bcdb59d..3b94dbf 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -152,6 +152,15 @@ struct ext4_group_desc
 	__u32	bg_reserved2[3];
 };
 
+/*
+ * Structure of a flex block group info
+ */
+
+struct flex_groups {
+	__u32 free_inodes;
+	__u32 free_blocks;
+};
+
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
 #define EXT4_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not in use */
 #define EXT4_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
@@ -622,7 +631,9 @@ struct ext4_super_block {
 	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
 	__le64  s_mmp_block;            /* Block for multi-mount protection */
 	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
-	__u32   s_reserved[163];        /* Padding to the end of the block */
+	__le16	s_flex_bg_size;		/* FLEX_BG group size */
+	__le16	padding;		/* Padding to next 32bits */
+	__u32   s_reserved[162];        /* Padding to the end of the block */
 };
 
 #ifdef __KERNEL__
@@ -1120,6 +1131,17 @@ static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
 	raw_inode->i_size_high = cpu_to_le32(i_size >> 32);
 }
 
+static inline ext4_group_t ext4_flex_group(struct ext4_sb_info *sbi,
+					     ext4_group_t block_group)
+{
+	return block_group >> sbi->s_groups_per_flex_shift;
+}
+
+static inline unsigned int ext4_flex_bg_size(struct ext4_sb_info *sbi)
+{
+	return 1 << sbi->s_groups_per_flex_shift;
+}
+
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 744e746..ac7af1b 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -147,6 +147,9 @@ struct ext4_sb_info {
 
 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
+
+	unsigned int s_groups_per_flex_shift;
+	struct flex_groups *s_flex_groups;
 };
 #define EXT4_GROUP_INFO(sb, group)					   \
 	EXT4_SB(sb)->s_group_info[(group) >> EXT4_DESC_PER_BLOCK_BITS(sb)] \

--MP_/6xuFrXKAaFL9I19txq2QF2T
Content-Type: text/x-patch; name=e2fsprogs-flexbg-grouping.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=e2fsprogs-flexbg-grouping.patch

commit 6aea7c4b5bf1c4da4630823a926e025fb7dbddd5
Author: Jose R. Santos <jrs@us.ibm.com>
Date:   Thu Dec 6 14:00:48 2007 -0600

    New bitmap and inode table allocation for FLEX_BG
    
    Change the way we allocate bitmaps and inode tables if the FLEX_BG
    feature is used at mke2fs time.  The block and inode bitmaps are
    allocated as a one contiguous set for each flex block group.  Due to
    the size of the inode tables, the inode table for each block group is
    allocate individually but packed close together at the beginning of a
    flex group.  For now, this allow for the inode table to be packed
    close to the inode bitmaps in cases where we try to allocate a large
    group of inode tables right after the bitmaps and fail.
    
    Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 4ad2ba9..ce81eaa 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -27,6 +27,124 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+#define ALLOC_BLOCK_BITMAPS	1
+#define ALLOC_INODE_BITMAPS	2
+#define ALLOC_INODE_TABLES	3
+
+errcode_t ext2fs_allocate_contiguous(ext2_filsys fs, dgrp_t group,
+				     int type, blk_t start_blk, blk_t last_blk, 
+				     int count, ext2fs_block_bitmap bmap)
+{
+	errcode_t	retval;
+	blk_t		new_blk, blk;
+	int		i, j;
+
+	if (!bmap)
+		bmap = fs->block_map;
+
+	switch (type) {
+	case ALLOC_BLOCK_BITMAPS:
+		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+						1 * count, bmap, &new_blk);
+		if (retval)
+			return retval;
+		for (i=0, blk=new_blk; i < count; i++, blk++) {
+			ext2fs_mark_block_bitmap(bmap, blk);
+			fs->group_desc[group+i].bg_block_bitmap = blk;
+		}
+		break;
+
+	case ALLOC_INODE_BITMAPS:
+		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+						1 * count, bmap, &new_blk);
+		if (retval)
+			return retval;
+		for (i=0, blk=new_blk; i < count; i++, blk++) {
+			ext2fs_mark_block_bitmap(bmap, blk);
+			fs->group_desc[group+i].bg_inode_bitmap = blk;
+		}
+		break;
+
+	case ALLOC_INODE_TABLES:
+		for (i=0; i < count; i++) {
+			retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+							fs->inode_blocks_per_group,
+							bmap, &new_blk);
+			if (retval)
+				return retval;
+			blk = new_blk;
+			for (j=0; j < fs->inode_blocks_per_group; j++, blk++)
+				ext2fs_mark_block_bitmap(bmap, blk);
+			fs->group_desc[group+i].bg_inode_table = new_blk;
+		}
+		break;
+
+	}
+	return 0;
+}
+
+
+
+errcode_t ext2fs_allocate_flex_groups(ext2_filsys fs)
+{
+	errcode_t	retval;
+	blk_t		start, last, j, blocks;
+	dgrp_t		i, k;
+	int		meta_bg_size;
+
+	meta_bg_size = ext2fs_swab16(fs->super->s_flex_bg_size);
+	blocks = 0;
+
+	for (i = 0; i < fs->group_desc_count; i=i+meta_bg_size) {
+		
+		start = ext2fs_group_first_block(fs, i);
+
+		if (i+meta_bg_size >= fs->group_desc_count) {
+			last = ext2fs_group_last_block(fs, fs->group_desc_count);
+			meta_bg_size = fs->group_desc_count - i;
+		}
+		else
+			last = ext2fs_group_last_block(fs, i+meta_bg_size-1);
+
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_BLOCK_BITMAPS,
+						    start, last, meta_bg_size,
+						    fs->block_map);
+		if (retval)
+			return retval;
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_INODE_BITMAPS,
+						    start, last, meta_bg_size,
+						    fs->block_map);
+		if (retval)
+			return retval;
+		retval = ext2fs_allocate_contiguous(fs, i, ALLOC_INODE_TABLES,
+						    start, last, meta_bg_size,
+						    fs->block_map);
+		if (retval)
+			return retval;
+
+		/*
+		 * The content of bg_free_blocks_count is previously
+		 * assigned with out knowledge of the new allocation
+		 * scheme.  Need to update the number of free blocks
+		 * per group descriptor or fsck will complain.
+		 */
+
+		for (k=i; k<i+meta_bg_size; k++){
+			if (k > fs->group_desc_count)
+				break;
+			start = ext2fs_group_first_block(fs, k);
+			last = ext2fs_group_last_block(fs, k);
+			for (j=start; j<=last; j++) {
+				if( !ext2fs_fast_test_block_bitmap(fs->block_map, j))
+					blocks++;
+			}
+				fs->group_desc[k].bg_free_blocks_count = blocks;
+			blocks = 0;
+		}
+	}
+	return 0;
+}
+
 errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 				      ext2fs_block_bitmap bmap)
 {
@@ -107,10 +225,16 @@ errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 	errcode_t	retval;
 	dgrp_t		i;
 
-	for (i = 0; i < fs->group_desc_count; i++) {
-		retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
-		if (retval)
-			return retval;
+	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, 
+				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) 
+		ext2fs_allocate_flex_groups(fs);
+	
+	else {
+		for (i = 0; i < fs->group_desc_count; i++) {
+			retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
+			if (retval)
+				return retval;
+		}
 	}
 	return 0;
 }
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 2394857..7528707 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -577,7 +577,9 @@ struct ext2_super_block {
 	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
-	__u32   s_reserved[163];        /* Padding to the end of the block */
+	__u16	s_flex_bg_size;		/* FLEX_BG group size */
+	__u16	padding;		/* Padding to next 32bits */
+	__u32   s_reserved[162];        /* Padding to the end of the block */
 };
 
 /*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 16e9eaa..935a013 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -156,6 +156,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_feature_incompat, 0);
 	set_field(s_feature_ro_compat, 0);
 	set_field(s_first_meta_bg, 0);
+	set_field(s_flex_bg_size, 0);
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9e2d7a8..7319832 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -96,7 +96,7 @@ static void usage(void)
 {
 	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
 	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
-	"[-j] [-J journal-options]\n"
+	"[-j] [-J journal-options] [-G meta group size]\n"
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
@@ -912,6 +912,7 @@ static void PRS(int argc, char *argv[])
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
+	unsigned long	flex_bg_size = 0;
 	double		reserved_ratio = 5.0;
 	int		sector_size = 0;
 	int		show_version_only = 0;
@@ -994,7 +995,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:G:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1045,6 +1046,19 @@ static void PRS(int argc, char *argv[])
 				exit(1);
 			}
 			break;
+		case 'G':
+			flex_bg_size = strtoul(optarg, &tmp, 0);
+			if (*tmp) {
+				com_err(program_name, 0,
+					_("Illegal number for Flex_BG size"));
+				exit(1);
+			}
+			if ((flex_bg_size & (flex_bg_size-1)) != 0) {
+				com_err(program_name, 0,
+					_("Flex_BG size must be a power of 2"));
+				exit(1);
+			}
+			break;
 		case 'i':
 			inode_ratio = strtoul(optarg, &tmp, 0);
 			if (inode_ratio < EXT2_MIN_BLOCK_SIZE ||
@@ -1444,6 +1458,10 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
+	if(flex_bg_size) {
+		fs_param.s_flex_bg_size = ext2fs_swab16(flex_bg_size);
+	}
+
 	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"

--MP_/6xuFrXKAaFL9I19txq2QF2T--
