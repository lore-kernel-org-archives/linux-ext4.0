From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] New inode allocation for FLEX_BG meta-data groups.
Date: Fri, 11 Jan 2008 11:28:18 -0600
Message-ID: <20080111112818.0cdeadbd@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47540 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbYAKR21 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2008 12:28:27 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0BHSLpv015294
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 12:28:21 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0BHSLw7091632
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 12:28:21 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0BHSLaQ017997
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 12:28:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 8eef19455beb97319a78511b35b1da42a1d48eb2
Author: Jose R. Santos <jrs@us.ibm.com>
Date:   Fri Jan 11 11:04:25 2008 -0600

    New inode allocation for FLEX_BG meta-data groups.
    
    This patch mostly controls the way inode are allocated in order to
    make ialloc aware of flex_bg block group grouping.  It achieves this
    by bypassing the Orlov allocator when block group meta-data are packed
    toghether through mke2fs.  Since the impact on the block allocator is
    minimal, this patch should have little or no effect on other block
    allocation algorithms. By controlling the inode allocation, it can
    basically control where the initial search for new block begins and
    thus indirectly manipulate the block allocator.
    
    This allocator favors data and meta-data locality so the disk will
    gradually be filled from block group zero upward.  This helps improve
    performance by reducing seek time.  Since the group of inode tables
    within one flex_bg are treated as one giant inode table, uninitialized
    block groups would not need to partially initialize as many inode
    table as with Orlov which would help fsck time as the filesystem usage
    goes up.
    
    Singed-off-by: Jose R. Santos <jrs@us.ibm.com>
    Singed-off-by: Valerie Clement <valerie.clement@bull.net>

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 643046b..aed3456 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -127,6 +127,8 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
 	}
 
+	if (sbi->s_log_groups_per_flex)
+		return free_blocks;
 	return free_blocks - sbi->s_itb_per_group - 2;
 }
 
@@ -759,6 +761,13 @@ do_more:
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
+	if (sbi->s_log_groups_per_flex) {
+		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
+		spin_lock(sb_bgl_lock(sbi, flex_group));
+		sbi->s_flex_groups[flex_group].free_blocks += count;
+		spin_unlock(sb_bgl_lock(sbi, flex_group));
+	}
+
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
@@ -1829,6 +1838,13 @@ allocated:
 	spin_unlock(sb_bgl_lock(sbi, group_no));
 	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
+	if (sbi->s_log_groups_per_flex) {
+		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
+		spin_lock(sb_bgl_lock(sbi, flex_group));
+		sbi->s_flex_groups[flex_group].free_blocks -= num;
+		spin_unlock(sb_bgl_lock(sbi, flex_group));
+	}
+
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext4_journal_dirty_metadata(handle, gdp_bh);
 	if (!fatal)
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 575b521..d4e8dea 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -158,6 +158,7 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 	struct ext4_super_block * es;
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err;
+	ext4_group_t flex_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
 		printk ("ext4_free_inode: inode has count=%d\n",
@@ -235,6 +236,12 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 			if (is_directory)
 				percpu_counter_dec(&sbi->s_dirs_counter);
 
+			if (sbi->s_log_groups_per_flex) {
+				flex_group = ext4_flex_group(sbi, block_group);
+				spin_lock(sb_bgl_lock(sbi, flex_group));
+				sbi->s_flex_groups[flex_group].free_inodes++;
+				spin_unlock(sb_bgl_lock(sbi, flex_group));
+			}
 		}
 		BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
 		err = ext4_journal_dirty_metadata(handle, bh2);
@@ -289,6 +296,75 @@ static int find_group_dir(struct super_block *sb, struct inode *parent,
 	return ret;
 }
 
