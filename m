From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext3: remove redundant checking for small blocksize
Date: Fri,  6 May 2011 16:40:27 +0800
Message-ID: <1304671227-6163-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51369 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1EFIkk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2011 04:40:40 -0400
Received: by pvg12 with SMTP id 12so1338387pvg.19
        for <linux-ext4@vger.kernel.org>; Fri, 06 May 2011 01:40:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The set_blocksize (which is in sb_set_blocksize) will fail
if a blocksize is too small:

	/* Size cannot be smaller than the size supported by the device */
	if (size < bdev_logical_block_size(bdev))
		return -EINVAL;

Therefore remove the checking for small blocksize before "sb_set_blocksize"
to make it consistent to ext2.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext3/super.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 3c6a9e0..ae813cd 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1628,7 +1628,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	unsigned long def_mount_opts;
 	struct inode *root;
 	int blocksize;
-	int hblock;
 	int db_count;
 	int i;
 	int needs_recovery;
@@ -1761,20 +1760,9 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	hblock = bdev_logical_block_size(sb->s_bdev);
 	if (sb->s_blocksize != blocksize) {
-		/*
-		 * Make sure the blocksize for the filesystem is larger
-		 * than the hardware sectorsize for the machine.
-		 */
-		if (blocksize < hblock) {
-			ext3_msg(sb, KERN_ERR,
-				"error: fsblocksize %d too small for "
-				"hardware sectorsize %d", blocksize, hblock);
-			goto failed_mount;
-		}
