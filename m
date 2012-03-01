From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/5] ext4: fix start and len arguments handling in ext4_trim_fs()
Date: Thu,  1 Mar 2012 11:16:41 +0100
Message-ID: <1330597005-751-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843Ab2CAKQz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 05:16:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The overflow can happen when we are calling get_group_no_and_offset()
which stores the group number in the ext4_grpblk_t type which is
actually int. However when the blocknr is big enough the group number
might be bigger than ext4_grpblk_t resulting in overflow. This will
most likely happen with FITRIM default argument len = ULLONG_MAX.

Fix this by using "end" variable instead of "start+len" as it is easier
to get right and specifically check that the end is not beyond the end
of the file system, so we are sure that the result of
get_group_no_and_offset() will not overflow. Otherwise truncate it to
the size of the file system.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |   49 ++++++++++++++++++++++++++-----------------------
 1 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cb990b2..5798cf3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5027,37 +5027,36 @@ out:
 int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
 	struct ext4_group_info *grp;
-	ext4_group_t first_group, last_group;
-	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
+	ext4_group_t group, first_group, last_group;
 	ext4_grpblk_t cnt = 0, first_cluster, last_cluster;
-	uint64_t start, len, minlen, trimmed = 0;
+	uint64_t start, end, minlen, trimmed = 0;
 	ext4_fsblk_t first_data_blk =
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
+	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
-	len = range->len >> sb->s_blocksize_bits;
+	end = start + (range->len >> sb->s_blocksize_bits) - 1;
 	minlen = range->minlen >> sb->s_blocksize_bits;
 
-	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)))
+	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
+	    unlikely(start >= max_blks))
 		return -EINVAL;
-	if (start + len <= first_data_blk)
+	if (end >= max_blks)
+		end = max_blks - 1;
+	if (end <= first_data_blk)
 		goto out;
-	if (start < first_data_blk) {
-		len -= first_data_blk - start;
+	if (start < first_data_blk)
 		start = first_data_blk;
-	}
 
-	/* Determine first and last group to examine based on start and len */
+	/* Determine first and last group to examine based on start and end */
 	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) start,
 				     &first_group, &first_cluster);
-	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) (start + len),
+	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) end,
 				     &last_group, &last_cluster);
-	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
-	last_cluster = EXT4_CLUSTERS_PER_GROUP(sb);
 
-	if (first_group > last_group)
-		return -EINVAL;
+	/* end now represents the last cluster to discard in this group */
+	end = EXT4_CLUSTERS_PER_GROUP(sb) - 1;
 
 	for (group = first_group; group <= last_group; group++) {
 		grp = ext4_get_group_info(sb, group);
@@ -5069,24 +5068,28 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		}
 
 		/*
-		 * For all the groups except the last one, last block will
-		 * always be EXT4_BLOCKS_PER_GROUP(sb), so we only need to
-		 * change it for the last group in which case start +
-		 * len < EXT4_BLOCKS_PER_GROUP(sb).
+		 * For all the groups except the last one, last cluster will
+		 * always be EXT4_CLUSTERS_PER_GROUP(sb)-1, so we only need to
+		 * change it for the last group, note that last_cluster is
+		 * already computed earlier by ext4_get_group_no_and_offset()
 		 */
-		if (first_cluster + len < EXT4_CLUSTERS_PER_GROUP(sb))
-			last_cluster = first_cluster + len;
-		len -= last_cluster - first_cluster;
+		if (group == last_group)
+			end = last_cluster;
 
 		if (grp->bb_free >= minlen) {
 			cnt = ext4_trim_all_free(sb, group, first_cluster,
-						last_cluster, minlen);
+						end, minlen);
 			if (cnt < 0) {
 				ret = cnt;
 				break;
 			}
 		}
 		trimmed += cnt;
+
+		/*
+		 * For every group except the first one, we are sure
+		 * that the first cluster to discard will be cluster #0.
+		 */
 		first_cluster = 0;
 	}
 	range->len = trimmed * sb->s_blocksize;
-- 
1.7.4.4

