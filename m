From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 01/10] libext2fs: add default_bitmap_type to the ext2_filsys structure
Date: Sun, 18 Dec 2011 01:42:29 -0500
Message-ID: <1324190558-7436-2-git-send-email-tytso@mit.edu>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50563 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1LRGml (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 01:42:41 -0500
In-Reply-To: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This allows a program to control the bitmap backend implementation
that will get used without needing to change the current library API.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/bitmaps.c      |   14 +++++++-------
 lib/ext2fs/ext2fs.h       |   10 +++++++++-
 lib/ext2fs/ext2fsP.h      |    2 --
 lib/ext2fs/gen_bitmap64.c |    3 +++
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/bitmaps.c b/lib/ext2fs/bitmaps.c
index e518295..8402191 100644
--- a/lib/ext2fs/bitmaps.c
+++ b/lib/ext2fs/bitmaps.c
@@ -67,9 +67,9 @@ errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 	/* Are we permitted to use new-style bitmaps? */
 	if (fs->flags & EXT2_FLAG_64BITS)
 		return (ext2fs_alloc_generic_bmap(fs,
-				  EXT2_ET_MAGIC_INODE_BITMAP64,
-				  EXT2FS_BMAP64_BITARRAY,
-				  start, end, real_end, descr, ret));
+				EXT2_ET_MAGIC_INODE_BITMAP64,
+				fs->default_bitmap_type,
+				start, end, real_end, descr, ret));
 
 	/* Otherwise, check to see if the file system is small enough
 	 * to use old-style 32-bit bitmaps */
@@ -99,9 +99,9 @@ errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 
 	if (fs->flags & EXT2_FLAG_64BITS)
 		return (ext2fs_alloc_generic_bmap(fs,
-				  EXT2_ET_MAGIC_BLOCK_BITMAP64,
-				  EXT2FS_BMAP64_BITARRAY,
-				  start, end, real_end, descr, ret));
+				EXT2_ET_MAGIC_BLOCK_BITMAP64,
+				fs->default_bitmap_type,
+				start, end, real_end, descr, ret));
 
 	if ((end > ~0U) || (real_end > ~0U))
 		return EXT2_ET_CANT_USE_LEGACY_BITMAPS;
@@ -143,7 +143,7 @@ errcode_t ext2fs_allocate_subcluster_bitmap(ext2_filsys fs,
 		    * (__u64) fs->group_desc_count)-1 + start;
 
 	retval = ext2fs_alloc_generic_bmap(fs, EXT2_ET_MAGIC_BLOCK_BITMAP64,
-					   EXT2FS_BMAP64_BITARRAY, start,
+					   fs->default_bitmap_type, start,
 					   end, real_end, descr, &bmap);
 	if (retval)
 		return retval;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 227ee58..d90a8b1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -244,10 +244,12 @@ struct struct_ext2_filsys {
 	__u32				umask;
 	time_t				now;
 	int				cluster_ratio_bits;
+	__u16				default_bitmap_type;
+	__u16				pad;
 	/*
 	 * Reserved for future expansion
 	 */
-	__u32				reserved[6];
+	__u32				reserved[5];
 
 	/*
 	 * Reserved for the use of the calling application.
@@ -287,6 +289,12 @@ struct struct_ext2_filsys {
 #endif
 
 /*
+ * 64-bit bitmap backend types
+ */
+
+#define EXT2FS_BMAP64_BITARRAY	1
+
+/*
  * Return flags for the block iterator functions
  */
 #define BLOCK_CHANGED	1
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 82e1ba0..729d5c5 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -109,8 +109,6 @@ extern void ext2fs_numeric_progress_close(ext2_filsys fs,
  * 64-bit bitmap support
  */
 
-#define EXT2FS_BMAP64_BITARRAY	1
