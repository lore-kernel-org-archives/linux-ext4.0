From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 11/21 v5] debugfs: handle inline_data feature in bmap command
Date: Sat, 22 Sep 2012 12:00:59 +0800
Message-ID: <1348286469-31690-12-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2IVDvT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:19 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873835pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:19 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

If an inode has inline data, bmap command will return the physical block of this
inode.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/bmap.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 16d51e0..4746a1f 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -264,6 +264,21 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		block_buf = buf;
 	}
 
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		unsigned long group, block, offset;
+
+		group = (ino - 1) / EXT2_INODES_PER_GROUP(fs->super);
+		if (group > fs->group_desc_count)
+			return EXT2_ET_BAD_INODE_NUM;
+		offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
+			 EXT2_INODE_SIZE(fs->super);
+		block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
+		if (!ext2fs_inode_table_loc(fs, (unsigned) group))
+			return EXT2_ET_MISSING_INODE_TABLE;
+		*phys_blk = ext2fs_inode_table_loc(fs, group) + block;
+		goto done;
+	}
+
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
 		retval = ext2fs_extent_open2(fs, ino, inode, &handle);
 		if (retval)
-- 
1.7.4.1

