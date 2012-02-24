From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext3: fix start and len arguments handling in ext3_trim_fs()
Date: Fri, 24 Feb 2012 17:33:01 +0100
Message-ID: <1330101181-26067-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab2BXQdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Feb 2012 11:33:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The overflow can happen when we are calling get_group_no_and_offset()
which stores the result of do_div() in 32 bit long type. However the
result might be bigger than that if big blocknr is passed in. This will
most likely happen when calling FITRIM with the default argument len =
ULLONG_MAX.

Fix this by using "end" variable instead of "start+len" as it is easier
to get right and specifically check that the end is not beyond the end
of the file system, so we are sure that the result of
get_group_no_and_offset() will not overflow. Otherwise truncate it to
the size of the file system.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext3/balloc.c |   59 +++++++++++++++++++++++++++--------------------------
 1 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a203892..2ad59c6 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -2091,71 +2091,72 @@ err_out:
  */
 int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
-	ext3_grpblk_t last_block, first_block, free_blocks;
-	unsigned long first_group, last_group;
-	unsigned long group, ngroups;
+	ext3_grpblk_t last_block, first_block;
+	unsigned long group, first_group, last_group;
 	struct ext3_group_desc *gdp;
 	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
-	uint64_t start, len, minlen, trimmed;
+	uint64_t start, minlen, end, trimmed = 0;
+	ext3_fsblk_t first_data_blk =
+			le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block);
 	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
 	int ret = 0;
 
-	start = (range->start >> sb->s_blocksize_bits) +
-		le32_to_cpu(es->s_first_data_block);
-	len = range->len >> sb->s_blocksize_bits;
+	start = range->start >> sb->s_blocksize_bits;
+	end = start + (range->len >> sb->s_blocksize_bits) - 1;
 	minlen = range->minlen >> sb->s_blocksize_bits;
-	trimmed = 0;
 
-	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))
+	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)) ||
+	    unlikely(start >= max_blks))
 		return -EINVAL;
-	if (start >= max_blks)
-		return -EINVAL;
-	if (start + len > max_blks)
-		len = max_blks - start;
+	if (unlikely(end >= max_blks))
+		end = max_blks - 1;
+	if (end <= first_data_blk)
+		return 0;
+	if (start < first_data_blk)
+		start = first_data_blk;
 
-	ngroups = EXT3_SB(sb)->s_groups_count;
 	smp_rmb();
 
 	/* Determine first and last group to examine based on start and len */
 	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) start,
 				     &first_group, &first_block);
-	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) (start + len),
+	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) end,
 				     &last_group, &last_block);
-	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
-	last_block = EXT3_BLOCKS_PER_GROUP(sb);
 
-	if (first_group > last_group)
-		return -EINVAL;
+	/* The last block to discard in the group */
+	end = EXT3_BLOCKS_PER_GROUP(sb);
 
 	for (group = first_group; group <= last_group; group++) {
 		gdp = ext3_get_group_desc(sb, group, NULL);
 		if (!gdp)
 			break;
 
-		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
-		if (free_blocks < minlen)
+		if (le16_to_cpu(gdp->bg_free_blocks_count) < minlen)
 			continue;
 
 		/*
 		 * For all the groups except the last one, last block will
 		 * always be EXT3_BLOCKS_PER_GROUP(sb), so we only need to
-		 * change it for the last group in which case first_block +
-		 * len < EXT3_BLOCKS_PER_GROUP(sb).
+		 * change it for the last group, note that last_block is
+		 * already computed earlier by ext3_get_group_no_and_offset()
 		 */
-		if (first_block + len < EXT3_BLOCKS_PER_GROUP(sb))
-			last_block = first_block + len;
-		len -= last_block - first_block;
+		if (group == last_group)
+			end = last_block;
 
 		ret = ext3_trim_all_free(sb, group, first_block,
-					last_block, minlen);
+					 end, minlen);
 		if (ret < 0)
 			break;
