From: Valerie Clement <Valerie.Clement@bull.net>
Subject: [RFC][PATCH 4/4] BIG_BG: block group descriptor modifications
Date: 24 Nov 2006 17:48:38 +0100
Message-ID: <1164386918.17961.79.camel@ckrm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33711 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S965326AbWKXQ6W
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Nov 2006 11:58:22 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 106FA19D931
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:58:18 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21174-02 for <linux-ext4@vger.kernel.org>;
 Fri, 24 Nov 2006 17:58:11 +0100 (CET)
Received: from ckrm.frec.bull.fr (unknown [172.16.109.44])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 2624619D932
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:58:11 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds the high 16 bits for the free block/inode counts and for the used directory count in the block group descriptor to support larger block
groups.


Signed-off-by: Valerie Clement <valerie.clement@bull.net>

 fs/ext4/balloc.c        |   22 +++++------
 fs/ext4/ialloc.c        |   89 ++++++++++++++++++++++++++++++------------------
 fs/ext4/resize.c        |    4 +-
 include/linux/ext4_fs.h |   28 +++++++++++++++
 4 files changed, 96 insertions(+), 47 deletions(-)

Index: linux-2.6.19-rc6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/balloc.c	2006-11-17 12:14:07.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/balloc.c	2006-11-17 12:14:14.000000000 +0100
@@ -623,9 +623,7 @@ do_more_bitmap:
 	}
 
 	spin_lock(sb_bgl_lock(sbi, block_group));
