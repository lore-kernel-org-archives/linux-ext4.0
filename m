From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] ext4: fix ext4_debug format
Date: Thu, 17 Nov 2011 18:19:56 +0800
Message-ID: <1321525196-16009-1-git-send-email-wenqing.lz@taobao.com>
References: <CAGBYx2YchtAbkc1b_V2AdEHb=_9sRLKU8W+hjFuTH8VNh1-FHw@mail.gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: xiaoqiangnk@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52555 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab1KQKSh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 05:18:37 -0500
Received: by ywt32 with SMTP id 32so823469ywt.19
        for <linux-ext4@vger.kernel.org>; Thu, 17 Nov 2011 02:18:37 -0800 (PST)
In-Reply-To: <CAGBYx2YchtAbkc1b_V2AdEHb=_9sRLKU8W+hjFuTH8VNh1-FHw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

v1->v2:
 * format flags by %x instead of %d for more readable

Fix ext4_debug format in ext4_ext_handle_uninitialized_extents() and
ext4_end_io_dio().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |    4 ++--
 fs/ext4/inode.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..f5d62d7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3454,8 +3454,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	int err = 0;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
 
-	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical"
-		  "block %llu, max_blocks %u, flags %d, allocated %u",
+	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical "
+		  "block %llu, max_blocks %u, flags %x, allocated %u\n",
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

