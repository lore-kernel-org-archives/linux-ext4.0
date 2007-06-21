From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 5/11][take 2] new bitmaps interface in e2fsprogs
Date: Thu, 21 Jun 2007 17:21:22 +0200
Message-ID: <467A9772.5040903@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000409020803070109020309"
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37083 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbXFUPzf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:55:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------000409020803070109020309
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch introduces new bitmap interface for ext4 filesystems which 
uses the new type blk64_t.

  bitmaps.c |  156 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
  bitops.c  |   36 ++++++++++++++
  bitops.h  |   29 +++++++++++
  ext2fs.h  |   25 +++++++++
  4 files changed, 231 insertions(+), 15 deletions(-)




--------------000409020803070109020309
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="05-new-bitmaps-interface-to-handle-blk64_t-blocks"
Content-Disposition: inline;
 filename="05-new-bitmaps-interface-to-handle-blk64_t-blocks"

Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2fs.h	2007-06-21 13:12:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h	2007-06-21 13:13:03.000000000 +0200
@@ -112,13 +112,30 @@ struct ext2fs_struct_generic_bitmap {
 	__u32		reserved[7];
 };
 
+struct ext4fs_struct_generic_bitmap {
+	errcode_t	magic;
+	ext2_filsys 	fs;
+	blk64_t		start, end;
+	blk64_t		real_end;
+	char	*	description;
+	char	*	bitmap;
+	errcode_t	base_error_code;
+	__u32		reserved[7];
+};
+
 #define EXT2FS_MARK_ERROR 	0
 #define EXT2FS_UNMARK_ERROR 	1
 #define EXT2FS_TEST_ERROR	2
 
+#ifdef _EXT4FS_
+typedef struct ext4fs_struct_generic_bitmap *ext2fs_generic_bitmap;
+typedef struct ext4fs_struct_generic_bitmap *ext2fs_inode_bitmap;
+typedef struct ext4fs_struct_generic_bitmap *ext2fs_block_bitmap;
+#else
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_generic_bitmap;
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_inode_bitmap;
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_block_bitmap;
+#endif
 
 #define EXT2_FIRST_INODE(s)	EXT2_FIRST_INO(s)
 
@@ -580,11 +597,19 @@ extern errcode_t ext2fs_write_inode_bitm
 extern errcode_t ext2fs_write_block_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_inode_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_block_bitmap(ext2_filsys fs);
+#ifndef _EXT4FS_
 extern errcode_t ext2fs_allocate_generic_bitmap(__u32 start,
 						__u32 end,
 						__u32 real_end,
 						const char *descr,
 						ext2fs_generic_bitmap *ret);
+#else
+extern errcode_t ext2fs_allocate_generic_bitmap(blk64_t start,
+						blk64_t end,
+						blk64_t real_end,
+						const char *descr,
+						ext2fs_generic_bitmap *ret);
+#endif
 extern errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 					      const char *descr,
 					      ext2fs_block_bitmap *ret);
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bitmaps.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/bitmaps.c	2007-06-21 13:12:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bitmaps.c	2007-06-21 13:13:03.000000000 +0200
@@ -27,6 +27,7 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+#ifndef _EXT4FS_
 static errcode_t make_bitmap(__u32 start, __u32 end, __u32 real_end,
 			     const char *descr, char *init_map,
 			     ext2fs_generic_bitmap *ret)
@@ -81,26 +82,135 @@ errcode_t ext2fs_allocate_generic_bitmap
 	return make_bitmap(start, end, real_end, descr, 0, ret);
 }
 
-errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap src,
-			     ext2fs_generic_bitmap *dest)
+void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map)
+{
+	__u32	i, j;
+
+	/* Protect loop from wrap-around if map->real_end is maxed */
+	for (i=map->end+1, j = i - map->start; 
+	     i <= map->real_end && i > map->end; 
+	     i++, j++)
+		ext2fs_set_bit(j, map->bitmap);
+
+	return;
+}	
+
+errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
+				       const char *descr,
+				       ext2fs_inode_bitmap *ret)
+{
+	ext2fs_inode_bitmap bitmap;
+	errcode_t	retval;
+	__u32		start, end, real_end;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	fs->write_bitmaps = ext2fs_write_bitmaps;
+
+	start = 1;
+	end = fs->super->s_inodes_count;
+	real_end = (EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count);
+
+	retval = ext2fs_allocate_generic_bitmap(start, end, real_end,
+						descr, &bitmap);
+	if (retval)
+		return retval;
+	
+	bitmap->magic = EXT2_ET_MAGIC_INODE_BITMAP;
+	bitmap->fs = fs;
+	bitmap->base_error_code = EXT2_ET_BAD_INODE_MARK;
+	
+	*ret = bitmap;
+	return 0;
+}
+
+errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
+				       const char *descr,
+				       ext2fs_block_bitmap *ret)
 {
+	ext2fs_block_bitmap bitmap;
+	errcode_t	retval;
+	__u32		start, end, real_end;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	fs->write_bitmaps = ext2fs_write_bitmaps;
+
+	start = fs->super->s_first_data_block;
+	end = fs->super->s_blocks_count-1;
+	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)  
+		    * fs->group_desc_count)-1 + start;
+	
+	retval = ext2fs_allocate_generic_bitmap(start, end, real_end,
+						descr, &bitmap);
+	if (retval)
+		return retval;
+
+	bitmap->magic = EXT2_ET_MAGIC_BLOCK_BITMAP;
+	bitmap->fs = fs;
+	bitmap->base_error_code = EXT2_ET_BAD_BLOCK_MARK;
+	
+	*ret = bitmap;
+	return 0;
+}
+#else
+static errcode_t make_bitmap(blk64_t start, blk64_t end, blk64_t real_end,
+			     const char *descr, char *init_map,
+			     ext2fs_generic_bitmap *ret)
+{
+	ext2fs_generic_bitmap	bitmap;
 	errcode_t		retval;
-	ext2fs_generic_bitmap	new_map;
+	size_t			size;
 
-	retval = make_bitmap(src->start, src->end, src->real_end,
-			     src->description, src->bitmap, &new_map);
+	retval = ext2fs_get_mem(sizeof(struct ext4fs_struct_generic_bitmap), 
+				&bitmap);
 	if (retval)
 		return retval;
-	new_map->magic = src->magic;
-	new_map->fs = src->fs;
-	new_map->base_error_code = src->base_error_code;
-	*dest = new_map;
+
+	bitmap->magic = EXT2_ET_MAGIC_GENERIC_BITMAP;
+	bitmap->fs = NULL;
+	bitmap->start = start;
+	bitmap->end = end;
+	bitmap->real_end = real_end;
+	bitmap->base_error_code = EXT2_ET_BAD_GENERIC_MARK;
+	if (descr) {
+		retval = ext2fs_get_mem(strlen(descr)+1, &bitmap->description);
+		if (retval) {
+			ext2fs_free_mem(&bitmap);
+			return retval;
+		}
+		strcpy(bitmap->description, descr);
+	} else
+		bitmap->description = 0;
+
+	size = (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1);
+	retval = ext2fs_get_mem(size, &bitmap->bitmap);
+	if (retval) {
+		ext2fs_free_mem(&bitmap->description);
+		ext2fs_free_mem(&bitmap);
+		return retval;
+	}
+
+	if (init_map)
+		memcpy(bitmap->bitmap, init_map, size);
+	else
+		memset(bitmap->bitmap, 0, size);
+	*ret = bitmap;
 	return 0;
 }
 
