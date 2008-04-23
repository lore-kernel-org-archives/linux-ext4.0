From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] commit e8fa6c1ac978815e421c296673ff34776551f4b9
Date: Wed, 23 Apr 2008 12:17:50 -0500
Message-ID: <20080423171750.8494.96870.stgit@freedom>
References: <20080423171522.8494.21796.stgit@freedom>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:60746 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYDWRR5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 13:17:57 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3NHHuIg004784
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 13:17:56 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3NHHuYb215306
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 11:17:56 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3NHHuBT007869
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 11:17:56 -0600
Received: from [127.0.0.1] (freedom.ltc.austin.ibm.com [9.3.191.6])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m3NHHthD007845
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 11:17:56 -0600
In-Reply-To: <20080423171522.8494.21796.stgit@freedom>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


commit e8fa6c1ac978815e421c296673ff34776551f4b9

ext4: New inode allocation for FLEX_BG meta-data groups.

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

    Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
    Signed-off-by: Valerie Clement <valerie.clement@bull.net>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
--

 fs/ext4/balloc.c  |   16 +++++++++
 fs/ext4/ext4.h    |   25 +++++++++++++-
 fs/ext4/ext4_sb.h |    3 ++
 fs/ext4/ialloc.c  |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/mballoc.c |   14 ++++++++
 fs/ext4/super.c   |   57 +++++++++++++++++++++++++++++++
 6 files changed, 210 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 6adf896..3e22d69 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -127,6 +127,8 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
 	}
 
+	if (sbi->s_log_groups_per_flex)
+		return free_blocks;
 	return free_blocks - sbi->s_itb_per_group - 2;
 }
 
@@ -757,6 +759,13 @@ do_more:
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
@@ -1831,6 +1840,13 @@ allocated:
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
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6d4a896..093194b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -175,6 +175,15 @@ struct ext4_group_desc
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
@@ -714,7 +723,10 @@ struct ext4_super_block {
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
@@ -1249,6 +1261,17 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
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
diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 5802e69..7450c62 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -143,6 +143,9 @@ struct ext4_sb_info {
 
 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
+
+	unsigned int s_log_groups_per_flex;
+	struct flex_groups *s_flex_groups;
 };
 
 #endif	/* _EXT4_SB */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index da727f7..e09b111 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -157,6 +157,7 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 	struct ext4_super_block * es;
 	struct ext4_sb_info *sbi;
 	int fatal = 0, err;
+	ext4_group_t flex_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
 		printk ("ext4_free_inode: inode has count=%d\n",
@@ -232,6 +233,12 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
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
@@ -286,6 +293,80 @@ static int find_group_dir(struct super_block *sb, struct inode *parent,
 	return ret;
 }
 
+#define free_block_ratio 10
+
+static int find_group_flex(struct super_block *sb, struct inode *parent,
+			   ext4_group_t *best_group)
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
+	int flexbg_free_blocks;
+	int flex_freeb_ratio;
+	ext4_group_t n_fbg_groups;
+	ext4_group_t i;
+
+	n_fbg_groups = (sbi->s_groups_count + flex_size - 1) >>
+		sbi->s_log_groups_per_flex;
+
+find_close_to_parent:
+	flexbg_free_blocks = flex_group[best_flex].free_blocks;
+	flex_freeb_ratio = flexbg_free_blocks * 100 / blocks_per_flex;
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
+		flexbg_free_blocks = flex_group[i].free_blocks;
+		flex_freeb_ratio = flexbg_free_blocks * 100 / blocks_per_flex;
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
@@ -501,6 +582,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	struct inode *ret;
 	ext4_group_t i;
 	int free = 0;
+	ext4_group_t flex_group;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -514,6 +596,12 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 
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
@@ -522,6 +610,7 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	} else
 		ret2 = find_group_other(sb, dir, &group);
 
+got_group:
 	err = -ENOSPC;
 	if (ret2 == -1)
 		goto out;
@@ -676,6 +765,13 @@ got:
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
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index be446f0..3c03906 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2830,6 +2830,13 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
+	
+	if (sbi->s_log_groups_per_flex) {
+		ext4_group_t flex_group = ext4_flex_group(sbi, ac->ac_b_ex.fe_group);
+		spin_lock(sb_bgl_lock(sbi, flex_group));
+		sbi->s_flex_groups[flex_group].free_blocks -= ac->ac_b_ex.fe_len;
+		spin_unlock(sb_bgl_lock(sbi, flex_group));
+	}
 
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
 	if (err)
@@ -4332,6 +4339,13 @@ do_more:
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
+        if (sbi->s_log_groups_per_flex) {
+                ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
+                spin_lock(sb_bgl_lock(sbi, flex_group));
+                sbi->s_flex_groups[flex_group].free_blocks += count;
+                spin_unlock(sb_bgl_lock(sbi, flex_group));
+        }
+
 	ext4_mb_release_desc(&e4b);
 
 	*freed += count;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c8c8fb9..7585b0e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -517,6 +517,7 @@ static void ext4_put_super (struct super_block * sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
+	kfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -1428,6 +1429,54 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
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
@@ -2130,6 +2179,14 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		printk(KERN_ERR "EXT4-fs: group descriptors corrupted!\n");
 		goto failed_mount2;
 	}
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		if (!ext4_fill_flex_info(sb)) {
+			printk(KERN_ERR
+			       "EXT4-fs: unable to initialize "
+			       "flex_bg meta info!\n");
+			goto failed_mount2;
+		}
+
 	sbi->s_gdb_count = db_count;
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);

