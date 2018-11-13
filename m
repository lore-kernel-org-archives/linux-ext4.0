Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54017 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKAr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:00:47 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 02/10] ext2: fix coding style for balloc.c
Date: Tue, 13 Nov 2018 08:04:40 +0800
Message-Id: <20181113000448.16023-3-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/balloc.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 33db13365c5e..12fd52b9488f 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -38,13 +38,13 @@
 
 #define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
 
-struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
+struct ext2_group_desc *ext2_get_group_desc(struct super_block *sb,
 					     unsigned int block_group,
-					     struct buffer_head ** bh)
+					     struct buffer_head **bh)
 {
 	unsigned long group_desc;
 	unsigned long offset;
-	struct ext2_group_desc * desc;
+	struct ext2_group_desc *desc;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 	if (block_group >= sbi->s_groups_count) {
@@ -125,8 +125,8 @@ static int ext2_valid_block_bitmap(struct super_block *sb,
 static struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
-	struct ext2_group_desc * desc;
-	struct buffer_head * bh = NULL;
+	struct ext2_group_desc *desc;
+	struct buffer_head *bh = NULL;
 	ext2_fsblk_t bitmap_blk;
 
 	desc = ext2_get_group_desc(sb, block_group, NULL);
@@ -335,8 +335,8 @@ void ext2_rsv_window_add(struct super_block *sb,
 	struct rb_node *node = &rsv->rsv_node;
 	ext2_fsblk_t start = rsv->rsv_start;
 
-	struct rb_node ** p = &root->rb_node;
-	struct rb_node * parent = NULL;
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
 	struct ext2_reserve_window_node *this;
 
 	while (*p)
@@ -475,19 +475,19 @@ void ext2_discard_reservation(struct inode *inode)
  * @block:		start physical block to free
  * @count:		number of blocks to free
  */
-void ext2_free_blocks (struct inode * inode, unsigned long block,
-		       unsigned long count)
+void ext2_free_blocks(struct inode *inode, unsigned long block,
+		      unsigned long count)
 {
 	struct buffer_head *bitmap_bh = NULL;
-	struct buffer_head * bh2;
+	struct buffer_head *bh2;
 	unsigned long block_group;
 	unsigned long bit;
 	unsigned long i;
 	unsigned long overflow;
-	struct super_block * sb = inode->i_sb;
-	struct ext2_sb_info * sbi = EXT2_SB(sb);
-	struct ext2_group_desc * desc;
-	struct ext2_super_block * es = sbi->s_es;
+	struct super_block *sb = inode->i_sb;
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
+	struct ext2_group_desc *desc;
+	struct ext2_super_block *es = sbi->s_es;
 	unsigned freed = 0, group_freed;
 
 	if (block < le32_to_cpu(es->s_first_data_block) ||
@@ -778,7 +778,7 @@ ext2_try_to_allocate(struct super_block *sb, int group,
 static int find_next_reservable_window(
 				struct ext2_reserve_window_node *search_head,
 				struct ext2_reserve_window_node *my_rsv,
-				struct super_block * sb,
+				struct super_block *sb,
 				ext2_fsblk_t start_block,
 				ext2_fsblk_t last_block)
 {
@@ -1466,9 +1466,9 @@ unsigned long ext2_count_free(struct buffer_head *map, unsigned int numchars)
 
 #endif  /*  EXT2FS_DEBUG  */
 
-unsigned long ext2_count_free_blocks (struct super_block * sb)
+unsigned long ext2_count_free_blocks(struct super_block *sb)
 {
-	struct ext2_group_desc * desc;
+	struct ext2_group_desc *desc;
 	unsigned long desc_count = 0;
 	int i;
 #ifdef EXT2FS_DEBUG
-- 
2.17.2
