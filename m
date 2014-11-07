From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 37/47] libext2fs: support allocating uninit blocks in bmap2()
Date: Fri, 07 Nov 2014 13:54:46 -0800
Message-ID: <20141107215446.883.89630.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46524 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaKGVyv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:54:51 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As part of supporting fallocate-like functionality, extend
ext2fs_bmap() with two flags -- BMAP_UNINIT and BMAP_ZERO.  The first
will cause it to mark/set a block uninitialized, if it's part of an
extent based file.  For a block mapped file, the mapping is put in,
but there is no way to remember the uninitialized status.  The second
flag causes the block to be zeroed to support the use case of
emulating uninitialized blocks on a block-map file by zeroing them.

Eventually fallocate or fuse2fs or somebody will use these.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/bmap.c   |    9 +++++++--
 lib/ext2fs/ext2fs.h |    2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index cb3f5a1..c18f742 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -214,10 +214,13 @@ static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
 	errcode_t		retval = 0;
 	blk64_t			blk64 = 0;
 	int			alloc = 0;
+	int			set_flags;
+
+	set_flags = bmap_flags & BMAP_UNINIT ? EXT2_EXTENT_SET_BMAP_UNINIT : 0;
 
 	if (bmap_flags & BMAP_SET) {
 		retval = ext2fs_extent_set_bmap(handle, block,
-						*phys_blk, 0);
+						*phys_blk, set_flags);
 		return retval;
 	}
 	retval = ext2fs_extent_goto(handle, block);
@@ -254,7 +257,7 @@ got_block:
 		alloc++;
 	set_extent:
 		retval = ext2fs_extent_set_bmap(handle, block,
-						blk64, 0);
+						blk64, set_flags);
 		if (retval) {
 			ext2fs_block_alloc_stats2(fs, blk64, -1);
 			return retval;
@@ -441,6 +444,8 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 	if (retval == 0)
 		*phys_blk = blk32;
 done:
+	if (*phys_blk && retval == 0 && (bmap_flags & BMAP_ZERO))
+		retval = ext2fs_zero_blocks2(fs, *phys_blk, 1, NULL, NULL);
 	if (buf)
 		ext2fs_free_mem(&buf);
 	if (handle)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 84e4e1f..6a97a1f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -527,6 +527,8 @@ typedef struct ext2_icount *ext2_icount_t;
  */
 #define BMAP_ALLOC	0x0001
 #define BMAP_SET	0x0002
+#define BMAP_UNINIT	0x0004
+#define BMAP_ZERO	0x0008
 
 /*
  * Returned flags from ext2fs_bmap

