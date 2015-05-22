From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext4: Improve scalability of ext4 orphan file handling
Date: Fri, 22 May 2015 13:21:57 +0200
Message-ID: <1432293717-24010-5-git-send-email-jack@suse.cz>
References: <1432293717-24010-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495AbbEVLWJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 07:22:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0681AAD5C
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 11:22:08 +0000 (UTC)
In-Reply-To: <1432293717-24010-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Even though the length of the critical section when adding / removing
orphaned inodes was significantly reduced by using orphan file, the
contention of lock protecting orphan file still appears high in profiles
for truncate / unlink intensive workloads with high number of threads.

This patch makes handling of orphan file completely lockless. Also to
reduce conflicts between CPUs different CPUs start searching for empty
slot in orphan file in different blocks.

Performance comparison of locked orphan file handling, lockless orphan
file handling, and completely disabled orphan inode handling
from 48 CPU Xeon Server with 32 GB of RAM, filesystem located on
ramdisk, average of 5 runs:

stress-orphan (microbenchmark truncating files byte-by-byte from N
processes in parallel)

Threads Time            Time            Time
        Orphan locked   Orphan lockless No orphan
  1       1.260000       1.379800	 1.287000
  2       2.455000       2.323800        2.314400
  4       3.848400       3.704000        3.680400
  8       6.833000       6.711800        6.844600
 16      12.883200      12.931400       13.131600
 32      25.342200      22.521600       22.570200
 64      50.918400      36.380000       36.106200
128     102.666000      71.349800       71.716800

So we can see that with lockless orphan file handling, addition /
deletion of orphaned inodes got completely out of picture even for a
microbenchmark stressing it.

reaim new_fserver workload didn't show any gains / losses outside of
error margin.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h   |  3 +--
 fs/ext4/orphan.c | 51 +++++++++++++++++++++++++++------------------------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b48b250e784e..898af52c09d1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1251,7 +1251,7 @@ static inline int ext4_inodes_per_orphan_block(struct super_block *sb)
 }
 
 struct ext4_orphan_block {
-	int ob_free_entries;	/* Number of free orphan entries in block */
+	atomic_t ob_free_entries;	/* Number of free orphan entries in block */
 	struct buffer_head *ob_bh;	/* Buffer for orphan block */
 };
 
@@ -1260,7 +1260,6 @@ struct ext4_orphan_block {
  * for running and once for committing transaction
  */
 struct ext4_orphan_info {
-	spinlock_t of_lock;
 	int of_blocks;			/* Number of orphan blocks in a file */
 	__u32 of_csum_seed;		/* Checksum seed for orphan file */
 	struct ext4_orphan_block *of_binfo;	/* Array with info about orphan
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 23d504e12fcd..6392521bdceb 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -10,16 +10,26 @@
 
 static int ext4_orphan_file_add(handle_t *handle, struct inode *inode)
 {
-	int i, j;
+	int i, j, start;
 	struct ext4_orphan_info *oi = &EXT4_SB(inode->i_sb)->s_orphan_info;
 	int ret = 0;
 	__le32 *bdata;
 	int inodes_per_ob = ext4_inodes_per_orphan_block(inode->i_sb);
 
-	spin_lock(&oi->of_lock);
-	for (i = 0; i < oi->of_blocks && !oi->of_binfo[i].ob_free_entries; i++);
-	if (i == oi->of_blocks) {
-		spin_unlock(&oi->of_lock);
+	/*
+	 * Find block with free orphan entry. Use CPU number for a naive hash
+	 * for a search start in the orphan file
+	 */
+	start = raw_smp_processor_id()*13 % oi->of_blocks;
+	i = start;
+	do {
+		if (atomic_dec_if_positive(&oi->of_binfo[i].ob_free_entries)
+		    >= 0)
+			break;
+		if (++i >= oi->of_blocks)
+			i = 0;
+	} while (i != start);
+	if (i == start) {
 		/*
 		 * For now we don't grow or shrink orphan file. We just use
 		 * whatever was allocated at mke2fs time. The additional
@@ -28,28 +38,24 @@ static int ext4_orphan_file_add(handle_t *handle, struct inode *inode)
 		 */
 		return -ENOSPC;
 	}
-	oi->of_binfo[i].ob_free_entries--;
-	spin_unlock(&oi->of_lock);
 
-	/*
-	 * Get access to orphan block. We have dropped of_lock but since we
-	 * have decremented number of free entries we are guaranteed free entry
-	 * in our block.
-	 */
 	ret = ext4_journal_get_write_access(handle, inode->i_sb,
 				oi->of_binfo[i].ob_bh, EXT4_JTR_ORPHAN_FILE);
 	if (ret)
 		return ret;
 
 	bdata = (__le32 *)(oi->of_binfo[i].ob_bh->b_data);
-	spin_lock(&oi->of_lock);
 	/* Find empty slot in a block */
-	for (j = 0; j < inodes_per_ob && bdata[j]; j++);
-	BUG_ON(j == inodes_per_ob);
-	bdata[j] = cpu_to_le32(inode->i_ino);
+	j = 0;
+	do {
+		while (bdata[j]) {
+			if (++j >= inodes_per_ob)
+				j = 0;
+		}
+	} while (cmpxchg(&bdata[j], 0, cpu_to_le32(inode->i_ino)) != 0);
+
 	EXT4_I(inode)->i_orphan_idx = i * inodes_per_ob + j;
 	ext4_set_inode_state(inode, EXT4_STATE_ORPHAN_FILE);
-	spin_unlock(&oi->of_lock);
 
 	return ext4_handle_dirty_metadata(handle, NULL, oi->of_binfo[i].ob_bh);
 }
@@ -173,10 +179,8 @@ static int ext4_orphan_file_del(handle_t *handle, struct inode *inode)
 		goto out;
 
 	bdata = (__le32 *)(oi->of_binfo[blk].ob_bh->b_data);
-	spin_lock(&oi->of_lock);
 	bdata[off] = 0;
-	oi->of_binfo[blk].ob_free_entries++;
-	spin_unlock(&oi->of_lock);
+	atomic_inc(&oi->of_binfo[blk].ob_free_entries);
 	ret = ext4_handle_dirty_metadata(handle, NULL, oi->of_binfo[blk].ob_bh);
 out:
 	ext4_clear_inode_state(inode, EXT4_STATE_ORPHAN_FILE);
@@ -494,8 +498,6 @@ int ext4_init_orphan_info(struct super_block *sb)
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 	struct ext4_orphan_block_tail *ot;
 
-	spin_lock_init(&oi->of_lock);
-
 	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_ORPHAN_FILE))
 		return 0;
 
@@ -539,7 +541,7 @@ int ext4_init_orphan_info(struct super_block *sb)
 		for (j = 0; j < inodes_per_ob; j++)
 			if (bdata[j] == 0)
 				free++;
-		oi->of_binfo[i].ob_free_entries = free;
+		atomic_set(&oi->of_binfo[i].ob_free_entries, free);
 	}
 	iput(inode);
 	return 0;
@@ -561,7 +563,8 @@ int ext4_orphan_file_empty(struct super_block *sb)
 	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_ORPHAN_FILE))
 		return 1;
 	for (i = 0; i < oi->of_blocks; i++)
-		if (oi->of_binfo[i].ob_free_entries != inodes_per_ob)
+		if (atomic_read(&oi->of_binfo[i].ob_free_entries) !=
+		    inodes_per_ob)
 			return 0;
 	return 1;
 }
-- 
2.1.4

