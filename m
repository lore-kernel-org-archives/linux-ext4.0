From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] libext2fs: Fix SET_BMAP bugs in ext2fs_bmap() and ext2fs_bmap2()
Date: Sun, 29 Nov 2009 15:33:26 -0500
Message-ID: <1259526809-23697-2-git-send-email-tytso@mit.edu>
References: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35132 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZK2Ud4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Nov 2009 15:33:56 -0500
In-Reply-To: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't byte-swap the block number when setting i_block[x], since the
write_inode function will take of byte swapping the inode.

The phys_blk parameter contains an input parameter in the SET_BMAP
case, so it must be passed to ext2fs_bmap2() from the legacy function
ext2fs_bmap().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/bmap.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 2a86439..933036b 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -214,9 +214,6 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 	if (block < EXT2_NDIR_BLOCKS) {
 		if (bmap_flags & BMAP_SET) {
 			b = *phys_blk;
-#ifdef WORDS_BIGENDIAN
-			b = ext2fs_swab32(b);
-#endif
 			inode_bmap(inode, block) = b;
 			inode_dirty++;
 			goto done;
@@ -325,7 +322,7 @@ errcode_t ext2fs_bmap(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		      blk_t *phys_blk)
 {
 	errcode_t ret;
-	blk64_t	ret_blk;
+	blk64_t	ret_blk = *phys_blk;
 
 	ret = ext2fs_bmap2(fs, ino, inode, block_buf, bmap_flags, block,
 			    0, &ret_blk);
-- 
1.6.5.216.g5288a.dirty

