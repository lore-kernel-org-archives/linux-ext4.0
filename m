From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/47] libext2fs: don't allow alloc_stats on bad inode/block
 numbers
Date: Fri, 07 Nov 2014 13:51:21 -0800
Message-ID: <20141107215121.883.24372.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVvb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:31 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't allow callers to feed bad block/inode numbers to
ext2fs_*_alloc_stats2, because evil callers (<cough>resize2fs<cough>)
can corrupt library state this way, leading to a crash.

(There will be a subsequent patch to resize2fs to fix its bad
behavior.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc_stats.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 3d3697c..aca5004 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -20,13 +20,13 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 {
 	int	group = ext2fs_group_of_ino(fs, ino);
 
-#ifndef OMIT_COM_ERR
 	if (ino > fs->super->s_inodes_count) {
+#ifndef OMIT_COM_ERR
 		com_err("ext2fs_inode_alloc_stats2", 0,
 			"Illegal inode number: %lu", (unsigned long) ino);
+#endif
 		return;
 	}
-#endif
 	if (inuse > 0)
 		ext2fs_mark_inode_bitmap2(fs->inode_map, ino);
 	else
@@ -62,13 +62,13 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 {
 	int	group = ext2fs_group_of_blk2(fs, blk);
 
-#ifndef OMIT_COM_ERR
 	if (blk >= ext2fs_blocks_count(fs->super)) {
+#ifndef OMIT_COM_ERR
 		com_err("ext2fs_block_alloc_stats", 0,
 			"Illegal block number: %lu", (unsigned long) blk);
+#endif
 		return;
 	}
-#endif
 	if (inuse > 0)
 		ext2fs_mark_block_bitmap2(fs->block_map, blk);
 	else

