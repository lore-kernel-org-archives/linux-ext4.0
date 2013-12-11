From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/74] libext2fs: don't allow ridiculously large logical block
 numbers
Date: Tue, 10 Dec 2013 17:19:10 -0800
Message-ID: <20131211011909.30655.58893.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3LKBTP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:19:15 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Forbid clients from trying to map logical block numbers that are
larger than the lblk->pblk data structures are capable of handling.
While we're at it, don't let clients set the file size to a number
that's beyond what can be mapped.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/bmap.c    |   24 ++++++++++++++++++++++++
 lib/ext2fs/ext2fsP.h |    4 ++++
 lib/ext2fs/fileio.c  |    3 +++
 3 files changed, 31 insertions(+)


diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 5074587..32788f6 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -238,6 +238,27 @@ got_block:
 	return 0;
 }
 
+int ext2fs_file_block_offset_too_big(ext2_filsys fs,
+				     struct ext2_inode *inode,
+				     blk64_t offset)
+{
+	blk64_t addr_per_block, max_map_block;
+
+	/* Kernel seems to cut us off at 4294967294 blocks */
+	if (offset >= (1ULL << 32) - 1)
+		return 1;
+
+	if (inode->i_flags & EXT4_EXTENTS_FL)
+		return 0;
+
+	addr_per_block = fs->blocksize >> 2;
+	max_map_block = addr_per_block;
+	max_map_block += addr_per_block * addr_per_block;
+	max_map_block += addr_per_block * addr_per_block * addr_per_block;
+	max_map_block += 12;
+
+	return offset >= max_map_block;
+}
 
 errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		       char *block_buf, int bmap_flags, blk64_t block,
@@ -266,6 +287,9 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 	}
 	addr_per_block = (blk_t) fs->blocksize >> 2;
 
+	if (ext2fs_file_block_offset_too_big(fs, inode, block))
+		return EXT2_ET_FILE_TOO_BIG;
+
 	if (!block_buf) {
 		retval = ext2fs_get_array(2, fs->blocksize, &buf);
 		if (retval)
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 80d2d0a..8c7983b 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -158,3 +158,7 @@ extern errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap bitmap,
 extern void ext2fs_warn_bitmap32(ext2fs_generic_bitmap bitmap,const char *func);
 
 extern int ext2fs_mem_is_zero(const char *mem, size_t len);
+
+int ext2fs_file_block_offset_too_big(ext2_filsys fs,
+				     struct ext2_inode *inode,
+				     blk64_t offset);
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 6b213b5..a6bcbe7 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -392,6 +392,9 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 
 	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
 
+	if (size && ext2fs_file_block_offset_too_big(file->fs, &file->inode,
+					(size - 1) / file->fs->blocksize))
+		return EXT2_ET_FILE_TOO_BIG;
 	truncate_block = ((size + file->fs->blocksize - 1) >>
 			  EXT2_BLOCK_SIZE_BITS(file->fs->super));
 	old_size = EXT2_I_SIZE(&file->inode);

