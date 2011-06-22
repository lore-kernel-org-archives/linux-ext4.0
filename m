From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext3: Return -EINVAL when start is beyond the end of fs in ext3_trim_fs()
Date: Wed, 22 Jun 2011 10:51:09 +0200
Message-ID: <1308732669-6674-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab1FVIvi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jun 2011 04:51:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should return -EINVAL when the FITRIM parameters are not sane, but
currently we are exiting silently if start is beyond the end of the
file system. This commit fixes this so we return -EINVAL as other file
systems do.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
CC: Jan Kara <jack@suse.cz>
---
 fs/ext3/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index fe52297..790cdf3 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -2100,7 +2100,7 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))
 		return -EINVAL;
 	if (start >= max_blks)
-		goto out;
+		return -EINVAL;
 	if (start + len > max_blks)
 		len = max_blks - start;
 
-- 
1.7.4.4

