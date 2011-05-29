From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] Correct comments for ext4_free_blocks().
Date: Sun, 29 May 2011 16:52:39 +0800
Message-ID: <1306659159-15753-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:49936 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1E2IwD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 May 2011 04:52:03 -0400
Received: by pxi2 with SMTP id 2so1940104pxi.10
        for <linux-ext4@vger.kernel.org>; Sun, 29 May 2011 01:52:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

metadata is not parameter of ext4_free_blocks() any more.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 859f2ae..eb71dd5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4448,7 +4448,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
  * @inode:		inode
  * @block:		start physical block to free
  * @count:		number of blocks to count
- * @metadata: 		Are these metadata blocks
+ * @flags:		flags used by ext4_free_blocks
  */
 void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		      struct buffer_head *bh, ext4_fsblk_t block,
