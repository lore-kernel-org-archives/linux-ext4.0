From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: fix error return from
 ext4_ext_handle_uninitialized_extents()
Date: Thu, 13 Feb 2014 17:54:30 -0500
Message-ID: <20140213225430.GC11924@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42563 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaBMWyd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Feb 2014 17:54:33 -0500
Received: by mail-qc0-f175.google.com with SMTP id x13so19074217qcv.34
        for <linux-ext4@vger.kernel.org>; Thu, 13 Feb 2014 14:54:33 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 3779473246 breaks the return of error codes from
ext4_ext_handle_uninitialized_extents() in ext4_ext_map_blocks().  A
portion of the patch assigns that function's signed integer return
value to an unsigned int.  Consequently, negatively valued error codes
are lost and can be treated as a bogus allocated block count.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74bc2d5..9875fd0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4128,7 +4128,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent newex, *ex, *ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
-	int free_on_err = 0, err = 0, depth;
+	int free_on_err = 0, err = 0, depth, ret;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0;
 	struct ext4_allocation_request ar;
@@ -4189,9 +4189,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			if (!ext4_ext_is_uninitialized(ex))
 				goto out;
 
-			allocated = ext4_ext_handle_uninitialized_extents(
+			ret = ext4_ext_handle_uninitialized_extents(
 				handle, inode, map, path, flags,
 				allocated, newblock);
+			if (ret < 0)
+				err = ret;
+			else
+				allocated = ret;
 			goto out3;
 		}
 	}
-- 
1.8.3.2

