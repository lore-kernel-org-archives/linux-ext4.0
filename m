From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext4: introduce ext4_get_group_number()
Date: Mon, 25 Mar 2013 11:24:11 +0100
Message-ID: <1364207051-27037-2-git-send-email-lczerner@redhat.com>
References: <1364207051-27037-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab3CYKYR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Mar 2013 06:24:17 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2PAOHRR006744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2013 06:24:17 -0400
In-Reply-To: <1364207051-27037-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently on many places in ext4 we're using
ext4_get_group_no_and_offset() even though we're only interested in
knowing the block group of the particular block, not the offset within
the block group so we can use more efficient way to compute block group.

This patch introduces ext4_get_group_number() which computes block group
for a givem block much more efficiently. Use this function instead of
ext4_get_group_no_and_offset() everywhere where we're only interested in
knowing the block group.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/balloc.c  |   14 +++++++++++---
 fs/ext4/ext4.h    |    3 +++
 fs/ext4/mballoc.c |    6 +++---
 fs/ext4/resize.c  |   10 +++++-----
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 68368c2..21b43ca 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -30,6 +30,16 @@ static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
  */
 
 /*
+ * Calculate block group number for a given block number
+ */
+inline ext4_group_t ext4_get_group_number(struct super_block *sb,
+					  ext4_fsblk_t block)
+{
+	return (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) + block) >>
+	       (EXT4_BLOCK_SIZE_BITS(sb) + EXT4_CLUSTER_BITS(sb) + 3);
+}
+
+/*
  * Calculate the block group number and offset into the block/cluster
  * allocation bitmap, given a block number
  */
@@ -58,9 +68,7 @@ static inline int ext4_block_in_group(struct super_block *sb,
 				      ext4_group_t block_group)
 {
 	ext4_group_t actual_group;
-	actual_group = (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
-			block) >>
-		       (EXT4_BLOCK_SIZE_BITS(sb) + EXT4_CLUSTER_BITS(sb) + 3);
+	actual_group = ext4_get_group_number(sb, block);
 	return (actual_group == block_group) ? 1 : 0;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 167ff56..4df299b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1787,6 +1787,9 @@ ext4_group_first_block_no(struct super_block *sb, ext4_group_t group_no)
 void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 			ext4_group_t *blockgrpp, ext4_grpblk_t *offsetp);
 
+inline ext4_group_t ext4_get_group_number(struct super_block *sb,
+					  ext4_fsblk_t block);
+
 /*
  * Timeout and state flag for lazy initialization inode thread.
  */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ee6614b..dca7f06 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3342,7 +3342,7 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	if (pa->pa_type == MB_GROUP_PA)
 		grp_blk--;
 
-	ext4_get_group_no_and_offset(sb, grp_blk, &grp, NULL);
+	grp = ext4_get_group_number(sb, grp_blk);
 
 	/*
 	 * possible race:
@@ -3807,7 +3807,7 @@ repeat:
 
 	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
 		BUG_ON(pa->pa_type != MB_INODE_PA);
-		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
+		group = ext4_get_group_number(sb, pa->pa_pstart);
 
 		err = ext4_mb_load_buddy(sb, group, &e4b);
 		if (err) {
@@ -4069,7 +4069,7 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 
 	list_for_each_entry_safe(pa, tmp, &discard_list, u.pa_tmp_list) {
 
-		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
+		group = ext4_get_group_number(sb, pa->pa_pstart);
 		if (ext4_mb_load_buddy(sb, group, &e4b)) {
 			ext4_error(sb, "Error loading buddy information for %u",
 					group);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c169477..e349853 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -272,7 +272,7 @@ next_group:
 		if (start_blk >= last_blk)
 			goto next_group;
 		group_data[bb_index].block_bitmap = start_blk++;
-		ext4_get_group_no_and_offset(sb, start_blk - 1, &group, NULL);
+		group = ext4_get_group_number(sb, start_blk - 1);
 		group -= group_data[0].group;
 		group_data[group].free_blocks_count--;
 		if (flexbg_size > 1)
@@ -284,7 +284,7 @@ next_group:
 		if (start_blk >= last_blk)
 			goto next_group;
 		group_data[ib_index].inode_bitmap = start_blk++;
-		ext4_get_group_no_and_offset(sb, start_blk - 1, &group, NULL);
+		group = ext4_get_group_number(sb, start_blk - 1);
 		group -= group_data[0].group;
 		group_data[group].free_blocks_count--;
 		if (flexbg_size > 1)
@@ -296,7 +296,7 @@ next_group:
 		if (start_blk + EXT4_SB(sb)->s_itb_per_group > last_blk)
 			goto next_group;
 		group_data[it_index].inode_table = start_blk;
-		ext4_get_group_no_and_offset(sb, start_blk, &group, NULL);
+		group = ext4_get_group_number(sb, start_blk - 1);
 		group -= group_data[0].group;
 		group_data[group].free_blocks_count -=
 					EXT4_SB(sb)->s_itb_per_group;
@@ -392,7 +392,7 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 		ext4_group_t group;
 		int err;
 
-		ext4_get_group_no_and_offset(sb, block, &group, NULL);
+		group = ext4_get_group_number(sb, block);
 		start = ext4_group_first_block_no(sb, group);
 		group -= flex_gd->groups[0].group;
 
@@ -1879,7 +1879,7 @@ retry:
 		/* Nothing need to do */
 		return 0;
 
-	ext4_get_group_no_and_offset(sb, n_blocks_count - 1, &n_group, &offset);
+	n_group = ext4_get_group_number(sb, n_blocks_count - 1);
 	ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o_group, &offset);
 
 	n_desc_blocks = num_desc_blocks(sb, n_group + 1);
-- 
1.7.7.6

