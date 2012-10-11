From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext3: Avoid underflow of in ext3_trim_fs()
Date: Thu, 11 Oct 2012 12:28:38 +0200
Message-ID: <1349951318-25190-1-git-send-email-lczerner@redhat.com>
Cc: jack@suse.cz, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418Ab2JKK2o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 06:28:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently if len argument in ext3_trim_fs() is smaller than one block,
the 'end' variable underflow. Avoid that by returning EINVAL if len is
smaller than file system block.

Also remove useless unlikely().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext3/balloc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 7320a66..22548f5 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -2101,8 +2101,9 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	end = start + (range->len >> sb->s_blocksize_bits) - 1;
 	minlen = range->minlen >> sb->s_blocksize_bits;
 
-	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)) ||
-	    unlikely(start >= max_blks))
+	if (minlen > EXT3_BLOCKS_PER_GROUP(sb) ||
+	    start >= max_blks ||
+	    range->len < sb->s_blocksize)
 		return -EINVAL;
 	if (end >= max_blks)
 		end = max_blks - 1;
-- 
1.7.7.6

