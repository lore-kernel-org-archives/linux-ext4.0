From: Tao Ma <tm@tao.ma>
Subject: [PATCH 1/4] ext4: fix trim length underflow with small trim length.
Date: Thu, 30 Jun 2011 22:50:36 +0800
Message-ID: <1309445439-3753-1-git-send-email-tm@tao.ma>
References: <4E0C8B6C.8030403@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:58480 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751017Ab1F3Ouz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2011 10:50:55 -0400
In-Reply-To: <4E0C8B6C.8030403@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In 0f0a25b, we adjust 'len' with s_first_data_block - start, but
it could underflow in case blocksize=1K, fstrim_range.len=512 and
fstrim_range.start = 0. In this case, when we run the code:
len -= first_data_blk - start; len will be underflow to -1ULL.
In the end, although we are safe that last_group check later will limit
the trim to the whole volume, but that isn't what the user really want.

So this patch fix it. It also adds the check for 'start' like ext3 so that
we can break immediately if the start is invalid.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6ed859d..2336424 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4904,6 +4904,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
+	if (start >= ext4_blocks_count(EXT4_SB(sb)->s_es) ||
+	    start + len <= first_data_blk)
+		goto out;
 	if (start < first_data_blk) {
 		len -= first_data_blk - start;
 		start = first_data_blk;
@@ -4952,5 +4955,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	}
 	range->len = trimmed * sb->s_blocksize;
 
+out:
 	return ret;
 }
-- 
1.7.4

