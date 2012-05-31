From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] libext2fs: fix i_blocks for extent leaf create/delete
Date: Thu, 31 May 2012 11:31:58 -0700
Message-ID: <1338489118-13483-1-git-send-email-adityakali@google.com>
Cc: linux-ext4@vger.kernel.org, Aditya Kali <adityakali@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55904 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326Ab2EaScD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 May 2012 14:32:03 -0400
Received: by eeit10 with SMTP id t10so74584eei.1
        for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 11:32:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When libext2fs allocates/deletes an extent leaf, the i_blocks
value is incremented/decremented by fs->blocksize / 512. This
is incorrect in case of bigalloc. The correct way here is to
use cluster_size / 512.
The problem is seen if we try to create a large inode using
libext2fs (say using ext2fs_block_iterate3()) on a bigalloc
filesystem. fsck catches this and complains.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 lib/ext2fs/extent.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index eb096d6..8828764 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1027,7 +1027,8 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 		goto done;
 
 	/* new node hooked in, so update inode block count (do this here?) */
-	handle->inode->i_blocks += handle->fs->blocksize / 512;
+	handle->inode->i_blocks += (handle->fs->blocksize *
+				    EXT2FS_CLUSTER_RATIO(handle->fs)) / 512;
 	retval = ext2fs_write_inode(handle->fs, handle->ino,
 				    handle->inode);
 	if (retval)
@@ -1501,7 +1502,9 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 				return retval;
 
 			retval = ext2fs_extent_delete(handle, flags);
-			handle->inode->i_blocks -= handle->fs->blocksize / 512;
+			handle->inode->i_blocks -=
+				(handle->fs->blocksize *
+				 EXT2FS_CLUSTER_RATIO(handle->fs)) / 512;
 			retval = ext2fs_write_inode(handle->fs, handle->ino,
 						    handle->inode);
 			ext2fs_block_alloc_stats2(handle->fs,
-- 
1.7.7.3

