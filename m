From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] ext4: Do not clear EOFBLOCKS_FL too soon
Date: Tue, 20 Sep 2011 18:49:29 +0400
Message-ID: <1316530170-3965-4-git-send-email-dmonakhov@openvz.org>
References: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61802 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1ITOtQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 10:49:16 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so535196bkb.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Sep 2011 07:49:15 -0700 (PDT)
In-Reply-To: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_insert_extent() may fail due to number of reasons (ENOSPC)
so let's update eof flag only after extent was successfully inserted.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9032214..098bf6a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3562,10 +3562,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			map->m_flags |= EXT4_MAP_UNINIT;
 	}
 
-	err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
-	if (!err)
-		err = ext4_ext_insert_extent(handle, inode, path,
-					     &newex, flags);
+	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
 		int fb_flags = flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ?
 			EXT4_FREE_BLOCKS_NO_QUOT_UPDATE : 0;
@@ -3577,6 +3574,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
1.7.2.3

