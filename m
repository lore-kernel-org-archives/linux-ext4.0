From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 20/23] ext4: rename ext4_free_blocks_after_init() to ext4_free_clusters_after_init()
Date: Wed,  6 Jul 2011 12:36:03 -0400
Message-ID: <1309970166-11770-21-git-send-email-tytso@mit.edu>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33486 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1GFQgJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2011 12:36:09 -0400
In-Reply-To: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This function really returns the number of clusters after initializing
an uninitalized block bitmap has been initialized.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c  |    6 +++---
 fs/ext4/ext4.h    |    6 +++---
 fs/ext4/ialloc.c  |    2 +-
 fs/ext4/mballoc.c |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 4f30380..3d07c35 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -213,9 +213,9 @@ void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 /* Return the number of free blocks in a block group.  It is used when
  * the block bitmap is uninitialized, so we can't just count the bits
  * in the bitmap. */
-unsigned ext4_free_blocks_after_init(struct super_block *sb,
-				     ext4_group_t block_group,
-				     struct ext4_group_desc *gdp)
+unsigned ext4_free_clusters_after_init(struct super_block *sb,
+				       ext4_group_t block_group,
+				       struct ext4_group_desc *gdp)
 {
 	return num_clusters_in_group(sb, block_group) - 
 		ext4_num_overhead_clusters(sb, block_group, gdp);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 04bf654..b18c6d5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1772,9 +1772,9 @@ extern void ext4_init_block_bitmap(struct super_block *sb,
 				   struct buffer_head *bh,
 				   ext4_group_t group,
 				   struct ext4_group_desc *desc);
-extern unsigned ext4_free_blocks_after_init(struct super_block *sb,
-					    ext4_group_t block_group,
-					    struct ext4_group_desc *gdp);
+extern unsigned ext4_free_clusters_after_init(struct super_block *sb,
+					      ext4_group_t block_group,
+					      struct ext4_group_desc *gdp);
 extern unsigned ext4_num_base_meta_clusters(struct super_block *sb,
 					    ext4_group_t block_group);
 extern unsigned ext4_num_overhead_clusters(struct super_block *sb,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index aa74ca6..b30115b 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -961,7 +961,7 @@ got:
 		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			ext4_free_group_clusters_set(sb, gdp,
-				ext4_free_blocks_after_init(sb, group, gdp));
+				ext4_free_clusters_after_init(sb, group, gdp));
 			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
 								gdp);
 		}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 852f303..33cdc81 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2251,7 +2251,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	 */
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		meta_group_info[i]->bb_free =
-			ext4_free_blocks_after_init(sb, group, desc);
+			ext4_free_clusters_after_init(sb, group, desc);
 	} else {
 		meta_group_info[i]->bb_free =
 			ext4_free_group_clusters(sb, desc);
@@ -2810,7 +2810,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 		ext4_free_group_clusters_set(sb, gdp,
-					     ext4_free_blocks_after_init(sb,
+					     ext4_free_clusters_after_init(sb,
 						ac->ac_b_ex.fe_group, gdp));
 	}
 	len = ext4_free_group_clusters(sb, gdp) - ac->ac_b_ex.fe_len;
-- 
1.7.4.1.22.gec8e1.dirty

