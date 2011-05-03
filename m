From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 18/19] ext4: rename ext4_count_free_blocks() to ext4_count_free_clusters()
Date: Tue,  3 May 2011 18:24:48 -0400
Message-ID: <1304461490-11056-19-git-send-email-tytso@mit.edu>
References: <1304461490-11056-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58142 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1ECWY6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 18:24:58 -0400
In-Reply-To: <1304461490-11056-1-git-send-email-tytso@mit.edu>
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
index 171dd6a..253f80e 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -643,12 +643,12 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
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
@@ -681,8 +681,9 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
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
index cd2ba30..f8c51bb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1680,7 +1680,7 @@ extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
 extern void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 				ext4_fsblk_t block, unsigned long count);
-extern ext4_fsblk_t ext4_count_free_blocks(struct super_block *);
+extern ext4_fsblk_t ext4_count_free_clusters(struct super_block *);
 extern void ext4_check_blocks_bitmap(struct super_block *);
 extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 						    ext4_group_t block_group,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cc5910d..86edc01 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2208,7 +2208,8 @@ static void ext4_print_free_blocks(struct inode *inode)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	printk(KERN_CRIT "Total free blocks count %lld\n",
-	       ext4_count_free_blocks(inode->i_sb));
+	       EXT4_C2B(EXT4_SB(inode->i_sb),
+			ext4_count_free_clusters(inode->i_sb)));
 	printk(KERN_CRIT "Free/Dirty block details\n");
 	printk(KERN_CRIT "free_blocks=%lld\n",
 	       (long long) EXT4_C2B(EXT4_SB(inode->i_sb),
@@ -2293,8 +2294,7 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 		if (err == -EAGAIN)
 			goto submit_io;
 
-		if (err == -ENOSPC &&
-		    ext4_count_free_blocks(sb)) {
+		if (err == -ENOSPC && ext4_count_free_clusters(sb)) {
 			mpd->retval = err;
 			goto submit_io;
 		}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 30b7c81..3ad6b3c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2111,7 +2111,8 @@ static int ext4_check_descriptors(struct super_block *sb,
 	if (NULL != first_not_zeroed)
 		*first_not_zeroed = grp;
 
-	ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb));
+	ext4_free_blocks_count_set(sbi->s_es,
+				   EXT4_C2B(sbi, ext4_count_free_clusters(sb)));
 	sbi->s_es->s_free_inodes_count =cpu_to_le32(ext4_count_free_inodes(sb));
 	return 1;
 }
@@ -3500,7 +3501,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_err_report.data = (unsigned long) sb;
 
 	err = percpu_counter_init(&sbi->s_freeclusters_counter,
-			ext4_count_free_blocks(sb));
+			ext4_count_free_clusters(sb));
 	if (!err) {
 		err = percpu_counter_init(&sbi->s_freeinodes_counter,
 				ext4_count_free_inodes(sb));
@@ -3622,7 +3623,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * need to update the global counters.
 	 */
 	percpu_counter_set(&sbi->s_freeclusters_counter,
-			   ext4_count_free_blocks(sb));
+			   ext4_count_free_clusters(sb));
 	percpu_counter_set(&sbi->s_freeinodes_counter,
 			   ext4_count_free_inodes(sb));
 	percpu_counter_set(&sbi->s_dirs_counter,
-- 
1.7.3.1

