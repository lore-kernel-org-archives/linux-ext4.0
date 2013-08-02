From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 05/22] libext2fs: handle inline_data in block iterator function
Date: Fri,  2 Aug 2013 17:49:32 +0800
Message-ID: <1375436989-18948-6-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54897 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab3HBJu0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:50:26 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq13so493280pab.11
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:50:25 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We needn't traverse blocks for an inode which has inline data because no
block belongs to it.  After applied this patch, the following commands
in debugfs can handle inline_data feature:
	- icheck
	- blocks
	- filefrag

In some places, block iterator functions are used to traverse blocks of
directory.  In this case, we need to check whether inode has inline_data
flag or not, and handle it manually.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/block.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index b8c6879..b194ca8 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -345,6 +345,13 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 		return ctx.errcode;
 
 	/*
+	 * If an inode has inline data, we needn't traverse its blocks
+	 * because no block belong to this inode.
+	 */
+	if (inode.i_flags & EXT4_INLINE_DATA_FL)
+		return ctx.errcode;
+
+	/*
 	 * Check to see if we need to limit large files
 	 */
 	if (flags & BLOCK_FLAG_NO_LARGE) {
-- 
1.7.9.7

