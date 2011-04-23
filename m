From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] fix incorrect error-message of ext2
Date: Sat, 23 Apr 2011 21:36:58 +0800
Message-ID: <1303565818-19512-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40973 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1DWNhP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Apr 2011 09:37:15 -0400
Received: by pwi15 with SMTP id 15so661314pwi.19
        for <linux-ext4@vger.kernel.org>; Sat, 23 Apr 2011 06:37:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

After "mkfs.ext2 -b 8192" on a new partition, I mount it with a error dmesg:
"error: blocksize is too small"
That's not correct.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext2/super.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 0a78dae..f3008c1 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -758,6 +758,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long def_mount_opts;
 	long ret = -EINVAL;
 	int blocksize = BLOCK_SIZE;
+	int hblock;
 	int db_count;
 	int i, j;
 	__le32 features;
@@ -893,12 +894,25 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
+	hblock = bdev_logical_block_size(sb->s_bdev);
 	/* If the blocksize doesn't match, re-read the thing.. */
 	if (sb->s_blocksize != blocksize) {
+		/*
+		 * Make sure the blocksize for the filesystem is larger
+		 * than the hardware sectorsize for the machine.
+		 */
+		if (blocksize < hblock) {
+			ext2_msg(sb, KERN_ERR,
+				"error: fsblocksize %d too small for "
+				"hardware sectorsize %d", blocksize, hblock);
+			goto failed_mount;
+		}
+
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, blocksize)) {
-			ext2_msg(sb, KERN_ERR, "error: blocksize is too small");
+			ext2_msg(sb, KERN_ERR,
+				"error: bad blocksize %d", blocksize);
 			goto failed_sbi;
 		}
 
-- 
1.7.3.2

