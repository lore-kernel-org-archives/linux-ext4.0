From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v3] ext4: fix possible overflow in ext4_trim_fs()
Date: Wed,  7 Sep 2011 17:52:57 +0200
Message-ID: <1315410777-24237-1-git-send-email-lczerner@redhat.com>
Cc: tm@tao.ma, tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1IGQcg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Sep 2011 12:32:36 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p87GWZUD010515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Sep 2011 12:32:35 -0400
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
v2 - Change commit description to better describe the problem
v3 - Use end instead of start+len, rework the fix

 fs/ext4/mballoc.c |   43 +++++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..fa8b14b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4946,37 +4946,36 @@ out:
 int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
 	struct ext4_group_info *grp;
-	ext4_group_t first_group, last_group;
-	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
+	ext4_group_t group, first_group, last_group;
 	ext4_grpblk_t cnt = 0, first_block, last_block;
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
 
-	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
+	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)) ||
+	    unlikely(start > max_blks))
 		return -EINVAL;
-	if (start + len <= first_data_blk)
+	if (unlikely(end >= max_blks))
+		end = max_blks - 1;
+	if (end <= first_data_blk)
 		goto out;
-	if (start < first_data_blk) {
-		len -= first_data_blk - start;
+	if (start < first_data_blk)
 		start = first_data_blk;
-	}
 
 	/* Determine first and last group to examine based on start and len */
 	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) start,
 				     &first_group, &first_block);
-	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) (start + len),
+	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) end,
 				     &last_group, &last_block);
-	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
-	last_block = EXT4_BLOCKS_PER_GROUP(sb);
 
-	if (first_group > last_group)
-		return -EINVAL;
+	/* The last block to discard in the group */
+	end = EXT4_BLOCKS_PER_GROUP(sb);
 
 	for (group = first_group; group <= last_group; group++) {
 		grp = ext4_get_group_info(sb, group);
@@ -4990,22 +4989,26 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		/*
 		 * For all the groups except the last one, last block will
 		 * always be EXT4_BLOCKS_PER_GROUP(sb), so we only need to
-		 * change it for the last group in which case start +
-		 * len < EXT4_BLOCKS_PER_GROUP(sb).
+		 * change it for the last group, note that last_block is
+		 * already computed earlier by ext4_get_group_no_and_offset()
 		 */
-		if (first_block + len < EXT4_BLOCKS_PER_GROUP(sb))
-			last_block = first_block + len;
-		len -= last_block - first_block;
+		if (group == last_group)
+			end = last_block;
 
 		if (grp->bb_free >= minlen) {
 			cnt = ext4_trim_all_free(sb, group, first_block,
-						last_block, minlen);
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
+		 * that the first block to discard will be block #0.
+		 */
 		first_block = 0;
 	}
 	range->len = trimmed * sb->s_blocksize;
-- 
1.7.4.4