-	desc->bg_free_blocks_count =
-		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
-			group_freed);
+	EXT4_ADD_SPLIT_LE32(sb, desc->bg_free_blocks_count, group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 
@@ -1525,7 +1523,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *h
 	struct ext4_sb_info *sbi;
 	struct ext4_reserve_window_node *my_rsv = NULL;
 	struct ext4_block_alloc_info *block_i;
-	unsigned short windowsz = 0;
+	unsigned long windowsz = 0;
 #ifdef EXT4FS_DEBUG
 	static int goal_hits, goal_attempts;
 #endif
@@ -1580,7 +1578,7 @@ retry_alloc:
 	if (!gdp)
 		goto io_error;
 
-	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+	free_blocks = EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_blocks_count);
 	/*
 	 * if there is not enough free blocks to make a new resevation
 	 * turn off reservation for this allocation
@@ -1615,7 +1613,7 @@ retry_alloc:
 			*errp = -EIO;
 			goto out;
 		}
-		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+		free_blocks = EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_blocks_count);
 		/*
 		 * skip this group if the number of
 		 * free blocks is less than half of the reservation
@@ -1654,7 +1652,8 @@ retry_alloc:
 allocated:
 
 	ext4_debug("using block group %d(%d)\n",
-			group_no, gdp->bg_free_blocks_count);
+			group_no,
+			EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_blocks_count));
 
 	BUFFER_TRACE(gdp_bh, "get_write_access");
 	fatal = ext4_journal_get_write_access(handle, gdp_bh);
@@ -1712,8 +1711,7 @@ allocated:
 			ret_block, goal_hits, goal_attempts);
 
 	spin_lock(sb_bgl_lock(sbi, group_no));
-	gdp->bg_free_blocks_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
+	EXT4_SUB_SPLIT_LE32(sb, gdp->bg_free_blocks_count, num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, -num);
 
@@ -1782,7 +1780,7 @@ ext4_fsblk_t ext4_count_free_blocks(stru
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		if (!gdp)
 			continue;
-		desc_count += le16_to_cpu(gdp->bg_free_blocks_count);
+		desc_count += EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_blocks_count);
 		for (j = 0, x = 0;
 		     j < (EXT4_BLOCKS_PER_GROUP(sb) >> EXT4_BITS_PER_BLOCK_BITS(sb));
 		     j++) {
@@ -1793,7 +1791,7 @@ ext4_fsblk_t ext4_count_free_blocks(stru
 			x += ext4_count_free(bitmap_bh, sb->s_blocksize);
 		}
 		printk("group %d: stored = %d, counted = %lu\n",
-			i, le16_to_cpu(gdp->bg_free_blocks_count), x);
+			i, EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_blocks_count), x);
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
@@ -1809,7 +1807,7 @@ ext4_fsblk_t ext4_count_free_blocks(stru
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		if (!gdp)
 			continue;
-		desc_count += le16_to_cpu(gdp->bg_free_blocks_count);
+		desc_count += EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_blocks_count);
 	}
 
 	return desc_count;
Index: linux-2.6.19-rc6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/ialloc.c	2006-11-17 12:14:11.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/ialloc.c	2006-11-17 12:14:14.000000000 +0100
@@ -168,11 +168,9 @@ void ext4_free_inode (handle_t *handle, 
 
 		if (gdp) {
 			spin_lock(sb_bgl_lock(sbi, block_group));
-			gdp->bg_free_inodes_count = cpu_to_le16(
-				le16_to_cpu(gdp->bg_free_inodes_count) + 1);
+			EXT4_INC_SPLIT_LE32(sb, gdp->bg_free_inodes_count);
 			if (is_directory)
-				gdp->bg_used_dirs_count = cpu_to_le16(
-				  le16_to_cpu(gdp->bg_used_dirs_count) - 1);
+				EXT4_DEC_SPLIT_LE32(sb, gdp->bg_used_dirs_count);
 			spin_unlock(sb_bgl_lock(sbi, block_group));
 			percpu_counter_inc(&sbi->s_freeinodes_counter);
 			if (is_directory)
@@ -221,8 +219,8 @@ static int find_group_dir(struct super_b
 		if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
 			continue;
 		if (!best_desc ||
-		    (le16_to_cpu(desc->bg_free_blocks_count) >
-		     le16_to_cpu(best_desc->bg_free_blocks_count))) {
+		    (EXT4_READ_SPLIT_LE32(sb, desc->bg_free_blocks_count) >
+		     EXT4_READ_SPLIT_LE32(sb, best_desc->bg_free_blocks_count))) {
 			best_group = group;
 			best_desc = desc;
 		}
@@ -274,6 +272,7 @@ static int find_group_orlov(struct super
 	int group = -1, i;
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh;
+	__u32 free_blocks, free_inodes;
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
@@ -292,16 +291,22 @@ static int find_group_orlov(struct super
 		for (i = 0; i < ngroups; i++) {
 			group = (parent_group + i) % ngroups;
 			desc = ext4_get_group_desc (sb, group, &bh);
-			if (!desc || !desc->bg_free_inodes_count)
+			if (!desc)
 				continue;
-			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
+			free_inodes =
+				EXT4_READ_SPLIT_LE32(sb, desc->bg_free_inodes_count);
+			if (!free_inodes)
 				continue;
-			if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
+			if (EXT4_READ_SPLIT_LE32(sb, desc->bg_used_dirs_count) >= best_ndir)
 				continue;
-			if (le16_to_cpu(desc->bg_free_blocks_count) < avefreeb)
+			if (free_inodes < avefreei)
+				continue;
+			free_blocks =
+				EXT4_READ_SPLIT_LE32(sb, desc->bg_free_blocks_count);
+			if (free_blocks < avefreeb)
 				continue;
 			best_group = group;
-			best_ndir = le16_to_cpu(desc->bg_used_dirs_count);
+			best_ndir = EXT4_READ_SPLIT_LE32(sb, desc->bg_used_dirs_count);
 		}
 		if (best_group >= 0)
 			return best_group;
@@ -327,13 +332,17 @@ static int find_group_orlov(struct super
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc (sb, group, &bh);
-		if (!desc || !desc->bg_free_inodes_count)
+		if (!desc)
+			continue;
+		free_inodes = EXT4_READ_SPLIT_LE32(sb, desc->bg_free_inodes_count);
+		if (!free_inodes)
 			continue;
-		if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
+		if (EXT4_READ_SPLIT_LE32(sb, desc->bg_used_dirs_count) >= max_dirs)
 			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) < min_inodes)
+		if (free_inodes < min_inodes)
 			continue;
-		if (le16_to_cpu(desc->bg_free_blocks_count) < min_blocks)
+		free_blocks = EXT4_READ_SPLIT_LE32(sb, desc->bg_free_blocks_count);
+		if (free_blocks < min_blocks)
 			continue;
 		return group;
 	}
@@ -342,9 +351,12 @@ fallback:
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc (sb, group, &bh);
-		if (!desc || !desc->bg_free_inodes_count)
+		if (!desc)
+			continue;
+		free_inodes = EXT4_READ_SPLIT_LE32(sb, desc->bg_free_inodes_count);
+		if (!free_inodes)
 			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
+		if (free_inodes >= avefreei)
 			return group;
 	}
 
@@ -367,15 +379,19 @@ static int find_group_other(struct super
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh;
 	int group, i;
+	__u32 free_inodes, free_blocks;
 
 	/*
 	 * Try to place the inode in its parent directory
 	 */
 	group = parent_group;
 	desc = ext4_get_group_desc (sb, group, &bh);
