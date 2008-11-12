From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 04/17] Implement 64-bit "bitarray" bmap ops
Date: Tue, 11 Nov 2008 19:42:57 -0800
Message-ID: <1226461390-5502-5-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42462 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYKLDnw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:52 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hprm007423
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:51 -0500
In-Reply-To: <1226461390-5502-4-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---
 lib/ext2fs/bitops.h       |  176 ++++++++++++++++++++++++-
 lib/ext2fs/blkmap64_ba.c  |  174 ++++++++++++++++++++++-
 lib/ext2fs/ext2fs.h       |    4 +
 lib/ext2fs/ext2fsP.h      |   15 +-
 lib/ext2fs/gen_bitmap64.c |  333 ++++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 649 insertions(+), 53 deletions(-)

diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index d681778..1138800 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -109,7 +109,7 @@ extern int ext2fs_fast_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 					       blk_t block, int num);
 extern void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map);
 
-/* These routines moved to gen_bitmap.c */
+/* These routines moved to gen_bitmap.c (actually, some of the above, too) */
 extern int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
 					 __u32 bitno);
 extern int ext2fs_unmark_generic_bitmap(ext2fs_generic_bitmap bitmap,
@@ -121,6 +121,60 @@ extern int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 extern __u32 ext2fs_get_generic_bitmap_start(ext2fs_generic_bitmap bitmap);
 extern __u32 ext2fs_get_generic_bitmap_end(ext2fs_generic_bitmap bitmap);
 
+/* 64-bit versions */
+
+extern int ext2fs_mark_block_bitmap2(ext2fs_block_bitmap64 bitmap, blk64_t block);
+extern int ext2fs_unmark_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+				       blk64_t block);
+extern int ext2fs_test_block_bitmap2(ext2fs_block_bitmap64 bitmap, blk64_t block);
+
+extern int ext2fs_mark_inode_bitmap2(ext2fs_inode_bitmap64 bitmap, ext2_ino_t inode);
+extern int ext2fs_unmark_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+				       ext2_ino_t inode);
+extern int ext2fs_test_inode_bitmap2(ext2fs_inode_bitmap64 bitmap, ext2_ino_t inode);
+
+extern void ext2fs_fast_mark_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+					   blk64_t block);
+extern void ext2fs_fast_unmark_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+					     blk64_t block);
+extern int ext2fs_fast_test_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+					  blk64_t block);
+
+extern void ext2fs_fast_mark_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+					   ext2_ino_t inode);
+extern void ext2fs_fast_unmark_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+					    ext2_ino_t inode);
+extern int ext2fs_fast_test_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+					  ext2_ino_t inode);
+extern blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap64 bitmap);
+extern ext2_ino_t ext2fs_get_inode_bitmap_start2(ext2fs_inode_bitmap64 bitmap);
+extern blk64_t ext2fs_get_block_bitmap_end2(ext2fs_block_bitmap64 bitmap);
+extern ext2_ino_t ext2fs_get_inode_bitmap_end2(ext2fs_inode_bitmap64 bitmap);
+
+extern int ext2fs_fast_test_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+						blk64_t block, int num);
+extern void ext2fs_fast_mark_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+						 blk64_t block, int num);
+extern void ext2fs_fast_unmark_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+						   blk64_t block, int num);
+/* These routines moved to gen_bitmap64.c */
+extern int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap64 bitmap,
+				    blk64_t bitno);
+extern int ext2fs_unmark_generic_bmap(ext2fs_generic_bitmap64 bitmap,
+				      blk64_t bitno);
+extern int ext2fs_test_generic_bmap(ext2fs_generic_bitmap64 bitmap,
+				    blk64_t bitno);
+extern int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+					   blk64_t block, int num);
+extern __u64 ext2fs_get_generic_bmap_start(ext2fs_generic_bitmap64 bitmap);
+extern __u64 ext2fs_get_generic_bmap_end(ext2fs_generic_bitmap64 bitmap);
+extern int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+					   blk64_t block, int num);
+extern void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+					    blk64_t block, int num);
+extern void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+					      blk64_t block, int num);
+
 /*
  * The inline routines themselves...
  *
@@ -546,6 +600,126 @@ _INLINE_ void ext2fs_fast_unmark_block_bitmap_range(ext2fs_block_bitmap bitmap,
 {
 	ext2fs_unmark_block_bitmap_range(bitmap, block, num);
 }
+
+/* 64-bit versions */
+
+_INLINE_ int ext2fs_mark_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+				       blk64_t block)
+{
+	return ext2fs_mark_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					block);
+}
+
+_INLINE_ int ext2fs_unmark_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+					 blk64_t block)
+{
+	return ext2fs_unmark_generic_bmap((ext2fs_generic_bitmap64) bitmap, block);
+}
+
+_INLINE_ int ext2fs_test_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+				       blk64_t block)
+{
+	return ext2fs_test_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					block);
+}
+
+_INLINE_ int ext2fs_mark_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+				       ext2_ino_t inode)
+{
+	return ext2fs_mark_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					inode);
+}
+
+_INLINE_ int ext2fs_unmark_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+					 ext2_ino_t inode)
+{
+	return ext2fs_unmark_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					  inode);
+}
+
+_INLINE_ int ext2fs_test_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+				       ext2_ino_t inode)
+{
+	return ext2fs_test_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					inode);
+}
+
+_INLINE_ void ext2fs_fast_mark_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+					     blk64_t block)
+{
+	ext2fs_mark_generic_bmap((ext2fs_generic_bitmap64) bitmap, block);
+}
+
+_INLINE_ void ext2fs_fast_unmark_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+					       blk64_t block)
+{
+	ext2fs_unmark_generic_bmap((ext2fs_generic_bitmap64) bitmap, block);
+}
+
+_INLINE_ int ext2fs_fast_test_block_bitmap2(ext2fs_block_bitmap64 bitmap,
+					    blk64_t block)
+{
+	return ext2fs_test_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					block);
+}
+
+_INLINE_ void ext2fs_fast_mark_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+					     ext2_ino_t inode)
+{
+	ext2fs_mark_generic_bmap((ext2fs_generic_bitmap64) bitmap, inode);
+}
+
+_INLINE_ void ext2fs_fast_unmark_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+					       ext2_ino_t inode)
+{
+	ext2fs_unmark_generic_bmap((ext2fs_generic_bitmap64) bitmap, inode);
+}
+
+_INLINE_ int ext2fs_fast_test_inode_bitmap2(ext2fs_inode_bitmap64 bitmap,
+					    ext2_ino_t inode)
+{
+	return ext2fs_test_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					inode);
+}
+
+_INLINE_ blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap64 bitmap)
+{
+	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap64) bitmap);
+}
+
+_INLINE_ ext2_ino_t ext2fs_get_inode_bitmap_start2(ext2fs_inode_bitmap64 bitmap)
+{
+	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap64) bitmap);
+}
+
+_INLINE_ blk64_t ext2fs_get_block_bitmap_end2(ext2fs_block_bitmap64 bitmap)
+{
+	return ext2fs_get_generic_bmap_end((ext2fs_generic_bitmap64) bitmap);
+}
+
+_INLINE_ ext2_ino_t ext2fs_get_inode_bitmap_end2(ext2fs_inode_bitmap64 bitmap)
+{
+	return ext2fs_get_generic_bmap_end((ext2fs_generic_bitmap64) bitmap);
+}
+
+_INLINE_ int ext2fs_fast_test_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+						  blk64_t block, int num)
+{
+	return ext2fs_test_block_bitmap_range2(bitmap, block, num);
+}
+
+_INLINE_ void ext2fs_fast_mark_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+						   blk64_t block, int num)
+{
+	ext2fs_mark_block_bitmap_range2(bitmap, block, num);
+}
+
+_INLINE_ void ext2fs_fast_unmark_block_bitmap_range2(ext2fs_block_bitmap64 bitmap,
+						     blk64_t block, int num)
+{
+	ext2fs_unmark_block_bitmap_range2(bitmap, block, num);
+}
+
 #undef _INLINE_
 #endif
 
diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
index 855a160..f7f7097 100644
--- a/lib/ext2fs/blkmap64_ba.c
+++ b/lib/ext2fs/blkmap64_ba.c
@@ -26,54 +26,211 @@
 #include "ext2_fs.h"
 #include "ext2fsP.h"
 
-static errcode_t ba_new_bmap(ext2_filsys fs, ext2fs_generic_bitmap64 *bmap)
+/*
+ * Private data for bit array implementation of bitmap ops.
+ * Currently, this is just a pointer to our big flat hunk of memory,
+ * exactly equivalent to the old-skool char * bitmap member.
+ */
+
+struct ext2fs_ba_private_struct {
+	char *bitarray;
+};
+
+typedef struct ext2fs_ba_private_struct *ext2fs_ba_private;
+
+static errcode_t ba_alloc_private_data (ext2fs_generic_bitmap64 bitmap)
+{
+	ext2fs_ba_private bp;
+	errcode_t	retval;
+	size_t		size;
+
+	/*
+	 * Since we only have the one pointer, we could just shove our
+	 * private data in the void *private field itself, but then
+	 * we'd have to do a fair bit of rewriting if we ever added a
+	 * field.  I'm agnostic.
+	 */
+	retval = ext2fs_get_mem(sizeof (ext2fs_ba_private), &bp);
+	if (retval)
+		return retval;
+
+	size = (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1);
+
+	retval = ext2fs_get_mem(size, &bp->bitarray);
+	if (retval) {
+		ext2fs_free_mem(&bp);
+		bp = 0;
+		return retval;
+	}
+	bitmap->private = (void *) bp;
+	return 0;
+}
+
+static errcode_t ba_new_bmap(ext2_filsys fs, ext2fs_generic_bitmap64 bitmap)
 {
+	ext2fs_ba_private bp;
+	errcode_t	retval;
+	size_t		size;
+
+	retval = ba_alloc_private_data (bitmap);
+	if (retval)
+		return retval;
+
+	bp = (ext2fs_ba_private) bitmap->private;
+	size = (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1);
+	memset(bp->bitarray, 0, size);
+
+	return 0;
 }
 
 static void ba_free_bmap(ext2fs_generic_bitmap64 bitmap)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+
