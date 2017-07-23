From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] e2fsck: quiet some harmless bitmap warnings
Date: Sun, 23 Jul 2017 00:50:31 -0400
Message-ID: <20170723045035.26019-1-tytso@mit.edu>
Cc: abuchbinder@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51416 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750767AbdGWEup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 00:50:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

E2fsck checks block numbers against the block_metadata_map before it
checks to see whether or not the block numbers are valid.  So suppress
these harmless warnings.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/pass1.c                       | 2 ++
 tests/f_ind_inode_collision/expect.1 | 1 -
 tests/f_itable_collision/expect.1    | 8 --------
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 160e677ab..c358eec0f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2710,6 +2710,7 @@ report_problem:
 			 * will reallocate the block; then we can try again.
 			 */
 			if (pb->ino != EXT2_RESIZE_INO &&
+			    extent.e_pblk < ctx->fs->super->s_blocks_count &&
 			    ext2fs_test_block_bitmap2(ctx->block_metadata_map,
 						      extent.e_pblk)) {
 				next_try_repairs = 0;
@@ -3448,6 +3449,7 @@ static int process_block(ext2_filsys fs,
 	 */
 	if (blockcnt < 0 &&
 	    p->ino != EXT2_RESIZE_INO &&
+	    blk < ctx->fs->super->s_blocks_count &&
 	    ext2fs_test_block_bitmap2(ctx->block_metadata_map, blk)) {
 		pctx->blk = blk;
 		fix_problem(ctx, PR_1_CRITICAL_METADATA_COLLISION, pctx);
diff --git a/tests/f_ind_inode_collision/expect.1 b/tests/f_ind_inode_collision/expect.1
index 012cd9ffb..63c128b44 100644
--- a/tests/f_ind_inode_collision/expect.1
+++ b/tests/f_ind_inode_collision/expect.1
@@ -2,7 +2,6 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 12 block 41 conflicts with critical metadata, skipping block checks.
 Inode 12 block 40 conflicts with critical metadata, skipping block checks.
 Inode 12 block 34 conflicts with critical metadata, skipping block checks.
-Illegal block number passed to ext2fs_test_block_bitmap #16777215 for metadata block map
 Inode 12 block 1 conflicts with critical metadata, skipping block checks.
 Inode 12, i_size is 33, should be 25227264.  Fix? yes
 
diff --git a/tests/f_itable_collision/expect.1 b/tests/f_itable_collision/expect.1
index 00cdced80..01c85d4d2 100644
--- a/tests/f_itable_collision/expect.1
+++ b/tests/f_itable_collision/expect.1
@@ -12,23 +12,15 @@ Inodes that were part of a corrupted orphan linked list found.  Fix? yes
 
 Inode 49 was part of the orphaned inode list.  FIXED.
 Inode 14 block 36 conflicts with critical metadata, skipping block checks.
-Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
 Inode 14 has illegal block(s).  Clear? yes
 
 Illegal indirect block (4294967295) in inode 14.  CLEARED.
-Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
 Illegal indirect block (4294967295) in inode 14.  CLEARED.
-Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
 Illegal indirect block (4294967295) in inode 14.  CLEARED.
-Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
 Illegal indirect block (4294967295) in inode 14.  CLEARED.
-Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
 Illegal indirect block (4294967295) in inode 14.  CLEARED.
-Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
 Illegal indirect block (4294967295) in inode 14.  CLEARED.
-Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
 Illegal indirect block (4294967295) in inode 14.  CLEARED.
-Illegal block number passed to ext2fs_test_block_bitmap #4294967295 for metadata block map
 Too many illegal blocks in inode 14.
 Clear inode? yes
 
-- 
2.11.0.rc0.7.gbe5a750
