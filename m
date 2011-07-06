From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/23] ext4: convert block group-relative offsets to use clusters
Date: Wed,  6 Jul 2011 12:35:50 -0400
Message-ID: <1309970166-11770-8-git-send-email-tytso@mit.edu>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33455 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab1GFQgJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2011 12:36:09 -0400
In-Reply-To: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Certain parts of the ext4 code base, primarily in mballoc.c, use a
block group number and offset from the beginning of the block group.
This offset is invariably used to index into the allocation bitmap, so
change the offset to be denominated in units of clusters.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c  |    6 ++++--
 fs/ext4/mballoc.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1c6d777..89abf1f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -28,7 +28,8 @@
  */
 
 /*
- * Calculate the block group number and offset, given a block number
+ * Calculate the block group number and offset into the block/cluster
+ * allocation bitmap, given a block number
  */
 void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 		ext4_group_t *blockgrpp, ext4_grpblk_t *offsetp)
@@ -37,7 +38,8 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 	ext4_grpblk_t offset;
 
 	blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
-	offset = do_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
+	offset = do_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb)) >>
+		EXT4_SB(sb)->s_cluster_bits;
 	if (offsetp)
 		*offsetp = offset;
 	if (blockgrpp)
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 20b5e7b..4423c6f 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -217,6 +217,7 @@ struct ext4_buddy {
 static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 					struct ext4_free_extent *fex)
 {
-	return ext4_group_first_block_no(sb, fex->fe_group) + fex->fe_start;
+	return ext4_group_first_block_no(sb, fex->fe_group) +
+		(fex->fe_start << EXT4_SB(sb)->s_cluster_bits);
 }
 #endif
-- 
1.7.4.1.22.gec8e1.dirty

