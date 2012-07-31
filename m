From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 28/36 v4] debugfs: make punch/truncate cmd support inline data
Date: Tue, 31 Jul 2012 19:48:21 +0800
Message-ID: <1343735309-30579-29-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53943 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2GaLki (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:38 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540999pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:38 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

If inode includes inline_data flag, start and end arguments will be ignored.
Meanwhile we truncate inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/punch.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index b53653a..28967a4 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -281,6 +281,34 @@ errout:
 	ext2fs_extent_free(handle);
 	return retval;
 }
+
+static errcode_t ext2fs_punch_inline_data(ext2_filsys fs, ext2_ino_t ino,
+					  struct ext2_inode *inode,
+					  blk64_t start, blk64_t end)
+{
+	struct ext2_inode_large large_inode;
+	struct inline_data idata;
+	errcode_t retval;
+	int inline_size;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)&large_inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		return retval;
+
+	ext2fs_iget_extra_inode(fs, &large_inode, &idata);
+
+	inline_size = idata.inline_size;
+	retval = inline_data_destory_data(fs, ino, &large_inode, &idata);
+	if (retval)
+		return retval;
+
+	large_inode.i_size = 0;
+	ext2fs_write_inode_full(fs, ino, (void *)&large_inode,
+				EXT2_INODE_SIZE(fs->super));
+
+	return retval;
+}
 	
 /*
  * Deallocate all logical blocks starting at start to end, inclusive.
@@ -307,7 +335,10 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 			return retval;
 		inode = &inode_buf;
 	}
-	if (inode->i_flags & EXT4_EXTENTS_FL)
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		retval = ext2fs_punch_inline_data(fs, ino, inode, start, end);
+		return retval;
+	} else if (inode->i_flags & EXT4_EXTENTS_FL)
 		retval = ext2fs_punch_extent(fs, ino, inode, start, end);
 	else {
 		blk_t	count;
-- 
1.7.4.1

