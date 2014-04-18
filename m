From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Use truncate_pagecache() in collapse range
Date: Fri, 18 Apr 2014 13:22:04 +0200
Message-ID: <1397820124-16885-1-git-send-email-lczerner@redhat.com>
References: <002101cf5ac76d97bf048c73d0samsung.com>
Cc: namjae.jeon@samsung.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaDRLWM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 07:22:12 -0400
In-Reply-To: <002101cf5ac76d97bf048c73d0samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should be using truncate_pagecache() instead of
truncate_pagecache_range() in the collapse range because we're
truncating page cache from offset to the end of file.
truncate_pagecache() also get rid of the private COWed pages from the
range because we're going to shift the end of the file.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5fa31cb..3a6e40c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5406,7 +5406,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		goto out_mutex;
 	}
 
-	truncate_pagecache_range(inode, offset, -1);
+	truncate_pagecache(inode, offset);
 
 	/* Wait for existing dio to complete */
 	ext4_inode_block_unlocked_dio(inode);
-- 
1.8.3.1

