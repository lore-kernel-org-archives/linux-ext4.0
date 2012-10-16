From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: missing trace_ext4_ext_map_blocks_exit after calling ext4_ext_handle_uninitialized_extents
Date: Tue, 16 Oct 2012 15:31:36 +0800
Message-ID: <1350372696-18013-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58476 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPHUi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2012 03:20:38 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so5708919pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2012 00:20:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When ext4_ext_handle_uninitialized_extents is called, we will directly return
from ext4_ext_map_blocks.  The trace point of trace_ext4_ext_map_blocks_exit
isn't called, and the user doesn't see any result.  This patch tries to fix this
problem.

Meanwhile in ext4_ext_handle_uninitialized_extents it returns errors or the
number of allocated blocks.  So 'ret' variable can be removed due to previously
modifications.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1c94cca..dc7ef4c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3876,7 +3876,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent newex, *ex, *ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
-	int free_on_err = 0, err = 0, depth, ret;
+	int free_on_err = 0, err = 0, depth;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0;
 	struct ext4_allocation_request ar;
@@ -3972,10 +3972,10 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 					ee_len, ee_start);
 				goto out;
 			}
-			ret = ext4_ext_handle_uninitialized_extents(
+			allocated = ext4_ext_handle_uninitialized_extents(
 				handle, inode, map, path, flags,
 				allocated, newblock);
-			return ret;
+			goto out3;
 		}
 	}
 
@@ -4249,6 +4249,7 @@ out2:
 		kfree(path);
 	}
 
+out3:
 	trace_ext4_ext_map_blocks_exit(inode, map->m_lblk,
 		newblock, map->m_len, err ? err : allocated);
 
-- 
1.7.12.rc2.18.g61b472e

