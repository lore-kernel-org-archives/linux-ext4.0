From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2] ext4: Avoid underflow of in ext4_trim_fs()
Date: Thu, 11 Oct 2012 10:34:45 +0200
Message-ID: <1349944485-13868-1-git-send-email-lczerner@redhat.com>
References: <1349784762-28069-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2JKIfB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2012 04:35:01 -0400
In-Reply-To: <1349784762-28069-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently if len argument in ext4_trim_fs() is smaller than one block,
the 'end' variable underflow. Avoid that by returning EINVAL if len is
smaller than file system block.

Also remove useless unlikely().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: reworked, return EINVAL if len < FSB

 fs/ext4/mballoc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f8b27bf..e02ae6c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4993,8 +4993,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	minlen = EXT4_NUM_B2C(EXT4_SB(sb),
 			      range->minlen >> sb->s_blocksize_bits);
 
-	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
-	    unlikely(start >= max_blks))
+	if (minlen > EXT4_CLUSTERS_PER_GROUP(sb) ||
+	    start >= max_blks ||
+	    range->len < sb->s_blocksize)
 		return -EINVAL;
 	if (end >= max_blks)
 		end = max_blks - 1;
-- 
1.7.7.6