+	if (!bp)
+		return;
+
+	if (bp->bitarray) {
+		ext2fs_free_mem (&bp->bitarray);
+		bp->bitarray = 0;
+	}
+	ext2fs_free_mem (&bp);
+	bp = 0;
 }
 
 static errcode_t ba_copy_bmap(ext2fs_generic_bitmap64 src,
-			      ext2fs_generic_bitmap64 *dest)
+			      ext2fs_generic_bitmap64 dest)
 {
+	ext2fs_ba_private src_bp = (ext2fs_ba_private) src->private;
+	ext2fs_ba_private dest_bp;
+	errcode_t retval;
+	size_t size;
+
+	retval = ba_alloc_private_data (dest);
+	if (retval)
+		return retval;
+
+	dest_bp = (ext2fs_ba_private) dest->private;
+
+	size = (size_t) (((src->real_end - src->start) / 8) + 1);
+	memcpy (dest_bp->bitarray, src_bp->bitarray, size);
+
+	return 0;
 }
 
-static errcode_t ba_resize_bmap(ext2fs_generic_bitmap64 bitmap,
+static errcode_t ba_resize_bmap(ext2fs_generic_bitmap64 bmap,
 				__u64 new_end, __u64 new_real_end)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bmap->private;
+	errcode_t	retval;
+	size_t		size, new_size;
+	__u32		bitno;
+
+	/*
+	 * If we're expanding the bitmap, make sure all of the new
+	 * parts of the bitmap are zero.
+	 */
+	if (new_end > bmap->end) {
+		bitno = bmap->real_end;
+		if (bitno > new_end)
+			bitno = new_end;
+		for (; bitno > bmap->end; bitno--)
+			ext2fs_clear_bit64(bitno - bmap->start, bp->bitarray);
+	}
+	if (new_real_end == bmap->real_end) {
+		bmap->end = new_end;
+		return 0;
+	}
+
+	size = ((bmap->real_end - bmap->start) / 8) + 1;
+	new_size = ((new_real_end - bmap->start) / 8) + 1;
+
+	if (size != new_size) {
+		retval = ext2fs_resize_mem(size, new_size, &bp->bitarray);
+		if (retval)
+			return retval;
+	}
+	if (new_size > size)
+		memset(bp->bitarray + size, 0, new_size - size);
+
+	bmap->end = new_end;
+	bmap->real_end = new_real_end;
+	return 0;
+
 }
 
 static int ba_mark_bmap(ext2fs_generic_bitmap64 bitmap, __u64 arg)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+
