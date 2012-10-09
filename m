From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Avoid underflow of in ext4_trim_fs()
Date: Tue,  9 Oct 2012 14:12:42 +0200
Message-ID: <1349784762-28069-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab2JIMMs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2012 08:12:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently if len argument in ext4_trim_fs() is smaller than one block,
the 'end' variable underflow. Avoid that by exiting right away if len
is smaller than one file system block.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f8b27bf..06c8526 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4989,13 +4989,18 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
-	end = start + (range->len >> sb->s_blocksize_bits) - 1;
 	minlen = EXT4_NUM_B2C(EXT4_SB(sb),
 			      range->minlen >> sb->s_blocksize_bits);
 
 	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
 	    unlikely(start >= max_blks))
 		return -EINVAL;
+
+	end = range->len >> sb->s_blocksize_bits;
+	if (0 == end)
+		goto out;
+	end += start - 1;
+
 	if (end >= max_blks)
 		end = max_blks - 1;
 	if (end <= first_data_blk)
-- 
1.7.7.6

