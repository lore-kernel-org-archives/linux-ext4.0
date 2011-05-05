From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext2: fix error msg when mounting fs with too-large blocksize
Date: Thu,  5 May 2011 10:44:04 +0800
Message-ID: <1304563444-4842-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54711 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1EECoT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 May 2011 22:44:19 -0400
Received: by pvg12 with SMTP id 12so771422pvg.19
        for <linux-ext4@vger.kernel.org>; Wed, 04 May 2011 19:44:19 -0700 (PDT)
To: linux-ext4@vger.kernel.org
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
Reviewed-by: Coly Li <bosong.ly@taobao.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext2/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d89e0b6..8dfae33 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -882,7 +882,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, blocksize)) {
-			ext2_msg(sb, KERN_ERR, "error: blocksize is too small");
+			ext2_msg(sb, KERN_ERR,
+				"error: bad blocksize %d", blocksize);
 			goto failed_sbi;
 		}
 
-- 
1.7.1

