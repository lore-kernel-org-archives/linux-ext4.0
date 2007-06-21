From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 3/11][take 2] new badblocks interface in e2fsprogs
Date: Thu, 21 Jun 2007 17:17:47 +0200
Message-ID: <467A969B.3010000@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060704090007040700090601"
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37078 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496AbXFUPzf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:55:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------060704090007040700090601
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch introduces new badblocks list functions for ext4 filesystems 
which use the new type blk64_t.

  badblocks.c |  471 
+++++++++++++++++++++++++++++++++++++++++++++++++-----------
  ext2fs.h    |   28 ++-
  ext2fsP.h   |   13 +
  freefs.c    |   19 --
  4 files changed, 423 insertions(+), 108 deletions(-)



--------------060704090007040700090601
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="03-new-badblock-interface-to-handle-blk64_t-blocks"
Content-Disposition: inline;
 filename="03-new-badblock-interface-to-handle-blk64_t-blocks"

Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fsP.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2fsP.h	2007-06-18 19:25:54.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fsP.h	2007-06-18 19:26:46.000000000 +0200
@@ -28,6 +28,19 @@ struct ext2_struct_u32_iterate {
 	int			ptr;
 };
 
+struct ext2_struct_blk64_list {
+	int	magic;
+	int	num;
+	int	size;
+	int	badblocks_flags;
+	blk64_t	*list;
+};
+
+struct ext2_struct_blk64_iterate {
+	int			magic;
+	ext2_badblocks_list	bb;
+	int			ptr;
+};
 
 /*
  * Directory block iterator definition
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2fs.h	2007-06-18 19:25:54.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h	2007-06-18 19:26:46.000000000 +0200
@@ -127,15 +127,25 @@ typedef struct ext2fs_struct_generic_bit
  * Badblocks list definitions
  */
 
-typedef struct ext2_struct_u32_list *ext2_badblocks_list;
-typedef struct ext2_struct_u32_iterate *ext2_badblocks_iterate;
-
 typedef struct ext2_struct_u32_list *ext2_u32_list;
 typedef struct ext2_struct_u32_iterate *ext2_u32_iterate;
 
-/* old */
+#ifdef _EXT4FS_
+typedef struct ext2_struct_blk64_list *ext2_blk64_list;
+typedef struct ext2_struct_blk64_iterate *ext2_blk64_iterate;
+
+typedef struct ext2_struct_blk64_list *ext2_badblocks_list;
+typedef struct ext2_struct_blk64_iterate *ext2_badblocks_iterate;
+
+typedef struct ext2_struct_blk64_list *badblocks_list;
+typedef struct ext2_struct_blk64_iterate *badblocks_iterate;
+#else
+typedef struct ext2_struct_u32_list *ext2_badblocks_list;
+typedef struct ext2_struct_u32_iterate *ext2_badblocks_iterate;
+
 typedef struct ext2_struct_u32_list *badblocks_list;
 typedef struct ext2_struct_u32_iterate *badblocks_iterate;
+#endif
 
 #define BADBLOCKS_FLAG_DIRTY	1
 
@@ -521,10 +531,10 @@ extern errcode_t ext2fs_allocate_group_t
 extern errcode_t ext2fs_u32_list_create(ext2_u32_list *ret, int size);
 extern errcode_t ext2fs_u32_list_add(ext2_u32_list bb, __u32 blk);
 extern int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk);
-extern int ext2fs_u32_list_test(ext2_u32_list bb, blk_t blk);
+extern int ext2fs_u32_list_test(ext2_u32_list bb, __u32 blk);
 extern errcode_t ext2fs_u32_list_iterate_begin(ext2_u32_list bb,
 					       ext2_u32_iterate *ret);
-extern int ext2fs_u32_list_iterate(ext2_u32_iterate iter, blk_t *blk);
+extern int ext2fs_u32_list_iterate(ext2_u32_iterate iter, __u32 *blk);
 extern void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter);
 extern errcode_t ext2fs_u32_copy(ext2_u32_list src, ext2_u32_list *dest);
 extern int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2);
@@ -536,7 +546,7 @@ extern errcode_t ext2fs_badblocks_list_a
 extern int ext2fs_badblocks_list_test(ext2_badblocks_list bb,
 				    blk_t blk);
 extern int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk);
