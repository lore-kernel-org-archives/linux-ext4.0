From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 26/25] libext2fs: call get_alloc_block hook when allocating
 blocks
Date: Thu, 11 Sep 2014 12:41:53 -0700
Message-ID: <20140911194153.GR10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18303 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaIKTl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 15:41:59 -0400
Content-Disposition: inline
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a libext2fs client has provided a get_alloc_block hook, we need to
ensure that all code paths in the library use it to allocate blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/bb_inode.c    |   11 ++++++++++-
 lib/ext2fs/expanddir.c   |    3 +--
 lib/ext2fs/inline_data.c |    7 ++++---
 lib/ext2fs/mkdir.c       |    5 ++++-
 lib/ext2fs/mkjournal.c   |    5 ++++-
 lib/ext2fs/symlink.c     |    5 ++++-
 6 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index b0e114b..d659bb9 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -219,6 +219,7 @@ static int set_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
 		priv_data;
 	errcode_t	retval;
 	blk_t		blk;
+	blk64_t		blk2;
 
 	if (blockcnt >= 0) {
 		/*
@@ -241,7 +242,15 @@ static int set_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
 			if (ext2fs_test_block_bitmap2(fs->block_map, blk))
 				goto retry;
 		} else {
-			retval = ext2fs_new_block(fs, 0, 0, &blk);
+			if (fs->get_alloc_block) {
+				retval = fs->get_alloc_block(fs, 0, &blk2);
+				if (!retval && (blk2 >> 32)) {
+					rec->err = EOVERFLOW;
+					return BLOCK_ABORT;
+				}
+				blk = blk2;
+			} else
+				retval = ext2fs_new_block(fs, 0, 0, &blk);
 			if (retval) {
 				rec->err = retval;
 				return BLOCK_ABORT;
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index d0f7287..f412923 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -50,13 +50,12 @@ static int expand_dir_proc(ext2_filsys	fs,
 		new_blk = es->goal+1;
 	else {
 		es->goal &= ~EXT2FS_CLUSTER_MASK(fs);
-		retval = ext2fs_new_block2(fs, es->goal, 0, &new_blk);
+		retval = ext2fs_alloc_block2(fs, es->goal, NULL, &new_blk);
 		if (retval) {
 			es->err = retval;
 			return BLOCK_ABORT;
 		}
 		es->newblocks++;
-		ext2fs_block_alloc_stats2(fs, new_blk, +1);
 	}
 	if (blockcnt > 0) {
 		retval = ext2fs_new_dir_block(fs, 0, 0, &block);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 7eb8b94..7a6c721 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -357,7 +357,7 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext2_ino_t ino,
 			      struct ext2_inode *inode, char *buf, size_t size)
 {
 	errcode_t retval;
-	blk64_t blk;
+	blk64_t blk = 0;
 	char *blk_buf;
 
 	retval = ext2fs_get_memzero(fs->blocksize, &blk_buf);
@@ -376,7 +376,7 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext2_ino_t ino,
 	if (retval)
 		goto errout;
 	/* Allocate a new block */
-	retval = ext2fs_new_block2(fs, 0, 0, &blk);
+	retval = ext2fs_alloc_block2(fs, 0, NULL, &blk);
 	if (retval)
 		goto errout;
 	retval = ext2fs_write_dir_block4(fs, blk, blk_buf, 0, ino);
@@ -397,9 +397,10 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext2_ino_t ino,
 	retval = ext2fs_write_inode(fs, ino, inode);
 	if (retval)
 		goto errout;
-	ext2fs_block_alloc_stats(fs, blk, +1);
 
 errout:
+	if (retval && blk)
+		ext2fs_block_alloc_stats(fs, blk, -1);
 	ext2fs_free_mem(&blk_buf);
 	return retval;
 }
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index c4c7967..a184129 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -69,7 +69,10 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	 * Allocate a data block for the directory
 	 */
 	if (!inline_data) {
-		retval = ext2fs_new_block2(fs, 0, 0, &blk);
+		if (fs->get_alloc_block)
+			retval = fs->get_alloc_block(fs, 0, &blk);
+		else
+			retval = ext2fs_new_block2(fs, 0, 0, &blk);
 		if (retval)
 			goto cleanup;
 	}
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 0a7cd18..f9cec4e 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -242,7 +242,10 @@ static int mkjournal_proc(ext2_filsys	fs,
 		new_blk = es->goal+1;
 	else {
 		es->goal &= ~EXT2FS_CLUSTER_MASK(fs);
-		retval = ext2fs_new_block2(fs, es->goal, 0, &new_blk);
+		if (fs->get_alloc_block)
+			retval = fs->get_alloc_block(fs, es->goal, &new_blk);
+		else
+			retval = ext2fs_new_block2(fs, es->goal, 0, &new_blk);
 		if (retval) {
 			es->err = retval;
 			return BLOCK_ABORT;
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index f6eb6b6..b361e02 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -53,7 +53,10 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	 */
 	fastlink = (target_len < sizeof(inode.i_block));
 	if (!fastlink) {
-		retval = ext2fs_new_block2(fs, 0, 0, &blk);
+		if (fs->get_alloc_block)
+			retval = fs->get_alloc_block(fs, 0, &blk);
+		else
+			retval = ext2fs_new_block2(fs, 0, 0, &blk);
 		if (retval)
 			goto cleanup;
 		retval = ext2fs_get_mem(fs->blocksize, &block_buf);