+errcode_t ext2fs_allocate_generic_bitmap(blk64_t start,
+					 blk64_t end,
+					 blk64_t real_end,
+					 const char *descr,
+					 ext2fs_generic_bitmap *ret)
+{
+	return make_bitmap(start, end, real_end, descr, 0, ret);
+}
+
 void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map)
 {
-	__u32	i, j;
+	blk64_t	i, j;
 
 	/* Protect loop from wrap-around if map->real_end is maxed */
 	for (i=map->end+1, j = i - map->start; 
@@ -117,7 +227,7 @@ errcode_t ext2fs_allocate_inode_bitmap(e
 {
 	ext2fs_inode_bitmap bitmap;
 	errcode_t	retval;
-	__u32		start, end, real_end;
+	blk64_t		start, end, real_end;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -125,7 +235,7 @@ errcode_t ext2fs_allocate_inode_bitmap(e
 
 	start = 1;
 	end = fs->super->s_inodes_count;
-	real_end = (EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count);
+	real_end = (blk64_t) EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count;
 
 	retval = ext2fs_allocate_generic_bitmap(start, end, real_end,
 						descr, &bitmap);
@@ -146,7 +256,7 @@ errcode_t ext2fs_allocate_block_bitmap(e
 {
 	ext2fs_block_bitmap bitmap;
 	errcode_t	retval;
-	__u32		start, end, real_end;
+	blk64_t		start, end, real_end;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -154,7 +264,7 @@ errcode_t ext2fs_allocate_block_bitmap(e
 
 	start = fs->super->s_first_data_block;
 	end = fs->super->s_blocks_count-1;
-	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)  
+	real_end = ((blk64_t) EXT2_BLOCKS_PER_GROUP(fs->super)  
 		    * fs->group_desc_count)-1 + start;
 	
 	retval = ext2fs_allocate_generic_bitmap(start, end, real_end,
@@ -169,6 +279,24 @@ errcode_t ext2fs_allocate_block_bitmap(e
 	*ret = bitmap;
 	return 0;
 }
+#endif
+
+errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap src,
+			     ext2fs_generic_bitmap *dest)
+{
+	errcode_t		retval;
+	ext2fs_generic_bitmap	new_map;
+
+	retval = make_bitmap(src->start, src->end, src->real_end,
+			     src->description, src->bitmap, &new_map);
+	if (retval)
+		return retval;
+	new_map->magic = src->magic;
+	new_map->fs = src->fs;
+	new_map->base_error_code = src->base_error_code;
+	*dest = new_map;
+	return 0;
+}
 
 errcode_t ext2fs_fudge_inode_bitmap_end(ext2fs_inode_bitmap bitmap,
 					ext2_ino_t end, ext2_ino_t *oend)
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bitops.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/bitops.c	2007-06-21 13:12:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bitops.c	2007-06-21 13:13:03.000000000 +0200
@@ -30,6 +30,7 @@
  * systems, as well as non-32 bit systems.
  */
 
+#ifndef _EXT4FS_
 int ext2fs_set_bit(unsigned int nr,void * addr)
 {
 	int		mask, retval;
@@ -63,6 +64,41 @@ int ext2fs_test_bit(unsigned int nr, con
 	mask = 1 << (nr & 0x07);
 	return (mask & *ADDR);
 }
+#else
+int ext2fs_set_bit(blk64_t nr,void * addr)
+{
+	int		mask, retval;
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	retval = mask & *ADDR;
+	*ADDR |= mask;
+	return retval;
+}
+
+int ext2fs_clear_bit(blk64_t nr, void * addr)
+{
+	int		mask, retval;
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	retval = mask & *ADDR;
+	*ADDR &= ~mask;
+	return retval;
+}
+
+int ext2fs_test_bit(blk64_t nr, const void * addr)
+{
+	int			mask;
+	const unsigned char	*ADDR = (const unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	return (mask & *ADDR);
+}
+#endif
 
 #endif	/* !_EXT2_HAVE_ASM_BITOPS_ */
 
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bitops.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/bitops.h	2007-06-21 13:12:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bitops.h	2007-06-21 13:13:03.000000000 +0200
@@ -14,11 +14,19 @@
  */
 
 
+#ifndef _EXT4FS_
 extern int ext2fs_set_bit(unsigned int nr,void * addr);
 extern int ext2fs_clear_bit(unsigned int nr, void * addr);
 extern int ext2fs_test_bit(unsigned int nr, const void * addr);
 extern void ext2fs_fast_set_bit(unsigned int nr,void * addr);
 extern void ext2fs_fast_clear_bit(unsigned int nr, void * addr);
+#else
+extern int ext2fs_set_bit(blk64_t nr,void * addr);
+extern int ext2fs_clear_bit(blk64_t nr, void * addr);
+extern int ext2fs_test_bit(blk64_t nr, const void * addr);
+extern void ext2fs_fast_set_bit(blk64_t nr,void * addr);
+extern void ext2fs_fast_clear_bit(blk64_t nr, void * addr);
+#endif
 extern __u16 ext2fs_swab16(__u16 val);
 extern __u32 ext2fs_swab32(__u32 val);
 extern __u64 ext2fs_swab64(__u64 val);
@@ -141,6 +149,7 @@ extern int ext2fs_unmark_generic_bitmap(
  * previous bit value.
  */
 
+#ifndef _EXT4FS_
 _INLINE_ void ext2fs_fast_set_bit(unsigned int nr,void * addr)
 {
 	unsigned char	*ADDR = (unsigned char *) addr;
@@ -156,10 +165,28 @@ _INLINE_ void ext2fs_fast_clear_bit(unsi
 	ADDR += nr >> 3;
 	*ADDR &= ~(1 << (nr & 0x07));
 }
+#else
+_INLINE_ void ext2fs_fast_set_bit(blk64_t nr,void * addr)
+{
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	*ADDR |= (1 << (nr & 0x07));
+}
+
+_INLINE_ void ext2fs_fast_clear_bit(blk64_t nr, void * addr)
+{
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	*ADDR &= ~(1 << (nr & 0x07));
+}
+#endif
 
 
 #if ((defined __GNUC__) && !defined(_EXT2_USE_C_VERSIONS_) && \
-     (defined(__i386__) || defined(__i486__) || defined(__i586__)))
+     (defined(__i386__) || defined(__i486__) || defined(__i586__)) && \
+     !(defined(_EXT2_64BIT_BLK_T) && (SIZEOF_LONG == 4)))
 
 #define _EXT2_HAVE_ASM_BITOPS_
 #define _EXT2_HAVE_ASM_SWAB_

--------------000409020803070109020309--
