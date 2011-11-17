From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 4/6] ext4: remove code related to punching hole from ext4_ext_insert_extent
Date: Thu, 17 Nov 2011 10:03:23 +0800
Message-ID: <1321495405-9583-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab1KQEb5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 23:31:57 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so1594550iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 20:31:57 -0800 (PST)
In-Reply-To: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Punch hole should never call ext4_ext_insert_extent, so this patch
removes code related to it from ext4_ext_insert_extent.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6888d1a..720070d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1737,8 +1737,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	 * There is no free space in the found leaf.
 	 * We're gonna add a new leaf in the tree.
 	 */
-	if (flag & EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
-		flags = EXT4_MB_USE_ROOT_BLOCKS;
 	err = ext4_ext_create_new_leaf(handle, inode, flags, path, newext);
 	if (err)
 		goto cleanup;
-- 
1.7.5.1

