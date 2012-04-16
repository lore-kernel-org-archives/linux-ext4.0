From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 27/32] debugfs: make bma cmd support inline data
Date: Mon, 16 Apr 2012 19:40:02 +0800
Message-ID: <1334576407-4007-28-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DPLem (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:42 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:41 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now this command returns inode's phy block when this inode has inline data.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/bmap.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 16d51e0..101fe90 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -264,6 +264,22 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
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
+
+		goto done;
+	}
+
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
 		retval = ext2fs_extent_open2(fs, ino, inode, &handle);
 		if (retval)
-- 
1.7.4.1

