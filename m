From: Tao Ma <tm@tao.ma>
Subject: [PATCH 1/5] ext4: fix trim length underflow with small trim length.
Date: Fri,  1 Jul 2011 23:27:52 +0800
Message-ID: <1309534076-2784-1-git-send-email-tm@tao.ma>
References: <4E0DE63A.7030103@tao.ma>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:45169 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751333Ab1GAPa2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 11:30:28 -0400
In-Reply-To: <4E0DE63A.7030103@tao.ma>
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

Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6ed859d..604b706 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4904,6 +4904,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
+	if (start + len <= first_data_blk)
+		goto out;
 	if (start < first_data_blk) {
 		len -= first_data_blk - start;
 		start = first_data_blk;
@@ -4952,5 +4954,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	}
 	range->len = trimmed * sb->s_blocksize;
 
+out:
 	return ret;
 }
-- 
1.7.4