+	return ext2fs_set_bit64(bitno - bitmap->start, bp->bitarray);
 }
 
 static int ba_unmark_bmap(ext2fs_generic_bitmap64 bitmap, __u64 arg)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+
+	return ext2fs_clear_bit64(bitno - bitmap->start, bp->bitarray);
 }
 
 static int ba_test_bmap(ext2fs_generic_bitmap64 bitmap, __u64 arg)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+
+	return ext2fs_test_bit64(bitno - bitmap->start, bp->bitarray);
 }
 
 static void ba_mark_bmap_extent(ext2fs_generic_bitmap64 bitmap, __u64 arg,
-				 int num)
+				size_t num)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+	size_t i;
+
+	for (i = 0; i < num; i++)
+		ext2fs_fast_set_bit64(bitno + i - bitmap->start, bp->bitarray);
 }
 
 static void ba_unmark_bmap_extent(ext2fs_generic_bitmap64 bitmap, __u64 arg,
-				  int num)
+				  size_t num)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+	size_t i;
+
+	for (i = 0; i < num; i++)
+		ext2fs_fast_clear_bit64(bitno + i - bitmap->start, bp->bitarray);
 }
 
 static errcode_t ba_set_bmap_range(ext2fs_generic_bitmap64 bitmap,
-				     __u64 start, unsigned int num, void *in)
+				     __u64 start, size_t num, void *in)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+
+	memcpy (bp->bitarray + (start >> 3), in, (num + 7) >> 3);
+
+	return 0;
 }
 
 static errcode_t ba_get_bmap_range(ext2fs_generic_bitmap64 bitmap,
-				     __u64 start, unsigned int num, void *out)
+				     __u64 start, size_t num, void *out)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+
+	memcpy (out, bp->bitarray + (start >> 3), (num + 7) >> 3);
+
+	return 0;
+}
+
+static void ba_clear_bmap(ext2fs_generic_bitmap64 bitmap)
+{
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+
+	memset(bp->bitarray, 0,
+	       (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1));
 }
 
 struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
@@ -88,5 +245,6 @@ struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
 	.mark_bmap_extent = ba_mark_bmap_extent,
 	.unmark_bmap_extent = ba_unmark_bmap_extent,
 	.set_bmap_range = ba_set_bmap_range,
-	.get_bmap_range = ba_get_bmap_range
+	.get_bmap_range = ba_get_bmap_range,
+	.clear_bmap = ba_clear_bmap,
 };
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ad21fd7..dbc5909 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -103,6 +103,10 @@ typedef struct ext2fs_struct_generic_bitmap *ext2fs_generic_bitmap;
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_inode_bitmap;
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_block_bitmap;
 
