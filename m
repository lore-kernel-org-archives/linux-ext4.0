From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ext4: remove block_device_ejected
Date: Sat, 14 Feb 2015 06:27:42 -0700
Message-ID: <1423920462-20646-1-git-send-email-hch@lst.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbbBNN3Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Feb 2015 08:29:16 -0500
Received: from bombadil.infradead.org ([2001:1868:205::9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YMcmZ-0001qG-K7
	for linux-ext4@vger.kernel.org; Sat, 14 Feb 2015 13:29:15 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bdi->dev now never goes away, so this function became useless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/super.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ad88e60..826cb66 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -323,22 +323,6 @@ static void save_error_info(struct super_block *sb, const char *func,
 	ext4_commit_super(sb, 1);
 }
 
-/*
- * The del_gendisk() function uninitializes the disk-specific data
- * structures, including the bdi structure, without telling anyone
- * else.  Once this happens, any attempt to call mark_buffer_dirty()
- * (for example, by ext4_commit_super), will cause a kernel OOPS.
- * This is a kludge to prevent these oops until we can put in a proper
- * hook in del_gendisk() to inform the VFS and file system layers.
- */
-static int block_device_ejected(struct super_block *sb)
-{
-	struct inode *bd_inode = sb->s_bdev->bd_inode;
-	struct backing_dev_info *bdi = inode_to_bdi(bd_inode);
-
-	return bdi->dev == NULL;
-}
