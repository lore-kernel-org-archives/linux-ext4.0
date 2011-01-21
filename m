From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Adjust trim start with first_data_block.
Date: Fri, 21 Jan 2011 22:05:07 +0800
Message-ID: <1295618707-3677-1-git-send-email-tm@tao.ma>
Cc: "Cc: \"Theodore Ts'o\"" <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:45129 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752040Ab1AUOFY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 09:05:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

As we have make the consense in the e-mail[1], the trim start should
be added with first_data_block. So this patch fulfill it and remove
the check for start < first_data_block.

[1] http://www.spinics.net/lists/linux-ext4/msg22737.html

Cc: Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 851f49b..71dd7bd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4808,21 +4808,16 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
 	ext4_grpblk_t cnt = 0, first_block, last_block;
 	uint64_t start, len, minlen, trimmed;
-	ext4_fsblk_t first_data_blk =
-			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	int ret = 0;
 
-	start = range->start >> sb->s_blocksize_bits;
+	start = (range->start >> sb->s_blocksize_bits) +
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	len = range->len >> sb->s_blocksize_bits;
 	minlen = range->minlen >> sb->s_blocksize_bits;
 	trimmed = 0;
 
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
-	if (start < first_data_blk) {
-		len -= first_data_blk - start;
-		start = first_data_blk;
-	}
 
 	/* Determine first and last group to examine based on start and len */
 	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) start,
-- 
1.7.1