-extern void ext2fs_badblocks_list_del(ext2_u32_list bb, __u32 blk);
+extern void ext2fs_badblocks_list_del(ext2_badblocks_list bb, blk_t blk);
 extern errcode_t
 	ext2fs_badblocks_list_iterate_begin(ext2_badblocks_list bb,
 					    ext2_badblocks_iterate *ret);
@@ -548,6 +558,8 @@ extern errcode_t ext2fs_badblocks_copy(e
 extern int ext2fs_badblocks_equal(ext2_badblocks_list bb1,
 				  ext2_badblocks_list bb2);
 extern int ext2fs_u32_list_count(ext2_u32_list bb);
+extern void ext2fs_badblocks_list_free(ext2_badblocks_list bb);
+extern void ext2fs_u32_list_free(ext2_u32_list bb);
 
 /* bb_compat */
 extern errcode_t badblocks_list_create(badblocks_list *ret, int size);
@@ -814,8 +826,6 @@ extern void ext2fs_free_generic_bitmap(e
 extern void ext2fs_free_block_bitmap(ext2fs_block_bitmap bitmap);
 extern void ext2fs_free_inode_bitmap(ext2fs_inode_bitmap bitmap);
 extern void ext2fs_free_dblist(ext2_dblist dblist);
-extern void ext2fs_badblocks_list_free(ext2_badblocks_list bb);
-extern void ext2fs_u32_list_free(ext2_u32_list bb);
 
 /* getsize.c */
 extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/badblocks.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/badblocks.c	2007-06-18 19:25:54.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/badblocks.c	2007-06-18 19:26:46.000000000 +0200
@@ -42,15 +42,15 @@ static errcode_t make_u32_list(int size,
 	bb->magic = EXT2_ET_MAGIC_BADBLOCKS_LIST;
 	bb->size = size ? size : 10;
 	bb->num = num;
-	retval = ext2fs_get_mem(bb->size * sizeof(blk_t), &bb->list);
+	retval = ext2fs_get_mem(bb->size * sizeof(__u32), &bb->list);
 	if (retval) {
 		ext2fs_free_mem(&bb);
 		return retval;
 	}
 	if (list)
-		memcpy(bb->list, list, bb->size * sizeof(blk_t));
+		memcpy(bb->list, list, bb->size * sizeof(__u32));
 	else
-		memset(bb->list, 0, bb->size * sizeof(blk_t));
+		memset(bb->list, 0, bb->size * sizeof(__u32));
 	*ret = bb;
 	return 0;
 }
@@ -64,18 +64,6 @@ errcode_t ext2fs_u32_list_create(ext2_u3
 	return make_u32_list(size, 0, 0, ret);
 }
 
-/*
- * This procedure creates an empty badblocks list.
- */
-errcode_t ext2fs_badblocks_list_create(ext2_badblocks_list *ret, int size)
-{
-	return make_u32_list(size, 0, 0, (ext2_badblocks_list *) ret);
-}
-
-
-/*
- * This procedure copies a badblocks list
- */
 errcode_t ext2fs_u32_copy(ext2_u32_list src, ext2_u32_list *dest)
 {
 	errcode_t	retval;
@@ -87,23 +75,6 @@ errcode_t ext2fs_u32_copy(ext2_u32_list 
 	return 0;
 }
 
-errcode_t ext2fs_badblocks_copy(ext2_badblocks_list src,
-				ext2_badblocks_list *dest)
-{
-	return ext2fs_u32_copy((ext2_u32_list) src,
-			       (ext2_u32_list *) dest);
-}
-
-/*
- * This procedure frees a badblocks list.
- *
- * (note: moved to closefs.c)
- */
-
-
-/*
- * This procedure adds a block to a badblocks list.
- */
 errcode_t ext2fs_u32_list_add(ext2_u32_list bb, __u32 blk)
 {
 	errcode_t	retval;
@@ -150,15 +121,6 @@ errcode_t ext2fs_u32_list_add(ext2_u32_l
 	return 0;
 }
 
-errcode_t ext2fs_badblocks_list_add(ext2_badblocks_list bb, blk_t blk)
-{
-	return ext2fs_u32_list_add((ext2_u32_list) bb, (__u32) blk);
-}
-
-/*
- * This procedure finds a particular block is on a badblocks
- * list.
- */
 int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk)
 {
 	int	low, high, mid;
@@ -190,10 +152,6 @@ int ext2fs_u32_list_find(ext2_u32_list b
 	return -1;
 }
 
-/*
- * This procedure tests to see if a particular block is on a badblocks
- * list.
- */
 int ext2fs_u32_list_test(ext2_u32_list bb, __u32 blk)
 {
 	if (ext2fs_u32_list_find(bb, blk) < 0)
@@ -202,15 +160,6 @@ int ext2fs_u32_list_test(ext2_u32_list b
 		return 1;
 }
 
-int ext2fs_badblocks_list_test(ext2_badblocks_list bb, blk_t blk)
-{
-	return ext2fs_u32_list_test((ext2_u32_list) bb, (__u32) blk);
-}
-
-
-/*
- * Remove a block from the badblock list
- */
 int ext2fs_u32_list_del(ext2_u32_list bb, __u32 blk)
 {
 	int	remloc, i;
@@ -228,11 +177,6 @@ int ext2fs_u32_list_del(ext2_u32_list bb
 	return 0;
 }
 
-void ext2fs_badblocks_list_del(ext2_u32_list bb, __u32 blk)
-{
-	ext2fs_u32_list_del(bb, blk);
-}
-
 errcode_t ext2fs_u32_list_iterate_begin(ext2_u32_list bb,
 					ext2_u32_iterate *ret)
 {
@@ -252,14 +196,6 @@ errcode_t ext2fs_u32_list_iterate_begin(
 	return 0;
 }
 
-errcode_t ext2fs_badblocks_list_iterate_begin(ext2_badblocks_list bb,
-					      ext2_badblocks_iterate *ret)
-{
-	return ext2fs_u32_list_iterate_begin((ext2_u32_list) bb,
-					      (ext2_u32_iterate *) ret);
-}
-
-
 int ext2fs_u32_list_iterate(ext2_u32_iterate iter, __u32 *blk)
 {
 	ext2_u32_list	bb;
@@ -280,13 +216,6 @@ int ext2fs_u32_list_iterate(ext2_u32_ite
 	return 0;
 }
 
-int ext2fs_badblocks_list_iterate(ext2_badblocks_iterate iter, blk_t *blk)
-{
-	return ext2fs_u32_list_iterate((ext2_u32_iterate) iter,
-				       (__u32 *) blk);
-}
-
-
 void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter)
 {
 	if (!iter || (iter->magic != EXT2_ET_MAGIC_BADBLOCKS_ITERATE))
@@ -296,13 +225,311 @@ void ext2fs_u32_list_iterate_end(ext2_u3
 	ext2fs_free_mem(&iter);
 }
 
+int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2)
+{
+	EXT2_CHECK_MAGIC(bb1, EXT2_ET_MAGIC_BADBLOCKS_LIST);
+	EXT2_CHECK_MAGIC(bb2, EXT2_ET_MAGIC_BADBLOCKS_LIST);
+
+	if (bb1->num != bb2->num)
+		return 0;
+
+	if (memcmp(bb1->list, bb2->list, bb1->num * sizeof(__u32)) != 0)
+		return 0;
+	return 1;
+}
+
+int ext2fs_u32_list_count(ext2_u32_list bb)
+{
+	return bb->num;
+}
+
+void ext2fs_u32_list_free(ext2_u32_list bb)
+{
+	if (bb->magic != EXT2_ET_MAGIC_BADBLOCKS_LIST)
+		return;
+
+	if (bb->list)
+		ext2fs_free_mem(&bb->list);
+	bb->list = 0;
+	ext2fs_free_mem(&bb);
+}
+
+#ifndef _EXT4FS_
+/*
+ * This procedure creates an empty badblocks list.
+ */
+errcode_t ext2fs_badblocks_list_create(ext2_badblocks_list *ret, int size)
+{
+	return make_u32_list(size, 0, 0, (ext2_badblocks_list *) ret);
+}
+
+
+/*
+ * This procedure copies a badblocks list
+ */
+errcode_t ext2fs_badblocks_copy(ext2_badblocks_list src,
+				ext2_badblocks_list *dest)
+{
+	return ext2fs_u32_copy((ext2_u32_list) src,
+			       (ext2_u32_list *) dest);
+}
+
+/*
+ * This procedure adds a block to a badblocks list.
+ */
+errcode_t ext2fs_badblocks_list_add(ext2_badblocks_list bb, blk_t blk)
+{
+	return ext2fs_u32_list_add((ext2_u32_list) bb, (__u32) blk);
+}
+
+/*
+ * This procedure tests to see if a particular block is on a badblocks
+ * list.
+ */
+int ext2fs_badblocks_list_test(ext2_badblocks_list bb, blk_t blk)
+{
+	return ext2fs_u32_list_test((ext2_u32_list) bb, (__u32) blk);
+}
+
+/*
+ * Remove a block from the badblock list
+ */
+void ext2fs_badblocks_list_del(ext2_badblocks_list bb, blk_t blk)
+{
+	ext2fs_u32_list_del(bb, blk);
+}
+
+errcode_t ext2fs_badblocks_list_iterate_begin(ext2_badblocks_list bb,
+					      ext2_badblocks_iterate *ret)
+{
+	return ext2fs_u32_list_iterate_begin((ext2_u32_list) bb,
+					      (ext2_u32_iterate *) ret);
+}
+
+int ext2fs_badblocks_list_iterate(ext2_badblocks_iterate iter, blk_t *blk)
+{
+	return ext2fs_u32_list_iterate((ext2_u32_iterate) iter,
+				       (__u32 *) blk);
+}
+
 void ext2fs_badblocks_list_iterate_end(ext2_badblocks_iterate iter)
 {
 	ext2fs_u32_list_iterate_end((ext2_u32_iterate) iter);
 }
 
 
-int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2)
+int ext2fs_badblocks_equal(ext2_badblocks_list bb1, ext2_badblocks_list bb2)
+{
+	return ext2fs_u32_list_equal((ext2_u32_list) bb1,
+				     (ext2_u32_list) bb2);
+}
+
+/*
+ * This procedure frees a badblocks list.
+ */
+void ext2fs_badblocks_list_free(ext2_badblocks_list bb)
+{
+	ext2fs_u32_list_free((ext2_u32_list) bb);
+}
+
+#else
+static errcode_t make_blk_list(int size, int num, blk64_t *list,
+			       ext2_blk64_list *ret)
+{
+	ext2_blk64_list	bb;
+	errcode_t	retval;
+	
+	retval = ext2fs_get_mem(sizeof(struct ext2_struct_blk64_list), &bb);
+	if (retval)
+		return retval;
+	memset(bb, 0, sizeof(struct ext2_struct_blk64_list));
+	bb->magic = EXT2_ET_MAGIC_BADBLOCKS_LIST;
+	bb->size = size ? size : 10;
+	bb->num = num;
+	retval = ext2fs_get_mem(bb->size * sizeof(blk64_t), &bb->list);
+	if (retval) {
+		ext2fs_free_mem(&bb);
+		return retval;
+	}
+	if (list)
+		memcpy(bb->list, list, bb->size * sizeof(blk64_t));
+	else
+		memset(bb->list, 0, bb->size * sizeof(blk64_t));
+	*ret = bb;
+	return 0;
+}
+	
+
+/*
+ * This procedure creates an empty blk list.
+ */
+errcode_t ext2fs_blk_list_create(ext2_blk64_list *ret, int size)
+{
+	return make_blk_list(size, 0, 0, ret);
+}
+
+errcode_t ext2fs_blk_copy(ext2_blk64_list src, ext2_blk64_list *dest)
+{
+	errcode_t	retval;
+	
+	retval = make_blk_list(src->size, src->num, src->list, dest);
+	if (retval)
+		return retval;
+	(*dest)->badblocks_flags = src->badblocks_flags;
+	return 0;
+}
+
+errcode_t ext2fs_blk_list_add(ext2_blk64_list bb, blk64_t blk)
+{
+	errcode_t	retval;
+	int		i, j;
+	unsigned long	old_size;
+
+	EXT2_CHECK_MAGIC(bb, EXT2_ET_MAGIC_BADBLOCKS_LIST);
+
+	if (bb->num >= bb->size) {
+		old_size = bb->size * sizeof(blk64_t);
+		bb->size += 100;
+		retval = ext2fs_resize_mem(old_size, bb->size * sizeof(blk64_t),
+					   &bb->list);
+		if (retval) {
+			bb->size -= 100;
+			return retval;
+		}
+	}
+
+	/*
+	 * Add special case code for appending to the end of the list
+	 */
+	i = bb->num-1;
+	if ((bb->num != 0) && (bb->list[i] == blk))
+		return 0;
+	if ((bb->num == 0) || (bb->list[i] < blk)) {
+		bb->list[bb->num++] = blk;
+		return 0;
+	}
+
+	j = bb->num;
+	for (i=0; i < bb->num; i++) {
+		if (bb->list[i] == blk)
+			return 0;
+		if (bb->list[i] > blk) {
+			j = i;
+			break;
+		}
+	}
+	for (i=bb->num; i > j; i--)
+		bb->list[i] = bb->list[i-1];
+	bb->list[j] = blk;
+	bb->num++;
+	return 0;
+}
+
+int ext2fs_blk_list_find(ext2_blk64_list bb, blk64_t blk)
+{
+	int	low, high, mid;
+
+	if (bb->magic != EXT2_ET_MAGIC_BADBLOCKS_LIST)
+		return -1;
+
+	if (bb->num == 0)
+		return -1;
+
+	low = 0;
+	high = bb->num-1;
+	if (blk == bb->list[low])
+		return low;
+	if (blk == bb->list[high])
+		return high;
+
+	while (low < high) {
+		mid = (low+high)/2;
+		if (mid == low || mid == high)
+			break;
+		if (blk == bb->list[mid])
+			return mid;
+		if (blk < bb->list[mid])
+			high = mid;
+		else
+			low = mid;
+	}
+	return -1;
+}
+
+int ext2fs_blk_list_test(ext2_blk64_list bb, blk64_t blk)
+{
+	if (ext2fs_blk_list_find(bb, blk) < 0)
+		return 0;
+	else
+		return 1;
+}
+
+int ext2fs_blk_list_del(ext2_blk64_list bb, blk64_t blk)
+{
+	int	remloc, i;
+
+	if (bb->num == 0)
+		return -1;
+
+	remloc = ext2fs_blk_list_find(bb, blk);
+	if (remloc < 0)
+		return -1;
+
+	for (i = remloc ; i < bb->num-1; i++)
+		bb->list[i] = bb->list[i+1];
+	bb->num--;
+	return 0;
+}
+
+errcode_t ext2fs_blk_list_iterate_begin(ext2_blk64_list bb,
+					ext2_blk64_iterate *ret)
+{
+	ext2_blk64_iterate iter;
+	errcode_t		retval;
+
+	EXT2_CHECK_MAGIC(bb, EXT2_ET_MAGIC_BADBLOCKS_LIST);
+
+	retval = ext2fs_get_mem(sizeof(struct ext2_struct_blk64_iterate), &iter);
+	if (retval)
+		return retval;
+
+	iter->magic = EXT2_ET_MAGIC_BADBLOCKS_ITERATE;
+	iter->bb = bb;
+	iter->ptr = 0;
+	*ret = iter;
+	return 0;
+}
+
+int ext2fs_blk_list_iterate(ext2_blk64_iterate iter, blk64_t *blk)
+{
+	ext2_blk64_list	bb;
+
+	if (iter->magic != EXT2_ET_MAGIC_BADBLOCKS_ITERATE)
+		return 0;
+
+	bb = iter->bb;
+
+	if (bb->magic != EXT2_ET_MAGIC_BADBLOCKS_LIST)
+		return 0;
+	
+	if (iter->ptr < bb->num) {
+		*blk = bb->list[iter->ptr++];
+		return 1;
+	} 
+	*blk = 0;
+	return 0;
+}
+
+void ext2fs_blk_list_iterate_end(ext2_blk64_iterate iter)
+{
+	if (!iter || (iter->magic != EXT2_ET_MAGIC_BADBLOCKS_ITERATE))
+		return;
+
+	iter->bb = 0;
+	ext2fs_free_mem(&iter);
+}
+
+int ext2fs_blk_list_equal(ext2_blk64_list bb1, ext2_blk64_list bb2)
 {
 	EXT2_CHECK_MAGIC(bb1, EXT2_ET_MAGIC_BADBLOCKS_LIST);
 	EXT2_CHECK_MAGIC(bb2, EXT2_ET_MAGIC_BADBLOCKS_LIST);
@@ -310,18 +537,102 @@ int ext2fs_u32_list_equal(ext2_u32_list 
 	if (bb1->num != bb2->num)
 		return 0;
 
-	if (memcmp(bb1->list, bb2->list, bb1->num * sizeof(blk_t)) != 0)
+	if (memcmp(bb1->list, bb2->list, bb1->num * sizeof(blk64_t)) != 0)
 		return 0;
 	return 1;
 }
 
+int ext2fs_blk_list_count(ext2_blk64_list bb)
+{
+	return bb->num;
+}
+
+void ext2fs_blk_list_free(ext2_blk64_list bb)
+{
+	if (bb->magic != EXT2_ET_MAGIC_BADBLOCKS_LIST)
+		return;
+
+	if (bb->list)
+		ext2fs_free_mem(&bb->list);
+	bb->list = 0;
+	ext2fs_free_mem(&bb);
+}
+
+/*
+ * This procedure creates an empty badblocks list.
+ */
+errcode_t ext2fs_badblocks_list_create(ext2_badblocks_list *ret, int size)
+{
+	return make_blk_list(size, 0, 0, (ext2_badblocks_list *) ret);
+}
+
+
+/*
+ * This procedure copies a badblocks list
+ */
+errcode_t ext2fs_badblocks_copy(ext2_badblocks_list src,
+				ext2_badblocks_list *dest)
+{
+	return ext2fs_blk_copy((ext2_blk64_list) src,
+			       (ext2_blk64_list *) dest);
+}
+
+/*
+ * This procedure adds a block to a badblocks list.
+ */
+errcode_t ext2fs_badblocks_list_add(ext2_badblocks_list bb, blk_t blk)
+{
+	return ext2fs_blk_list_add((ext2_blk64_list) bb, (blk64_t) blk);
+}
+
+/*
+ * This procedure tests to see if a particular block is on a badblocks
+ * list.
+ */
+int ext2fs_badblocks_list_test(ext2_badblocks_list bb, blk_t blk)
+{
+	return ext2fs_blk_list_test((ext2_blk64_list) bb, (blk64_t) blk);
+}
+
+/*
+ * Remove a block from the badblock list
+ */
+void ext2fs_badblocks_list_del(ext2_badblocks_list bb, blk_t blk)
+{
+	ext2fs_blk_list_del(bb, blk);
+}
+
+errcode_t ext2fs_badblocks_list_iterate_begin(ext2_badblocks_list bb,
+					      ext2_badblocks_iterate *ret)
+{
+	return ext2fs_blk_list_iterate_begin((ext2_blk64_list) bb,
+					      (ext2_blk64_iterate *) ret);
+}
+
+int ext2fs_badblocks_list_iterate(ext2_badblocks_iterate iter, blk_t *blk)
+{
+	return ext2fs_blk_list_iterate((ext2_blk64_iterate) iter,
+				       (blk64_t *) blk);
+}
+
+void ext2fs_badblocks_list_iterate_end(ext2_badblocks_iterate iter)
+{
+	ext2fs_blk_list_iterate_end((ext2_blk64_iterate) iter);
+}
+
+
 int ext2fs_badblocks_equal(ext2_badblocks_list bb1, ext2_badblocks_list bb2)
 {
-	return ext2fs_u32_list_equal((ext2_u32_list) bb1,
-				     (ext2_u32_list) bb2);
+	return ext2fs_blk_list_equal((ext2_blk64_list) bb1,
+				     (ext2_blk64_list) bb2);
 }
 
-int ext2fs_u32_list_count(ext2_u32_list bb)
+/*
+ * This procedure frees a badblocks list.
+ */
+void ext2fs_badblocks_list_free(ext2_badblocks_list bb)
 {
-	return bb->num;
+	ext2fs_blk_list_free((ext2_blk64_list) bb);
 }
+
+#endif /* _EXT4FS_ */
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/freefs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/freefs.c	2007-06-18 19:25:54.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/freefs.c	2007-06-18 19:26:46.000000000 +0200
@@ -108,25 +108,6 @@ static void ext2fs_free_inode_cache(stru
 	ext2fs_free_mem(&icache);
 }
 
-/*
- * This procedure frees a badblocks list.
- */
-void ext2fs_u32_list_free(ext2_u32_list bb)
-{
-	if (bb->magic != EXT2_ET_MAGIC_BADBLOCKS_LIST)
-		return;
-
-	if (bb->list)
-		ext2fs_free_mem(&bb->list);
-	bb->list = 0;
-	ext2fs_free_mem(&bb);
-}
-
-void ext2fs_badblocks_list_free(ext2_badblocks_list bb)
-{
-	ext2fs_u32_list_free((ext2_u32_list) bb);
-}
-
 
 /*
  * Free a directory block list

--------------060704090007040700090601--