+#define free_block_ratio 10
+
+static int find_group_flex(struct super_block *sb, struct inode *parent, ext4_group_t *best_group)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *desc;
+	struct buffer_head *bh;
+	struct flex_groups *flex_group = sbi->s_flex_groups;
+	ext4_group_t parent_group = EXT4_I(parent)->i_block_group;
+	ext4_group_t parent_fbg_group = ext4_flex_group(sbi, parent_group);
+	ext4_group_t ngroups = sbi->s_groups_count;
+	int flex_size = ext4_flex_bg_size(sbi);
+	ext4_group_t best_flex = parent_fbg_group;
+	int blocks_per_flex = sbi->s_blocks_per_group * flex_size;
+	int flex_freeb_ratio;
+	ext4_group_t n_fbg_groups;
+	ext4_group_t i;
+
+	n_fbg_groups = (sbi->s_groups_count + flex_size - 1) / flex_size;
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
+			goto found_flexbg;
+		}
+
+		if (best_flex < 0 ||
+		    (flex_group[i].free_blocks >
+		     flex_group[best_flex].free_blocks &&
+		     flex_group[i].free_inodes))
+			best_flex = i;
+	}
+
+	if (!flex_group[best_flex].free_inodes || 
+	    !flex_group[best_flex].free_blocks)
+		return -1;
+
+found_flexbg:
+	for (i = best_flex * flex_size; i < ngroups &&
+		     i < (best_flex + 1) * flex_size; i++) {
+		desc = ext4_get_group_desc(sb, i, &bh);
+		if (le16_to_cpu(desc->bg_free_inodes_count)) {
+			*best_group = i;
+			goto out;
+		}
+	}
+	
+	return -1;
+out:
+	return 0;
+}
+
 /*
  * Orlov's allocator for directories.
  *
@@ -504,6 +580,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
+	ext4_group_t flex_group;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -517,6 +594,12 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 
 	sbi = EXT4_SB(sb);
 	es = sbi->s_es;
+
+	if (sbi->s_log_groups_per_flex) {
+		ret2 = find_group_flex(sb, dir, &group);
+		goto got_group;
+	}
+
 	if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
 			ret2 = find_group_dir(sb, dir, &group);
@@ -525,6 +608,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	} else
 		ret2 = find_group_other(sb, dir, &group);
 
+got_group:
 	err = -ENOSPC;
 	if (ret2 == -1)
 		goto out;
@@ -681,6 +765,13 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
 
+	if (sbi->s_log_groups_per_flex) {
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
index 8888ca5..05c4b3b 100644
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
@@ -1429,6 +1430,54 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	return res;
 }
 
+static int ext4_fill_flex_info(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *gdp = NULL;
+	struct buffer_head *bh;
+	ext4_group_t flex_group_count;
+	ext4_group_t flex_group;
+	int groups_per_flex = 0;
+	__u64 block_bitmap = 0;
+	int i;
+
+	if (!sbi->s_es->s_log_groups_per_flex) {
+		sbi->s_log_groups_per_flex = 0;
+		return 1;
+	}
+
+	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
+	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
+
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
@@ -2105,6 +2154,13 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
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
index 7c7c6b5..9160db3 100644
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
@@ -623,7 +632,10 @@ struct ext4_super_block {
 	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
 	__le64  s_mmp_block;            /* Block for multi-mount protection */
 	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
-	__u32   s_reserved[163];        /* Padding to the end of the block */
+	__u8	s_log_groups_per_flex;  /* FLEX_BG group size */
+	__u8	s_reserved_char_pad2;
+	__le16  s_reserved_pad;
+	__u32   s_reserved[162];        /* Padding to the end of the block */
 };
 
 #ifdef __KERNEL__
@@ -1121,6 +1133,17 @@ static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
 	raw_inode->i_size_high = cpu_to_le32(i_size >> 32);
 }
 
+static inline ext4_group_t ext4_flex_group(struct ext4_sb_info *sbi,
+					     ext4_group_t block_group)
+{
+	return block_group >> sbi->s_log_groups_per_flex;
+}
+
+static inline unsigned int ext4_flex_bg_size(struct ext4_sb_info *sbi)
+{
+	return 1 << sbi->s_log_groups_per_flex;
+}
+
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index 3bc6583..d750d2c 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -143,6 +143,9 @@ struct ext4_sb_info {
 
 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
+
+	unsigned int s_log_groups_per_flex;
+	struct flex_groups *s_flex_groups;
 };
 #define EXT4_GROUP_INFO(sb, group)					   \
 	EXT4_SB(sb)->s_group_info[(group) >> EXT4_DESC_PER_BLOCK_BITS(sb)] \
