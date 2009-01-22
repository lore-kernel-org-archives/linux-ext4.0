From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: Add sanity checks to ext2fs_{block,inode}_alloc_stats
Date: Thu, 22 Jan 2009 16:33:03 -0500
Message-ID: <1232659984-10183-3-git-send-email-tytso@mit.edu>
References: <20090122211224.GJ14966@mit.edu>
 <1232659984-10183-1-git-send-email-tytso@mit.edu>
 <1232659984-10183-2-git-send-email-tytso@mit.edu>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44601 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZAVVdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jan 2009 16:33:07 -0500
In-Reply-To: <1232659984-10183-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext2fs_inode_alloc_stats2() or ext2fs_block_alloc_stats() is passed
an insanely large inode or block number, it's possible for these
functions to overrun an array boundary and cause the calling program
to crash with a memory error.

Detect this case, and since these functions don't return an error
code, print a warning message, much like we do in ext2fs_warn_bitmap2().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/alloc_stats.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 97661dc..d523b43 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -20,6 +20,13 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 {
 	int	group = ext2fs_group_of_ino(fs, ino);
 
+#ifndef OMIT_COM_ERR
+	if (ino > fs->super->s_inodes_count) {
+		com_err("ext2fs_inode_alloc_stats2", 0,
+			"Illegal inode number: %lu", ino);
+		return;
+	}
+#endif
 	if (inuse > 0)
 		ext2fs_mark_inode_bitmap(fs->inode_map, ino);
 	else
@@ -58,6 +65,13 @@ void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
 {
 	int	group = ext2fs_group_of_blk(fs, blk);
 
+#ifndef OMIT_COM_ERR
+	if (blk >= fs->super->s_blocks_count) {
+		com_err("ext2fs_block_alloc_stats2", 0,
+			"Illegal block number: %lu", blk);
+		return;
+	}
+#endif
 	if (inuse > 0)
 		ext2fs_mark_block_bitmap(fs->block_map, blk);
 	else
-- 
1.6.0.4.8.g36f27.dirty

