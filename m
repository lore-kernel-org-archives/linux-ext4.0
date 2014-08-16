From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/27] libext2fs: byteswap inode when performing the sanity
 scan
Date: Sat, 16 Aug 2014 16:46:10 -0700
Message-ID: <20140816234610.11171.63032.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23793 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaHPXqP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:46:15 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On BE platforms, we need to swap the inode bytes after doing the
checksum verification but before looking at i_blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inode.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 6c766af..4310b82 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -406,7 +406,7 @@ static void check_inode_block_sanity(ext2_inode_scan scan, blk64_t num_blocks)
 	void		*p;
 	struct ext2_inode_large *inode;
 	char		*block_status;
-	unsigned int	blk;
+	unsigned int	blk, bad_csum;
 
 	if (!(scan->scan_flags & EXT2_SF_WARN_GARBAGE_INODES))
 		return;
@@ -423,12 +423,26 @@ static void check_inode_block_sanity(ext2_inode_scan scan, blk64_t num_blocks)
 	memset(block_status, 0, scan->inode_buffer_blocks);
 	inodes_per_block = EXT2_INODES_PER_BLOCK(scan->fs->super);
 
+#ifdef WORDS_BIGENDIAN
+	if (ext2fs_get_mem(EXT2_INODE_SIZE(scan->fs->super), &inode))
+		return;
+#endif
+
 	while (inodes_to_scan > 0) {
 		blk = (p - (void *)scan->inode_buffer) / scan->fs->blocksize;
+		bad_csum = ext2fs_inode_csum_verify(scan->fs, ino, p) == 0;
+
+#ifdef WORDS_BIGENDIAN
+		ext2fs_swap_inode_full(scan->fs,
+			       (struct ext2_inode_large *) inode,
+			       (struct ext2_inode_large *) p,
+			       0, EXT2_INODE_SIZE(scan->fs->super));
+#else
 		inode = p;
+#endif
 
 		/* Is this inode insane? */
-		if (!ext2fs_inode_csum_verify(scan->fs, ino, inode)) {
+		if (bad_csum) {
 			checksum_failures++;
 			badness++;
 		} else if (extent_head_looks_insane(inode) ||
@@ -460,6 +474,10 @@ static void check_inode_block_sanity(ext2_inode_scan scan, blk64_t num_blocks)
 		p += scan->inode_size;
 		ino++;
 	};
+
+#ifdef WORDS_BIGENDIAN
+	ext2fs_free_mem(&inode);
+#endif
 }
 
 /*

