From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/3] ext4: remove unused argument in ext4_ext_next_leaf_block
Date: Fri, 22 Jul 2011 10:23:39 +0800
Message-ID: <1311301421-10533-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63101 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1GVCXt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jul 2011 22:23:49 -0400
Received: by pzk37 with SMTP id 37so2818129pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 19:23:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The argument "inode" in function ext4_ext_next_allocated_block looks useless,
so clean it.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index eb63c7b..3966839 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1447,8 +1447,7 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
  * ext4_ext_next_leaf_block:
  * returns first allocated block from next leaf or EXT_MAX_BLOCKS
  */
-static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
-					struct ext4_ext_path *path)
+static ext4_lblk_t ext4_ext_next_leaf_block(struct ext4_ext_path *path)
 {
 	int depth;
 
@@ -1766,7 +1765,7 @@ repeat:
 
 	/* probably next leaf has space for us? */
 	fex = EXT_LAST_EXTENT(eh);
-	next = ext4_ext_next_leaf_block(inode, path);
+	next = ext4_ext_next_leaf_block(path);
 	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block)
 	    && next != EXT_MAX_BLOCKS) {
 		ext_debug("next leaf block - %d\n", next);
-- 
1.7.4.1

