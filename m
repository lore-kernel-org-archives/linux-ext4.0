From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 11/22] debugfs: handle inline_data feature in bmap command
Date: Fri,  2 Aug 2013 17:49:38 +0800
Message-ID: <1375436989-18948-12-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47968 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab3HBJuz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:50:55 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so490445pab.35
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:50:54 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

If an inode has inline data, bmap command will return the physical block
of this inode.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/bmap.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index aadd22e..408cd37 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -264,6 +264,21 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		block_buf = buf;
 	}
 
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		unsigned long group, pblock, offset;
+
+		group = (ino - 1) / EXT2_INODES_PER_GROUP(fs->super);
+		if (group > fs->group_desc_count)
+			return EXT2_ET_BAD_INODE_NUM;
+		offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
+			 EXT2_INODE_SIZE(fs->super);
+		pblock = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
+		if (!ext2fs_inode_table_loc(fs, (unsigned) group))
+			return EXT2_ET_MISSING_INODE_TABLE;
+		*phys_blk = ext2fs_inode_table_loc(fs, group) + pblock;
+		goto done;
+	}
+
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
 		retval = ext2fs_extent_open2(fs, ino, inode, &handle);
 		if (retval)
-- 
1.7.9.7

