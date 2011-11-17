From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/2] [PATCH] ext4: fix ext4_debug format
Date: Thu, 17 Nov 2011 15:19:50 +0800
Message-ID: <1321514390-14903-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54444 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1KQHSL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 02:18:11 -0500
Received: by iage36 with SMTP id e36so1726148iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 23:18:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix ext4_debug format in ext4_ext_handle_uninitialized_extents() and
ext4_end_io_dio().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |    4 ++--
 fs/ext4/inode.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..8e2a57c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3454,8 +3454,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	int err = 0;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
 
-	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical"
-		  "block %llu, max_blocks %u, flags %d, allocated %u",
+	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical "
+		  "block %llu, max_blocks %u, flags %d, allocated %u\n",
 		  inode->i_ino, (unsigned long long)map->m_lblk, map->m_len,
 		  flags, allocated);
 	ext4_ext_show_leaf(inode, path);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 240f6e2..4c037f9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2775,7 +2775,7 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 	if (!io_end || !size)
 		goto out;
 
-	ext_debug("ext4_end_io_dio(): io_end 0x%p"
+	ext_debug("ext4_end_io_dio(): io_end 0x%p "
 		  "for inode %lu, iocb 0x%p, offset %llu, size %llu\n",
  		  iocb->private, io_end->inode->i_ino, iocb, offset,
 		  size);
-- 
1.7.4.1