+typedef struct ext2fs_struct_generic_bitmap64 *ext2fs_generic_bitmap64;
+typedef struct ext2fs_struct_generic_bitmap64 *ext2fs_inode_bitmap64;
+typedef struct ext2fs_struct_generic_bitmap64 *ext2fs_block_bitmap64;
+
 #define EXT2_FIRST_INODE(s)	EXT2_FIRST_INO(s)
 
 
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 6f8a4e1..390733b 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -113,15 +113,13 @@ struct ext2fs_struct_generic_bitmap64 {
 
 #define EXT2FS_BMAP64_BITARRAY	1
 
-typedef struct ext2fs_struct_generic_bitmap64 *ext2fs_generic_bitmap64;
-
 struct ext2_bitmap_ops {
 	int	type;
 	/* Generic bmap operators */
-	errcode_t (*new_bmap)(ext2_filsys fs, ext2fs_generic_bitmap64 *bmap);
+	errcode_t (*new_bmap)(ext2_filsys fs, ext2fs_generic_bitmap64 bmap);
 	void	(*free_bmap)(ext2fs_generic_bitmap64 bitmap);
 	errcode_t (*copy_bmap)(ext2fs_generic_bitmap64 src,
-			     ext2fs_generic_bitmap64 *dest);
+			     ext2fs_generic_bitmap64 dest);
 	errcode_t (*resize_bmap)(ext2fs_generic_bitmap64 bitmap,
 			       __u64 new_end,
 			       __u64 new_real_end);
@@ -130,13 +128,14 @@ struct ext2_bitmap_ops {
 	int	(*unmark_bmap)(ext2fs_generic_bitmap64 bitmap, __u64 arg);
 	int	(*test_bmap)(ext2fs_generic_bitmap64 bitmap, __u64 arg);
 	void	(*mark_bmap_extent)(ext2fs_generic_bitmap64 bitmap, __u64 arg,
-				  int num);
+				    size_t num);
 	void	(*unmark_bmap_extent)(ext2fs_generic_bitmap64 bitmap, __u64 arg,
-				    int num);
+				    size_t num);
 	errcode_t (*set_bmap_range)(ext2fs_generic_bitmap64 bitmap,
-				    __u64 start, unsigned int num, void *in);
+				    __u64 start, size_t num, void *in);
 	errcode_t (*get_bmap_range)(ext2fs_generic_bitmap64 bitmap,
-				    __u64 start, unsigned int num, void *out);
+				    __u64 start, size_t num, void *out);
+	void (*clear_bmap)(ext2fs_generic_bitmap64 bitmap);
 };
 
 extern struct ext2_bitmap_ops ext2fs_blkmap64_bitarray;
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 75af6de..f2c0119 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -99,6 +99,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	if (retval)
 		return retval;
 
+	/* XXX factor out, repeated in copy_bmap */
 	bitmap->magic = magic;
 	bitmap->fs = fs;
 	bitmap->start = start;
@@ -125,7 +126,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	} else
 		bitmap->description = 0;
 
