From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 05/21 v5] libext2fs: handle inline_data in block iterator function
Date: Sat, 22 Sep 2012 12:00:53 +0800
Message-ID: <1348286469-31690-6-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2IVDvH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:07 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873835pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:07 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We needn't traverse blocks for an inode which has inline data because no block
belongs to it.  After appling this patch, the following commands in debugfs can
handle inline_data feature:
	- icheck
	- blocks
	- filefrag

In some places, block iterator functions are used to traverse blocks of
directory.  In this case, we need to check whether inode has inline_data flag or
not, and handle it manually.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/block.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 68dcb03..4abcedf 100644
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
1.7.4.1