-	if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
-			le16_to_cpu(desc->bg_free_blocks_count))
-		return group;
+	if (desc) {
+		free_inodes = EXT4_READ_SPLIT_LE32(sb, desc->bg_free_inodes_count);
+		free_blocks = EXT4_READ_SPLIT_LE32(sb, desc->bg_free_blocks_count);
+		if (free_inodes && free_blocks)
+			return group;
+	}
 
 	/*
 	 * We're going to place this inode in a different blockgroup from its
@@ -397,9 +413,14 @@ static int find_group_other(struct super
 		if (group >= ngroups)
 			group -= ngroups;
 		desc = ext4_get_group_desc (sb, group, &bh);
-		if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
-				le16_to_cpu(desc->bg_free_blocks_count))
-			return group;
+		if (desc) {
+			free_inodes =
+				EXT4_READ_SPLIT_LE32(sb, desc->bg_free_inodes_count);
+			free_blocks =
+				EXT4_READ_SPLIT_LE32(sb, desc->bg_free_blocks_count);
+			if (free_inodes && free_blocks)
+				return group;
+		}
 	}
 
 	/*
@@ -411,8 +432,12 @@ static int find_group_other(struct super
 		if (++group >= ngroups)
 			group = 0;
 		desc = ext4_get_group_desc (sb, group, &bh);
-		if (desc && le16_to_cpu(desc->bg_free_inodes_count))
-			return group;
+		if (desc) {
+			free_inodes =
+				EXT4_READ_SPLIT_LE32(sb, desc->bg_free_inodes_count);
+			if (free_inodes)
+				return group;
+		}
 	}
 
 	return -1;
@@ -546,11 +571,9 @@ got:
 	err = ext4_journal_get_write_access(handle, bh2);
 	if (err) goto fail;
 	spin_lock(sb_bgl_lock(sbi, group));
-	gdp->bg_free_inodes_count =
-		cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
+	EXT4_DEC_SPLIT_LE32(sb, gdp->bg_free_inodes_count);
 	if (S_ISDIR(mode)) {
-		gdp->bg_used_dirs_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_used_dirs_count) + 1);
+		EXT4_INC_SPLIT_LE32(sb, gdp->bg_used_dirs_count);
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 	BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
@@ -743,7 +766,7 @@ unsigned long ext4_count_free_inodes (st
 		gdp = ext4_get_group_desc (sb, i, NULL);
 		if (!gdp)
 			continue;
-		desc_count += le16_to_cpu(gdp->bg_free_inodes_count);
+		desc_count += EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_inodes_count);
 		for (j = 0, x = 0; j < EXT4_INODE_BITMAP_PER_GROUP(sb); j++) {
 			brelse(bitmap_bh);
 			bitmap_bh = read_inode_bitmap(sb, i, j);
@@ -753,7 +776,7 @@ unsigned long ext4_count_free_inodes (st
 			x += ext4_count_free(bitmap_bh, EXT4_INODE_BITMAP_NBYTES(sb));
 		}
 		printk("group %d: stored = %d, counted = %lu\n",
-			i, le16_to_cpu(gdp->bg_free_inodes_count), x);
+			i, EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_inodes_count), x);
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
@@ -766,7 +789,7 @@ unsigned long ext4_count_free_inodes (st
 		gdp = ext4_get_group_desc (sb, i, NULL);
 		if (!gdp)
 			continue;
-		desc_count += le16_to_cpu(gdp->bg_free_inodes_count);
+		desc_count += EXT4_READ_SPLIT_LE32(sb, gdp->bg_free_inodes_count);
 		cond_resched();
 	}
 	return desc_count;
@@ -783,7 +806,7 @@ unsigned long ext4_count_dirs (struct su
 		struct ext4_group_desc *gdp = ext4_get_group_desc (sb, i, NULL);
 		if (!gdp)
 			continue;
-		count += le16_to_cpu(gdp->bg_used_dirs_count);
+		count += EXT4_READ_SPLIT_LE32(sb, gdp->bg_used_dirs_count);
 	}
 	return count;
 }
Index: linux-2.6.19-rc6/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.19-rc6.orig/include/linux/ext4_fs.h	2006-11-17 12:14:07.000000000 +0100
+++ linux-2.6.19-rc6/include/linux/ext4_fs.h	2006-11-17 12:14:14.000000000 +0100
@@ -133,6 +133,9 @@ struct ext4_group_desc
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
 	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
 	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
+	__le16	bg_free_blocks_count_hi;	/* Free blocks count MSB */
+	__le16	bg_free_inodes_count_hi;	/* Free inodes count MSB */
+	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
 };
 
 #ifdef __KERNEL__