-	retval = bitmap->bitmap_ops->new_bmap(fs, &bitmap);
+	retval = bitmap->bitmap_ops->new_bmap(fs, bitmap);
 	if (retval) {
 		ext2fs_free_mem(&bitmap);
 		ext2fs_free_mem(&bitmap->description);
@@ -162,37 +163,53 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap64 src,
 					  ext2fs_generic_bitmap64 *dest)
 {
 	char *descr, *new_descr;
+	ext2fs_generic_bitmap64	new_bmap;
 	errcode_t retval;
 
 	if (!src)
-		return;
+		return EINVAL;
 
-	if (EXT2FS_IS_32_BITMAP(src)) {
-		ext2fs_copy_generic_bitmap((ext2fs_generic_bitmap) src,
-					   (ext2fs_generic_bitmap *) dest);
-		return;
-	}
+	if (EXT2FS_IS_32_BITMAP(src))
+		return ext2fs_copy_generic_bitmap((ext2fs_generic_bitmap) src,
+						  (ext2fs_generic_bitmap *) dest);
 
 	if (!EXT2FS_IS_64_BITMAP(src))
-		return;
+		return EINVAL;
+
+	/* Allocate a new bitmap struct */
+	retval = ext2fs_get_mem(sizeof(struct ext2fs_struct_generic_bitmap64),
+				&new_bmap);
+	if (retval)
+		return retval;
+
+	/* Copy all the high-level parts over */
+	new_bmap->magic = src->magic;
+	new_bmap->fs = src->fs;
+	new_bmap->start = src->start;
+	new_bmap->end = src->end;
+	new_bmap->real_end = src->real_end;
+	new_bmap->bitmap_ops = src->bitmap_ops;
+	new_bmap->base_error_code = src->base_error_code;
 
 	descr = src->description;
 	if (descr) {
 		retval = ext2fs_get_mem(strlen(descr)+1, &new_descr);
 		if (retval) {
-			new_descr = 0;
+			ext2fs_free_mem(&new_bmap);
 			return retval;
 		}
 		strcpy(new_descr, descr);
+		new_bmap->description = new_descr;
 	}
 
-	retval = src->bitmap_ops->copy_bmap(src, dest);
+	retval = src->bitmap_ops->copy_bmap(src, new_bmap);
 	if (retval) {
-		ext2fs_free_mem(&new_descr);
+		ext2fs_free_mem(&new_bmap->description);
+		ext2fs_free_mem(&new_bmap);
 		return retval;
 	}
 
-	(*dest)->description = new_descr;
+	*dest = new_bmap;
 
 	return 0;
 }
@@ -201,24 +218,95 @@ errcode_t ext2fs_resize_generic_bmap(ext2fs_generic_bitmap64 bmap,
 				     __u64 new_end,
 				     __u64 new_real_end)
 {
-	errcode_t retval;
-
 	if (!bmap)
-		return;
+		return EINVAL;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		ext2fs_resize_generic_bitmap(bmap->magic,
-					     new_end, new_real_end,
-					     (ext2fs_generic_bitmap) bmap);
-		return;
+		return ext2fs_resize_generic_bitmap(bmap->magic,
+						    new_end, new_real_end,
+						    (ext2fs_generic_bitmap) bmap);
 	}
 
 	if (!EXT2FS_IS_64_BITMAP(bmap))
-		return;
+		return EINVAL;
 
 	return bmap->bitmap_ops->resize_bmap(bmap, new_end, new_real_end);
 }
 
