From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/19] ext4: convert block group-relative offsets to use clusters
Date: Tue,  3 May 2011 18:24:37 -0400
Message-ID: <1304461490-11056-8-git-send-email-tytso@mit.edu>
References: <1304461490-11056-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58119 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab1ECWYy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 18:24:54 -0400
In-Reply-To: <1304461490-11056-1-git-send-email-tytso@mit.edu>
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
index 332854c..a0a86ce 100644
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
index 22bd4d7..1a75182 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -223,6 +223,7 @@ struct ext4_buddy {
 static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 					struct ext4_free_extent *fex)
 {
-	return ext4_group_first_block_no(sb, fex->fe_group) + fex->fe_start;
+	return ext4_group_first_block_no(sb, fex->fe_group) +
+		(fex->fe_start << EXT4_SB(sb)->s_cluster_bits);
 }
 #endif
-- 
1.7.3.1

