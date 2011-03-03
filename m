From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext3: Fix an overflow in ext3_trim_fs.
Date: Thu,  3 Mar 2011 22:58:37 +0800
Message-ID: <1299164317-6400-1-git-send-email-tm@tao.ma>
Cc: Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49078 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751325Ab1CCO6s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Mar 2011 09:58:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In a bs=4096 volume, if we call FITRIM with the following parameter as
fstrim_range(start = 102400, len = 134144000, minlen = 10240), with the
following code:
if (len >= EXT3_BLOCKS_PER_GROUP(sb))
        len -= (EXT3_BLOCKS_PER_GROUP(sb) - first_block);
else
        last_block = first_block + len;

So if len < EXT3_BLOCKS_PER_GROUP while first_block + len >
EXT3_BLOCKS_PER_GROUP, last_block will be set to an overflow value
which exceeds EXT3_BLOCKS_PER_GROUP.

This patch fixes it and adjusts len and last_block accordingly.

Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext3/balloc.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 045995c..5e012fe 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -2129,10 +2129,15 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		if (free_blocks < minlen)
 			continue;
 
-		if (len >= EXT3_BLOCKS_PER_GROUP(sb))
-			len -= (EXT3_BLOCKS_PER_GROUP(sb) - first_block);
-		else
+		/*
+		 * For all the groups except the last one, last block will
+		 * always be EXT3_BLOCKS_PER_GROUP(sb), so we only need to
+		 * change it for the last group in which case first_block +
+		 * len < EXT3_BLOCKS_PER_GROUP(sb).
+		 */
+		if (first_block + len < EXT3_BLOCKS_PER_GROUP(sb))
 			last_block = first_block + len;
+		len -= last_block - first_block;
 
 		ret = ext3_trim_all_free(sb, group, first_block,
 					last_block, minlen);
-- 
1.6.3.GIT

