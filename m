From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 27/36 v4] debugfs: make bmap cmd support inline data
Date: Tue, 31 Jul 2012 19:48:20 +0800
Message-ID: <1343735309-30579-28-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab2GaLkg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:36 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
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

