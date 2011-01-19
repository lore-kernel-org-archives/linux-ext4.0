From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: fix trim length underflow with small trim length.
Date: Wed, 19 Jan 2011 17:45:58 +0800
Message-ID: <1295430358-8912-1-git-send-email-tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:50600 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753519Ab1ASJpp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jan 2011 04:45:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In 0f0a25b, we adjust 'len' with s_first_data_block - start, but it could
underflow in case blocksize=1K, while fstrim_range.len=512 and
fstrim_range.start = 0. In this case len happens to be underflow and in
the end, although we are safe that last_group check will limit the trim
to the whole volume, I am afraid that isn't what the user really want.

So this patch fix it. It also adds the check for 'start' like ext3 so that
we can break immediately if the start is invalid.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 851f49b..397db8d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4819,6 +4819,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
+	if (start >= ext4_blocks_count(EXT4_SB(sb)->s_es) ||
+	    start + len <= first_data_blk)
+		goto out;
 	if (start < first_data_blk) {
 		len -= first_data_blk - start;
 		start = first_data_blk;
@@ -4863,5 +4866,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	}
 	range->len = trimmed * sb->s_blocksize;
 
+out:
 	return ret;
 }
-- 
1.6.3.GIT

