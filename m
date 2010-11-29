From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 07/15] libext2fs: fix error path in ext2fs_update_bb_inode()
Date: Mon, 29 Nov 2010 17:55:09 +0900
Message-ID: <1291020917-8671-8-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42577 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0K2Izj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:39 -0500
Received: by mail-yx0-f174.google.com with SMTP id 3so1359797yxt.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:39 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext2fs_get_mem() on rec.block_buf fails we should not call
ext2fs_free_mem() on it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/ext2fs/bb_inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index 0b79b16..9576be2 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -74,8 +74,10 @@ errcode_t ext2fs_update_bb_inode(ext2_filsys fs, ext2_badblocks_list bb_list)
 		return retval;
 	memset(rec.ind_blocks, 0, rec.max_ind_blocks * sizeof(blk_t));
 	retval = ext2fs_get_mem(fs->blocksize, &rec.block_buf);
-	if (retval)
-		goto cleanup;
+	if (retval) {
+		ext2fs_free_mem(&rec.ind_blocks);
+		return retval;
+	}
 	memset(rec.block_buf, 0, fs->blocksize);
 	rec.err = 0;
 
-- 
1.7.0.4

