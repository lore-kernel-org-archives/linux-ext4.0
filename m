From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 19/23] ext4: rename ext4_count_free_blocks() to ext4_count_free_clusters()
Date: Wed,  6 Jul 2011 12:36:02 -0400
Message-ID: <1309970166-11770-20-git-send-email-tytso@mit.edu>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33452 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab1GFQgJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2011 12:36:09 -0400
In-Reply-To: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This function really counts the free clusters reported in the block
group descriptors, so rename it to reduce confusion.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c |   11 ++++++-----
 fs/ext4/ext4.h   |    2 +-
 fs/ext4/inode.c  |    6 +++---
 fs/ext4/super.c  |    7 ++++---
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 84dc3d6..4f30380 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -524,12 +524,12 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 }
 
 /**
- * ext4_count_free_blocks() -- count filesystem free blocks
+ * ext4_count_free_clusters() -- count filesystem free clusters
  * @sb:		superblock
  *
- * Adds up the number of free blocks from each block group.
+ * Adds up the number of free clusters from each block group.
  */
-ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
+ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 {
 	ext4_fsblk_t desc_count;
 	struct ext4_group_desc *gdp;
@@ -562,8 +562,9 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
-	printk(KERN_DEBUG "ext4_count_free_blocks: stored = %llu"
-		", computed = %llu, %llu\n", ext4_free_blocks_count(es),
+	printk(KERN_DEBUG "ext4_count_free_clusters: stored = %llu"
+	       ", computed = %llu, %llu\n",
+	       EXT4_B2C(sbi, ext4_free_blocks_count(es)),
 	       desc_count, bitmap_count);
 	return bitmap_count;
 #else
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 290b7e4..04bf654 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1760,7 +1760,7 @@ extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 					 int *errp);
 extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 				  s64 nblocks, unsigned int flags);
-extern ext4_fsblk_t ext4_count_free_blocks(struct super_block *);
+extern ext4_fsblk_t ext4_count_free_clusters(struct super_block *);
 extern void ext4_check_blocks_bitmap(struct super_block *);
 extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 						    ext4_group_t block_group,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 513f4e6..1cbad80 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1327,7 +1327,8 @@ static void ext4_print_free_blocks(struct inode *inode)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	printk(KERN_CRIT "Total free blocks count %lld\n",
-	       ext4_count_free_blocks(inode->i_sb));
+	       EXT4_C2B(EXT4_SB(inode->i_sb),
+			ext4_count_free_clusters(inode->i_sb)));
 	printk(KERN_CRIT "Free/Dirty block details\n");
 	printk(KERN_CRIT "free_blocks=%lld\n",
 	       (long long) EXT4_C2B(EXT4_SB(inode->i_sb),
@@ -1413,8 +1414,7 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 		if (err == -EAGAIN)
 			goto submit_io;
 
-		if (err == -ENOSPC &&
-		    ext4_count_free_blocks(sb)) {
+		if (err == -ENOSPC && ext4_count_free_clusters(sb)) {
 			mpd->retval = err;
 			goto submit_io;
 		}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3f02afa..1d7dc89 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2113,7 +2113,8 @@ static int ext4_check_descriptors(struct super_block *sb,
 	if (NULL != first_not_zeroed)
 		*first_not_zeroed = grp;
 
-	ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb));
+	ext4_free_blocks_count_set(sbi->s_es,
+				   EXT4_C2B(sbi, ext4_count_free_clusters(sb)));
 	sbi->s_es->s_free_inodes_count =cpu_to_le32(ext4_count_free_inodes(sb));
 	return 1;
 }
@@ -3503,7 +3504,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_err_report.data = (unsigned long) sb;
 
 	err = percpu_counter_init(&sbi->s_freeclusters_counter,
-			ext4_count_free_blocks(sb));
+			ext4_count_free_clusters(sb));
 	if (!err) {
 		err = percpu_counter_init(&sbi->s_freeinodes_counter,
 				ext4_count_free_inodes(sb));
@@ -3629,7 +3630,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * need to update the global counters.
 	 */
 	percpu_counter_set(&sbi->s_freeclusters_counter,
-			   ext4_count_free_blocks(sb));
+			   ext4_count_free_clusters(sb));
 	percpu_counter_set(&sbi->s_freeinodes_counter,
 			   ext4_count_free_inodes(sb));
 	percpu_counter_set(&sbi->s_dirs_counter,
-- 
1.7.4.1.22.gec8e1.dirty

