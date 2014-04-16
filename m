From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/5] ext4: No need to truncate pagecache twice in collapse range
Date: Wed, 16 Apr 2014 20:33:00 +0200
Message-ID: <1397673182-5326-3-git-send-email-lczerner@redhat.com>
References: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Cc: linkinjeon@gmail.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420AbaDPSdk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2014 14:33:40 -0400
In-Reply-To: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We're already calling truncate_pagecache_range() before we attempt to
do any actual job so there is not need to truncate pagecache once more
using truncate_setsize() after we're finished.

Remove truncate_setsize() and replace it just with i_size_write() note
that we're holding appropriate locks.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 25ed60f..9cd762c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5442,7 +5442,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	}
 
 	new_size = i_size_read(inode) - len;
-	truncate_setsize(inode, new_size);
+	i_size_write(inode, new_size);
 	EXT4_I(inode)->i_disksize = new_size;
 
 	ext4_discard_preallocations(inode);
-- 
1.8.3.1

