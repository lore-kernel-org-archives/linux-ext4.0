From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/6] ext4: Do not clear EOFBLOCKS_FL too soon
Date: Fri, 21 Oct 2011 01:08:56 +0400
Message-ID: <1319144939-28801-4-git-send-email-dmonakhov@openvz.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47056 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1JTVIx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 17:08:53 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so4002126bkb.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 14:08:52 -0700 (PDT)
In-Reply-To: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_insert_extent() may fail due to number of reasons (ENOSPC)
so let's update eof flag only after extent was successfully inserted.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 315775e..d81085e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4115,10 +4115,7 @@ got_allocated_blocks:
 			map->m_flags |= EXT4_MAP_UNINIT;
 	}
 
-	err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
-	if (!err)
-		err = ext4_ext_insert_extent(handle, inode, path,
-					     &newex, flags);
+	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err && free_on_err) {
 		int fb_flags = flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ?
 			EXT4_FREE_BLOCKS_NO_QUOT_UPDATE : 0;
@@ -4130,6 +4127,11 @@ got_allocated_blocks:
 				 ext4_ext_get_actual_len(&newex), fb_flags);
 		goto out2;
 	}
+	err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
+	if (err) {
+		ext4_discard_preallocations(inode);
+		goto out2;
+	}
 
 	/* previous routine could use block we allocated */
 	newblock = ext4_ext_pblock(&newex);
-- 
1.7.1

