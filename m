From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 50/74] libext2fs: support allocating uninit blocks in bmap2()
Date: Tue, 10 Dec 2013 17:23:53 -0800
Message-ID: <20131211012353.30655.82545.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27117 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LKBX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:23:59 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In order to support fallocate, we need to be able to have
ext2fs_bmap2() allocate blocks and put them into uninitialized
extents.  There's a flag to do this in the extent code, but it's not
exposed to the bmap2 interface, so plumb that in.  Eventually fuse2fs
or somebody will use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/bmap.c   |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 lib/ext2fs/ext2fs.h |    1 +
 2 files changed, 48 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 3a18d76..ca89eb1 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -33,6 +33,32 @@ extern errcode_t ext2fs_bmap(ext2_filsys fs, ext2_ino_t ino,
 
 #define inode_bmap(inode, nr) ((inode)->i_block[(nr)])
 
+static errcode_t zero_block(ext2_filsys fs, blk64_t blk)
+{
+	void *b;
+	errcode_t retval;
+
+	if (io_channel_discard_zeroes_data(fs->io)) {
+		retval = io_channel_discard(fs->io, blk, 1);
+		if (retval == 0)
+			return 0;
+	}
+
+	retval = ext2fs_get_memzero(fs->blocksize, &b);
+	if (retval)
+		return retval;
+
+	memset(b, 0, fs->blocksize);
+
+	retval = io_channel_write_blk64(fs->io, blk, 1, b);
+	if (retval)
+		goto out;
+
+out:
+	ext2fs_free_mem(&b);
+	return retval;
+}
+
 static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags,
 					      blk_t ind, char *block_buf,
 					      int *blocks_alloc,
@@ -72,6 +98,11 @@ static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags,
 					    block_buf + fs->blocksize, &b);
 		if (retval)
 			return retval;
+		if (flags & BMAP_UNINIT) {
+			retval = zero_block(fs, b);
+			if (retval)
+				return retval;
+		}
 
 #ifdef WORDS_BIGENDIAN
 		((blk_t *) block_buf)[nr] = ext2fs_swab32(b);
@@ -214,10 +245,13 @@ static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
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
@@ -254,7 +288,7 @@ got_block:
 		alloc++;
 	set_extent:
 		retval = ext2fs_extent_set_bmap(handle, block,
-						blk64, 0);
+						blk64, set_flags);
 		if (retval)
 			return retval;
 		/* Update inode after setting extent */
@@ -336,6 +370,12 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		goto done;
 	}
 
+	if ((bmap_flags & BMAP_SET) && (bmap_flags & BMAP_UNINIT)) {
+		retval = zero_block(fs, *phys_blk);
+		if (retval)
+			goto done;
+	}
+
 	if (block < EXT2_NDIR_BLOCKS) {
 		if (bmap_flags & BMAP_SET) {
 			b = *phys_blk;
@@ -351,6 +391,11 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 			retval = ext2fs_alloc_block(fs, b, block_buf, &b);
 			if (retval)
 				goto done;
+			if (bmap_flags & BMAP_UNINIT) {
+				retval = zero_block(fs, b);
+				if (retval)
+					goto done;
+			}
 			inode_bmap(inode, block) = b;
 			blocks_alloc++;
 			*phys_blk = b;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index da518df..316e6f5 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -525,6 +525,7 @@ typedef struct ext2_icount *ext2_icount_t;
  */
 #define BMAP_ALLOC	0x0001
 #define BMAP_SET	0x0002
+#define BMAP_UNINIT	0x0004
 
 /*
  * Returned flags from ext2fs_bmap

