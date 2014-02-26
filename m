From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: delete path dealloc code in
 ext4_ext_handle_uninitialized_extents
Date: Wed, 26 Feb 2014 15:39:14 -0500
Message-ID: <20140226203914.GA2153@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:62185 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaBZUjS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Feb 2014 15:39:18 -0500
Received: by mail-qg0-f42.google.com with SMTP id q107so2852043qgd.1
        for <linux-ext4@vger.kernel.org>; Wed, 26 Feb 2014 12:39:18 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Code deallocating the extent path referenced by an argument to
ext4_ext_handle_uninitialized_extents was made redundant with identical
code in its one caller, ext4_ext_map_blocks, by commit 3779473246.
Allocating and deallocating the path in the same function also makes
the code clearer.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ef4b535..cca976b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4006,10 +4006,6 @@ out1:
 	map->m_pblk = newblock;
 	map->m_len = allocated;
 out2:
-	if (path) {
-		ext4_ext_drop_refs(path);
-		kfree(path);
-	}
 	return err ? err : allocated;
 }
 
@@ -4209,7 +4205,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 				err = ret;
 			else
 				allocated = ret;
-			goto out3;
+			goto out2;
 		}
 	}
 
@@ -4490,7 +4486,6 @@ out2:
 		kfree(path);
 	}
 
-out3:
 	trace_ext4_ext_map_blocks_exit(inode, flags, map,
 				       err ? err : allocated);
 	ext4_es_lru_add(inode);
-- 
1.8.3.2

