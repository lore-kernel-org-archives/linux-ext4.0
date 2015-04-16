From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] ext4: Improve scalability of ext4 orphan file handling
Date: Thu, 16 Apr 2015 17:42:57 +0200
Message-ID: <1429198977-5637-4-git-send-email-jack@suse.cz>
References: <1429198977-5637-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbbDPPnJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2015 11:43:09 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D0F35ABB3
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2015 15:43:07 +0000 (UTC)
In-Reply-To: <1429198977-5637-1-git-send-email-jack@suse.cz>
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
 fs/ext4/ext4.h  |  2 +-
 fs/ext4/namei.c | 40 ++++++++++++++++++++++++----------------
 fs/ext4/super.c |  5 +++--
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 768a8b9ee2f9..89de44af986c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1220,7 +1220,7 @@ static inline int ext4_inodes_per_orphan_block(struct super_block *sb)
 }
 
 struct ext4_orphan_block {
-	int ob_free_entries;	/* Number of free orphan entries in block */
+	atomic_t ob_free_entries;	/* Number of free orphan entries in block */
 	struct buffer_head *ob_bh;	/* Buffer for orphan block */
 };
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3436b7fa0ef9..0c0649441a0f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2531,20 +2531,27 @@ static int empty_dir(struct inode *inode)
 
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
+	if (i == start)
 		return -ENOSPC;
-	}
-	oi->of_binfo[i].ob_free_entries--;
-	spin_unlock(&oi->of_lock);
 
 	/*
 	 * Get access to orphan block. We have dropped of_lock but since we
@@ -2557,14 +2564,17 @@ static int ext4_orphan_file_add(handle_t *handle, struct inode *inode)
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
@@ -2687,10 +2697,8 @@ static int ext4_orphan_file_del(handle_t *handle, struct inode *inode)
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
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 14c30a9ef509..4d2fcc8483b2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3542,7 +3542,7 @@ static int ext4_init_orphan_info(struct super_block *sb)
 		for (j = 0; j < inodes_per_ob; j++)
 			if (bdata[j] == 0)
 				free++;
-		oi->of_binfo[i].ob_free_entries = free;
+		atomic_set(&oi->of_binfo[i].ob_free_entries, free);
 	}
 	iput(inode);
 	return 0;
@@ -4924,7 +4924,8 @@ static int ext4_orphan_file_empty(struct super_block *sb)
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