+errcode_t ext2fs_fudge_generic_bmap_end(ext2fs_generic_bitmap64 bitmap,
+					errcode_t neq,
+					__u64 end, __u64 *oend)
+{
+	if (!bitmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bitmap)) {
+		ext2_ino_t tmp_oend;
+		int retval;
+
+		retval = ext2fs_fudge_generic_bitmap_end((ext2fs_generic_bitmap) bitmap,
+							 bitmap->magic, neq,
+							 end, &tmp_oend);
+		if (oend)
+			*oend = tmp_oend;
+		return retval;
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bitmap))
+		return EINVAL;
+
+	if (end > bitmap->real_end)
+		return neq;
+	if (oend)
+		*oend = bitmap->end;
+	bitmap->end = end;
+	return 0;
+}
+
+__u64 ext2fs_get_generic_bmap_start(ext2fs_generic_bitmap64 bitmap)
+{
+	if (!bitmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bitmap)) {
+		return ext2fs_get_generic_bitmap_start((ext2fs_generic_bitmap)
+						       bitmap);
+
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bitmap))
+		return EINVAL;
+
+	return bitmap->start;
+}
+
+__u64 ext2fs_get_generic_bmap_end(ext2fs_generic_bitmap64 bitmap)
+{
+	if (!bitmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bitmap)) {
+		return ext2fs_get_generic_bitmap_end((ext2fs_generic_bitmap)
+						       bitmap);
+
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bitmap))
+		return EINVAL;
+
+	return bitmap->end;
+}
+
+void ext2fs_clear_generic_bmap(ext2fs_generic_bitmap64 bitmap)
+{
+	if (EXT2FS_IS_32_BITMAP(bitmap)) {
+		ext2fs_clear_generic_bitmap((ext2fs_generic_bitmap) bitmap);
+		return;
+	}
+
+	bitmap->bitmap_ops->clear_bmap (bitmap);
+}
+
 int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap64 bitmap,
 			     __u64 arg)
 {
@@ -226,7 +314,7 @@ int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap64 bitmap,
 		return 0;
 
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
-		if (arg & ~0xffffffff) {
+		if (arg & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bitmap,
 					    EXT2FS_MARK_ERROR, 0xffffffff);
 			return 0;
@@ -253,7 +341,7 @@ int ext2fs_unmark_generic_bmap(ext2fs_generic_bitmap64 bitmap,
 		return 0;
 
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
-		if (arg & ~0xffffffff) {
+		if (arg & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bitmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return 0;
@@ -280,7 +368,7 @@ int ext2fs_test_generic_bmap(ext2fs_generic_bitmap64 bitmap,
 		return 0;
 
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
-		if (arg & ~0xffffffff) {
+		if (arg & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bitmap,
 					    EXT2FS_TEST_ERROR, 0xffffffff);
 			return 0;
@@ -300,25 +388,28 @@ int ext2fs_test_generic_bmap(ext2fs_generic_bitmap64 bitmap,
 	return bitmap->bitmap_ops->test_bmap(bitmap, arg);
 }
 
+/*
+ * XXX mark/unmark extents are new functions, do we need to make them
+ * handle old-style bitmaps?
+ */
+
 void ext2fs_mark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 				     __u64 arg, int num)
 {
-	errcode_t retval;
-	__u32 i;
-	int c;
+	int i;
 
 	if (!bmap)
 		return;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		if ((arg+num) & ~0xffffffff) {
+		if ((arg+num) & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
 					    EXT2FS_MARK_ERROR, 0xffffffff);
 			return;
 		}
-		for (i = arg, c = num; c > 0; c--)
+		for (i = 0; i < num; i++)
 			ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap)
-						   bmap, i);
+						   bmap, arg + i);
 		return;
 	}
 
@@ -331,22 +422,20 @@ void ext2fs_mark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 void ext2fs_unmark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 				      __u64 arg, int num)
 {
-	errcode_t retval;
 	__u32 i;
-	int c;
 
 	if (!bmap)
 		return;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		if ((arg+num) & ~0xffffffff) {
+		if ((arg+num) & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return;
 		}
-		for (i = arg, c = num; c > 0; c--)
+		for (i = 0; i < num; i++)
 			ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap)
-						     bmap, i);
+						     bmap, arg + i);
 		return;
 	}
 
@@ -356,14 +445,186 @@ void ext2fs_unmark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 	bmap->bitmap_ops->unmark_bmap_extent(bmap, arg, num);
 }
 
-errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap64 bitmap,
+errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap64 bmap,
 					__u64 start, unsigned int num,
 					void *in)
 {
+	if (!bmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		if ((start+num) & ~0xffffffffULL) {
+			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+					    EXT2FS_UNMARK_ERROR, 0xffffffff);
+			return EINVAL;
+		}
+		return ext2fs_set_generic_bitmap_range((ext2fs_generic_bitmap) bmap,
+						       bmap->magic, start, num,
+						       in);
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return EINVAL;
+
+	return bmap->bitmap_ops->set_bmap_range(bmap, start, num, in);
 }
 
-errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap64 bitmap,
+errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap64 bmap,
 					__u64 start, unsigned int num,
 					void *out)
 {
+	if (!bmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		if ((start+num) & ~0xffffffffULL) {
+			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+					    EXT2FS_UNMARK_ERROR, 0xffffffff);
+			return EINVAL;
+		}
+		return ext2fs_get_generic_bitmap_range((ext2fs_generic_bitmap) bmap,
+						       bmap->magic, start, num,
+						       out);
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return EINVAL;
+
+	return bmap->bitmap_ops->get_bmap_range(bmap, start, num, out);
+}
+
+errcode_t ext2fs_compare_generic_bmap(errcode_t neq,
+				      ext2fs_generic_bitmap64 bm1,
+				      ext2fs_generic_bitmap64 bm2)
+{
+	blk64_t	i;
+
+	if (!bm1 || !bm2)
+		return EINVAL;
+	if (bm1->magic != bm2->magic)
+		return EINVAL;
+
+	/* Now we know both bitmaps have the same magic */
+	if (EXT2FS_IS_32_BITMAP(bm1))
+		return ext2fs_compare_generic_bitmap(bm1->magic, neq,
+					     (ext2fs_generic_bitmap) bm1,
+					     (ext2fs_generic_bitmap) bm2);
+
+	if (!EXT2FS_IS_64_BITMAP(bm1))
+		return EINVAL;
+
+	if ((bm1->start != bm2->start) ||
+	    (bm1->end != bm2->end))
+		return neq;
+
+	for (i = bm1->end - ((bm1->end - bm1->start) % 8); i <= bm1->end; i++)
+		if (ext2fs_test_generic_bmap(bm1, i) !=
+		    ext2fs_test_generic_bmap(bm2, i))
+			return neq;
+
+	return 0;
+}
+
+void ext2fs_set_generic_bmap_padding(ext2fs_generic_bitmap64 bmap)
+{
+	__u64	start, num;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		ext2fs_set_generic_bitmap_padding((ext2fs_generic_bitmap) bmap);
+		return;
+	}
+
+	start = bmap->end + 1;
+	num = bmap->real_end - bmap->end;
+	bmap->bitmap_ops->mark_bmap_extent(bmap, start, num);
+	/* XXX ought to warn on error */
+}
+
+int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
+				    blk64_t block, int num)
+{
+	int	i;
+
+	if (!bmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		if ((block+num) & ~0xffffffffULL) {
+			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+					    EXT2FS_UNMARK_ERROR, 0xffffffff);
+			return EINVAL;
+		}
+		return ext2fs_test_block_bitmap_range((ext2fs_generic_bitmap) bmap,
+						      block, num);
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return EINVAL;
+
+	if ((block < bmap->start) || (block+num-1 > bmap->real_end)) {
+		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_TEST,
+				   block, bmap->description);
+		return 0;
+	}
+	for (i=0; i < num; i++) {
+		if (ext2fs_fast_test_block_bitmap2(bmap, block+i))
+			return 0;
+	}
+	return 1;
+}
+
+void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
+				     blk64_t block, int num)
+{
+	if (!bmap)
+		return;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		if ((block+num) & ~0xffffffffULL) {
+			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+					    EXT2FS_UNMARK_ERROR, 0xffffffff);
+			return;
+		}
+		ext2fs_mark_block_bitmap_range((ext2fs_generic_bitmap) bmap,
+					       block, num);
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return;
+
+	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
+		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_MARK, block,
+				   bmap->description);
+		return;
+	}
+
+	bmap->bitmap_ops->mark_bmap_extent(bmap, block, num);
+}
+
+void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
+				       blk64_t block, int num)
+{
+	if (!bmap)
+		return;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		if ((block+num) & ~0xffffffffULL) {
+			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+					    EXT2FS_UNMARK_ERROR, 0xffffffff);
+			return;
+		}
+		ext2fs_unmark_block_bitmap_range((ext2fs_generic_bitmap) bmap,
+						 block, num);
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return;
+
+	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
+		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_UNMARK, block,
+				   bmap->description);
+		return;
+	}
+
+	bmap->bitmap_ops->unmark_bmap_extent(bmap, block, num);
 }
-- 
1.5.6.5

