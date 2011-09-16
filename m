From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 22/25] tune2fs: handle inode and/or block bitmap read failures in resize_inode()
Date: Fri, 16 Sep 2011 15:49:37 -0500
Message-ID: <1316206180-6375-23-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46758 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Handle these failures in resize_inode, and handle the propagated
error in the caller.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/tune2fs.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 6d879f3..346e2d1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1589,8 +1589,16 @@ static int resize_inode(ext2_filsys fs, unsigned long new_size)
 	int new_ino_blks_per_grp;
 	ext2fs_block_bitmap bmap;
 
-	ext2fs_read_inode_bitmap(fs);
-	ext2fs_read_block_bitmap(fs);
+	retval = ext2fs_read_inode_bitmap(fs);
+	if (retval) {
+		fputs(_("Failed to read inode bitmap\n"), stderr);
+		return retval;
+	}
+	retval = ext2fs_read_block_bitmap(fs);
+	if (retval) {
+		fputs(_("Failed to read blockbitmap\n"), stderr);
+		return retval;
+	}
 	INIT_LIST_HEAD(&blk_move_list);
 
 
@@ -1989,6 +1997,9 @@ retry_open:
 		if (resize_inode(fs, new_inode_size) == 0) {
 			printf(_("Setting inode size %lu\n"),
 							new_inode_size);
+		} else {
+			printf(_("Failed to change inode size\n"));
+			exit(1);
 		}
 	}
 
-- 
1.7.4.1

