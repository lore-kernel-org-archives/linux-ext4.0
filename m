From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext3: fix trim length underflow with small trim length.
Date: Wed, 19 Jan 2011 17:49:10 +0800
Message-ID: <1295430550-8978-1-git-send-email-tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:38465 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753644Ab1ASJtx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jan 2011 04:49:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

We adjust 'len' with s_first_data_block - start in case of start is less
than s_first_data_block, but it could underflow in case blocksize=1K, while
fstrim_range.len=512 and fstrim_range.start = 0. In this case len happens
to be underflow and in the end, although we are safe that last_group check
will limit the trim to the whole volume, I am afraid that isn't what the user
really want.

So this patch fix it. It also adds a new variable s_first_data_block so that
the 4 le32_to_cpu can be replaced with 1.

Cc: Jan Kara <jack@suse.cz>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext3/balloc.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 045995c..ee7e0f3 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -2088,6 +2088,7 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
 	uint64_t start, len, minlen, trimmed;
 	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
+	ext3_fsblk_t first_data_block = le32_to_cpu(es->s_first_data_block);
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
@@ -2097,11 +2098,11 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
-	if (start >= max_blks)
+	if (start >= max_blks || start + len <= first_data_block)
 		goto out;
-	if (start < le32_to_cpu(es->s_first_data_block)) {
-		len -= le32_to_cpu(es->s_first_data_block) - start;
-		start = le32_to_cpu(es->s_first_data_block);
+	if (start < first_data_block) {
+		len -= first_data_block - start;
+		start = first_data_block;
 	}
 	if (start + len > max_blks)
 		len = max_blks - start;
-- 
1.6.3.GIT

