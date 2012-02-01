From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] resize2fs: let online resizing report new blocks count right
Date: Wed,  1 Feb 2012 11:04:08 +0800
Message-ID: <1328065448-13693-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, dsd@laptop.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2DAMDk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Apr 2012 08:03:40 -0400
Received: by iagz16 with SMTP id z16so2913062iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Apr 2012 05:03:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After online resizing finishes, resize2fs loads the latest super block
so that the new blocks count is reported correctly.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 resize/online.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/resize/online.c b/resize/online.c
index 966ea1e..cb48556 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -97,8 +97,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 			exit(1);
 		}
 	} else {
-		close(fd);
-		return 0;
+		goto succeeded;
 	}
 
 	if ((ext2fs_blocks_count(sb) > MAX_32_NUM) ||
@@ -220,6 +219,19 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	}
 
 	ext2fs_free(new_fs);
+succeeded:
+	/*
+	 * load the lastest super block.
+ 	 */
+	io_channel_set_blksize(fs->io, SUPERBLOCK_OFFSET);
+	retval = io_channel_read_blk(fs->io, 1, -SUPERBLOCK_SIZE,
+			     fs->super);
+	if (retval == 0)
+		*new_size = ext2fs_blocks_count(fs->super);
+	else
+		printf(_("Resize succeeded, however an error happened "
+		       "when loading super block.\n\n"));
+
 	close(fd);
 
 	return 0;
-- 
1.7.5.1

