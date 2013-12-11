From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 34/74] e2fsck: in rehash,
 mark newly allocated extent blocks as found
Date: Tue, 10 Dec 2013 17:22:07 -0800
Message-ID: <20131211012207.30655.92282.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26715 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3LKBWO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:14 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're rehashing directories, it's possible that an extent block
(or a map block) could be (silently) allocated by the underlying
libext2fs when expanding the directory.  This silent allocation is not
captured in block_found_map, which is disastrous if later the rehash
process expands another directory and uses that same block from
before without realizing that it's now in use.

Therefore, if we notice that the free block count has dropped by more
than what e2fsck allocated itself during the expansion, we iterate the
directory's blocks a second time to ensure that these silent
allocations are marked in the found blocks bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass3.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)


diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 6989f17..dc9d7c1 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -758,6 +758,27 @@ static int expand_dir_proc(ext2_filsys fs,
 		return BLOCK_CHANGED;
 }
 
+/*
+ * Ensure that all blocks are marked in the block_found_map, since it's
+ * possible that the library allocated an extent node block or a block map
+ * block during the directory rebuilding; these new allocations are not
+ * captured in block_found_map.  This is bad since we could later use
+ * block_found_map to allocate more blocks.
+ */
+static int find_new_blocks_proc(ext2_filsys fs,
+				blk64_t	*blocknr,
+				e2_blkcnt_t	blockcnt,
+				blk64_t ref_block EXT2FS_ATTR((unused)),
+				int ref_offset EXT2FS_ATTR((unused)),
+				void	*priv_data)
+{
+	struct expand_dir_struct *es = (struct expand_dir_struct *) priv_data;
+	e2fsck_t	ctx = es->ctx;
+
+	ext2fs_mark_block_bitmap2(ctx->block_found_map, *blocknr);
+	return 0;
+}
+
 errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 				  int num, int guaranteed_size)
 {
@@ -765,7 +786,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	errcode_t	retval;
 	struct expand_dir_struct es;
 	struct ext2_inode	inode;
-	blk64_t		sz;
+	blk64_t		sz, before, after;
 
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
@@ -788,11 +809,27 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	es.ctx = ctx;
 	es.dir = dir;
 
+	before = ext2fs_free_blocks_count(fs->super);
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
 
 	if (es.err)
 		return es.err;
+	after = ext2fs_free_blocks_count(fs->super);
+
+	/*
+	 * If the free block count has dropped by more than the blocks we
+	 * allocated ourselves, then we must've allocated some extent/map
+	 * blocks.  Therefore, we must iterate this dir's blocks again to
+	 * ensure that all newly allocated blocks are captured in
+	 * block_found_map.
+	 */
+	if ((before - after) > es.newblocks) {
+		retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_READ_ONLY,
+					       0, find_new_blocks_proc, &es);
+		if (es.err)
+			return es.err;
+	}
 
 	/*
 	 * Update the size and block count fields in the inode.

