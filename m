From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: ext4_trim_fs() load buddy only when it is needed
Date: Mon, 18 Apr 2011 18:32:31 +0200
Message-ID: <1303144351-15614-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab1DRQdM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Apr 2011 12:33:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we are loading buddy ext4_mb_load_buddy() for every block
group we are going through in ext4_trim_fs() in many cases just to find
out that there is not enough space to be bothered with. As Amir Goldstein
suggested we can use bb_free information directly from ext4_group_info.

This commit removes ext4_mb_load_buddy() from ext4_trim_fs() and rather
get the ext4_group_info via ext4_get_group_info() and use the bb_free
information directly from that. This avoids unnecessary call to load
buddy in the case the group does not have enough free space to trim.
Loading buddy is now moved to ext4_trim_all_free().

Tested by me with xfstests 251.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |   48 ++++++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d8a16ee..776d7a8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4760,20 +4760,25 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
  * the group buddy bitmap. This is done until whole group is scanned.
  */
 static ext4_grpblk_t
-ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
-		ext4_grpblk_t start, ext4_grpblk_t max, ext4_grpblk_t minblocks)
+ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
+		   ext4_grpblk_t start, ext4_grpblk_t max,
+		   ext4_grpblk_t minblocks)
 {
 	void *bitmap;
 	ext4_grpblk_t next, count = 0;
-	ext4_group_t group;
+	struct ext4_buddy e4b;
 	int ret = 0;
 
-	BUG_ON(e4b == NULL);
+	ret = ext4_mb_load_buddy(sb, group, &e4b);
+	if (ret) {
+		ext4_error(sb, "Error in loading buddy "
+				"information for %u", group);
+		return ret;
+	}
 
-	bitmap = e4b->bd_bitmap;
-	group = e4b->bd_group;
-	start = (e4b->bd_info->bb_first_free > start) ?
-		e4b->bd_info->bb_first_free : start;
+	bitmap = e4b.bd_bitmap;
+	start = (e4b.bd_info->bb_first_free > start) ?
+		e4b.bd_info->bb_first_free : start;
 	ext4_lock_group(sb, group);
 
 	while (start < max) {
@@ -4784,7 +4789,7 @@ ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 
 		if ((next - start) >= minblocks) {
 			ret = ext4_trim_extent(sb, start,
-				next - start, group, e4b);
+				next - start, group, &e4b);
 			if (ret < 0)
 				break;
 			count += next - start;
@@ -4802,10 +4807,11 @@ ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 			ext4_lock_group(sb, group);
 		}
 
-		if ((e4b->bd_info->bb_free - count) < minblocks)
+		if ((e4b.bd_info->bb_free - count) < minblocks)
 			break;
 	}
 	ext4_unlock_group(sb, group);
+	ext4_mb_unload_buddy(&e4b);
 
 	ext4_debug("trimmed %d blocks in the group %d\n",
 		count, group);
@@ -4830,11 +4836,11 @@ ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
  */
 int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
-	struct ext4_buddy e4b;
+	struct ext4_group_info *grp;
 	ext4_group_t first_group, last_group;
 	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
 	ext4_grpblk_t cnt = 0, first_block, last_block;
-	uint64_t start, len, minlen, trimmed;
+	uint64_t start, len, minlen, trimmed = 0;
 	ext4_fsblk_t first_data_blk =
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	int ret = 0;
@@ -4842,7 +4848,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	start = range->start >> sb->s_blocksize_bits;
 	len = range->len >> sb->s_blocksize_bits;
 	minlen = range->minlen >> sb->s_blocksize_bits;
-	trimmed = 0;
 
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
@@ -4863,11 +4868,12 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		return -EINVAL;
 
 	for (group = first_group; group <= last_group; group++) {
-		ret = ext4_mb_load_buddy(sb, group, &e4b);
-		if (ret) {
-			ext4_error(sb, "Error in loading buddy "
-					"information for %u", group);
-			break;
+		grp = ext4_get_group_info(sb, group);
+		/* We only do this if the grp has never been initialized */
+		if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
+			ret = ext4_mb_init_group(sb, group);
+			if (ret)
+				break;
 		}
 
 		/*
@@ -4880,16 +4886,14 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 			last_block = first_block + len;
 		len -= last_block - first_block;
 
-		if (e4b.bd_info->bb_free >= minlen) {
-			cnt = ext4_trim_all_free(sb, &e4b, first_block,
+		if (grp->bb_free >= minlen) {
+			cnt = ext4_trim_all_free(sb, group, first_block,
 						last_block, minlen);
 			if (cnt < 0) {
 				ret = cnt;
-				ext4_mb_unload_buddy(&e4b);
 				break;
 			}
 		}
-		ext4_mb_unload_buddy(&e4b);
 		trimmed += cnt;
 		first_block = 0;
 	}
-- 
1.7.4.2

