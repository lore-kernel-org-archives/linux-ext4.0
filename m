From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext2: fix error msg when mounting fs with too-large blocksize
Date: Sun, 24 Apr 2011 14:36:31 +0800
Message-ID: <1303626991-6704-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:34460 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab1DXGgs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 02:36:48 -0400
Received: by pxi2 with SMTP id 2so1240475pxi.10
        for <linux-ext4@vger.kernel.org>; Sat, 23 Apr 2011 23:36:48 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When ext2 mounts a filesystem, it attempts to set the block device
blocksize with a call to sb_set_blocksize, which can fail for
several reasons.  The current failure message in ext2 prints:

  EXT2-fs (loop1): error: blocksize is too small

which is not correct in all cases.  This can be demonstrated
by creating a filesystem with

  # mkfs.ext2 -b 8192

on a 4k page system, and attempting to mount it.

Change the error message to a more generic:

  EXT2-fs (loop1): bad blocksize 8192

to match the error message in ext3.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext2/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 0a78dae..1dd62ed 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -898,7 +898,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, blocksize)) {
-			ext2_msg(sb, KERN_ERR, "error: blocksize is too small");
+			ext2_msg(sb, KERN_ERR,
+				"error: bad blocksize %d", blocksize);
 			goto failed_sbi;
 		}
 
-- 
1.7.3.2