@@ -163,6 +166,31 @@ struct ext4_group_desc
 # define EXT4_INODES_PER_GROUP(s)	((s)->s_inodes_per_group)
 #endif
 
+#define EXT4_READ_SPLIT_LE32(__sb, __field)	\
+	((__u32)le16_to_cpu(__field) +		\
+	 (EXT4_HAS_INCOMPAT_FEATURE((__sb), EXT4_FEATURE_INCOMPAT_64BIT) ? \
+	 (__u32)le16_to_cpu(__field##_hi) << 16 : 0))
+
+#define EXT4_WRITE_SPLIT_LE32(__sb, __field,__value)	\
+do { \
+	__u32 __tmp = __value; \
+	__field = cpu_to_le16((__tmp) & 0xFFFF);	\
+	if (EXT4_HAS_INCOMPAT_FEATURE((__sb), EXT4_FEATURE_INCOMPAT_64BIT)) \
+		__field##_hi = cpu_to_le16((__u32)(__tmp) >> 16); \
+} while(0)
+
+#define EXT4_ADD_SPLIT_LE32(__sb, __field,__value)	\
+	EXT4_WRITE_SPLIT_LE32(__sb, __field,		\
+			EXT4_READ_SPLIT_LE32(__sb, __field) + (__u32)__value)
+
+#define EXT4_SUB_SPLIT_LE32(__sb, __field,__value)	\
+	EXT4_WRITE_SPLIT_LE32(__sb, __field,		\
+			EXT4_READ_SPLIT_LE32(__sb, __field) - (__u32)__value)
+
+#define EXT4_DEC_SPLIT_LE32(__sb, __field) EXT4_SUB_SPLIT_LE32(__sb, __field,1)
+
+#define EXT4_INC_SPLIT_LE32(__sb, __field) EXT4_ADD_SPLIT_LE32(__sb, __field,1)
+
 /*
  * Constants relative to the data blocks
  */
Index: linux-2.6.19-rc6/fs/ext4/resize.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/resize.c	2006-11-17 12:13:47.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/resize.c	2006-11-17 12:14:14.000000000 +0100
@@ -842,8 +842,8 @@ int ext4_group_add(struct super_block *s
 	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
 	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
 	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
-	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
-	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
+	EXT4_WRITE_SPLIT_LE32(sb, gdp->bg_free_blocks_count, input->free_blocks_count);
+	EXT4_WRITE_SPLIT_LE32(sb, gdp->bg_free_inodes_count, EXT4_INODES_PER_GROUP(sb));
 
 	/*
 	 * Make the new blocks and inodes valid next.  We do this before
