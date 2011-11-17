From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/6] ext4: remove useless BUG_ON in ext4_ext_insert_extent
Date: Thu, 17 Nov 2011 10:03:21 +0800
Message-ID: <1321495405-9583-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab1KQEbw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 23:31:52 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so1594550iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 20:31:51 -0800 (PST)
In-Reply-To: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

npath is set to NULL and is not set again before BUG_ON, so
the BUG_ON is useless.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6b4a558..8591bc8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1718,7 +1718,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		next = ext4_ext_next_leaf_block(path);
 	if (next != EXT_MAX_BLOCKS) {
 		ext_debug("next leaf block - %u\n", next);
-		BUG_ON(npath != NULL);
 		npath = ext4_ext_find_extent(inode, next, NULL);
 		if (IS_ERR(npath))
 			return PTR_ERR(npath);
-- 
1.7.5.1

