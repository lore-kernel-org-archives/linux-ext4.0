From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] libext2fs: add ext2fs_find_first_set_{block,inode}_bitmap2()
Date: Sun, 12 Jan 2014 21:48:09 -0500
Message-ID: <1389581293-17955-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47845 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaAMCsY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Jan 2014 21:48:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add functions which try to find the first set block or inode in a
bitmap.  This is useful when trying to allocate a range of blocks
efficiently.

Like the find_first_zero family of functions, provide a generic O(N)
search function which will be used if there is no optimized version
provided by the red-black tree or bitarray functions.

Also, expand the test cases for ext2fs_find_first_zero_*() functions.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/bitops.h           | 41 ++++++++++++++++++
 lib/ext2fs/bmap64.h           |  4 ++
 lib/ext2fs/ext2fs.h           |  3 ++
 lib/ext2fs/gen_bitmap.c       | 22 ++++++++++
 lib/ext2fs/gen_bitmap64.c     | 52 +++++++++++++++++++++++
 lib/ext2fs/tst_bitmaps.c      | 65 ++++++++++++++++++++++++++++
 lib/ext2fs/tst_bitmaps_cmd.ct |  6 +++
 lib/ext2fs/tst_bitmaps_cmds   | 49 ++++++++++++++++++++++
 lib/ext2fs/tst_bitmaps_exp    | 98 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 340 insertions(+)

diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 3e8132d..4fb7dc6 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -157,6 +157,14 @@ extern errcode_t ext2fs_find_first_zero_inode_bitmap2(ext2fs_inode_bitmap bitmap
 						      ext2_ino_t start,
 						      ext2_ino_t end,
 						      ext2_ino_t *out);
+extern errcode_t ext2fs_find_first_set_block_bitmap2(ext2fs_block_bitmap bitmap,
+						     blk64_t start,
+						     blk64_t end,
+						     blk64_t *out);
+extern errcode_t ext2fs_find_first_set_inode_bitmap2(ext2fs_inode_bitmap bitmap,
+						      ext2_ino_t start,
+						      ext2_ino_t end,
+						      ext2_ino_t *out);
 extern blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap bitmap);
 extern ext2_ino_t ext2fs_get_inode_bitmap_start2(ext2fs_inode_bitmap bitmap);
 extern blk64_t ext2fs_get_block_bitmap_end2(ext2fs_block_bitmap bitmap);
@@ -198,6 +206,9 @@ extern void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bitmap,
 extern errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 						     __u64 start, __u64 end,
 						     __u64 *out);
+extern errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
+						    __u64 start, __u64 end,
+						    __u64 *out);
 
 /*
  * The inline routines themselves...
@@ -604,6 +615,36 @@ _INLINE_ errcode_t ext2fs_find_first_zero_inode_bitmap2(ext2fs_inode_bitmap bitm
 	return rv;
 }
 
+_INLINE_ errcode_t ext2fs_find_first_set_block_bitmap2(ext2fs_block_bitmap bitmap,
+						       blk64_t start,
+						       blk64_t end,
+						       blk64_t *out)
+{
+	__u64 o;
+	errcode_t rv;
+
+	rv = ext2fs_find_first_set_generic_bmap((ext2fs_generic_bitmap) bitmap,
+						start, end, &o);
+	if (!rv)
+		*out = o;
+	return rv;
+}
+
+_INLINE_ errcode_t ext2fs_find_first_set_inode_bitmap2(ext2fs_inode_bitmap bitmap,
+						       ext2_ino_t start,
+						       ext2_ino_t end,
+						       ext2_ino_t *out)
+{
+	__u64 o;
+	errcode_t rv;
+
+	rv = ext2fs_find_first_set_generic_bmap((ext2fs_generic_bitmap) bitmap,
+						start, end, &o);
+	if (!rv)
+		*out = (ext2_ino_t) o;
+	return rv;
+}
+
 _INLINE_ blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap bitmap)
 {
 	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap) bitmap);
diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
index f44d379..9deba46 100644
--- a/lib/ext2fs/bmap64.h
+++ b/lib/ext2fs/bmap64.h
@@ -94,6 +94,10 @@ struct ext2_bitmap_ops {
 	 * May be NULL, in which case a generic function is used. */
 	errcode_t (*find_first_zero)(ext2fs_generic_bitmap bitmap,
 				     __u64 start, __u64 end, __u64 *out);
+	/* Find the first set bit between start and end, inclusive.
+	 * May be NULL, in which case a generic function is used. */
+	errcode_t (*find_first_set)(ext2fs_generic_bitmap bitmap,
+				    __u64 start, __u64 end, __u64 *out);
 };
 
 extern struct ext2_bitmap_ops ext2fs_blkmap64_bitarray;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 8ff5a7e..e4d6c1a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1178,6 +1178,9 @@ extern errcode_t ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 extern errcode_t ext2fs_find_first_zero_generic_bitmap(ext2fs_generic_bitmap bitmap,
 						       __u32 start, __u32 end,
 						       __u32 *out);
+extern errcode_t ext2fs_find_first_set_generic_bitmap(ext2fs_generic_bitmap bitmap,
+						       __u32 start, __u32 end,
+						       __u32 *out);
 
 /* gen_bitmap64.c */
 
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index 0bff854..6cd6fe6 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -527,6 +527,28 @@ errcode_t ext2fs_find_first_zero_generic_bitmap(ext2fs_generic_bitmap bitmap,
 	return ENOENT;
 }
 
+errcode_t ext2fs_find_first_set_generic_bitmap(ext2fs_generic_bitmap bitmap,
+					       __u32 start, __u32 end,
+					       __u32 *out)
+{
+	blk_t b;
+
+	if (start < bitmap->start || end > bitmap->end || start > end) {
+		ext2fs_warn_bitmap2(bitmap, EXT2FS_TEST_ERROR, start);
+		return EINVAL;
+	}
+
+	while (start <= end) {
+		b = ext2fs_test_bit(start - bitmap->start, bitmap->bitmap);
+		if (b) {
+			*out = start;
+			return 0;
+		}
+		start++;
+	}
+
+	return ENOENT;
+}
 
 int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 				   blk_t block, int num)
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 9ba7701..fcf63ad 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -848,3 +848,55 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 
 	return ENOENT;
 }
+
+errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
+					     __u64 start, __u64 end, __u64 *out)
+{
+	int b;
+
+	if (!bitmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_64_BITMAP(bitmap) && bitmap->bitmap_ops->find_first_set)
+		return bitmap->bitmap_ops->find_first_set(bitmap, start,
+							  end, out);
+
+	if (EXT2FS_IS_32_BITMAP(bitmap)) {
+		blk_t blk = 0;
+		errcode_t retval;
+
+		if (((start) & ~0xffffffffULL) ||
+		    ((end) & ~0xffffffffULL)) {
+			ext2fs_warn_bitmap2(bitmap, EXT2FS_TEST_ERROR, start);
+			return EINVAL;
+		}
+
+		retval = ext2fs_find_first_set_generic_bitmap(bitmap, start,
+							      end, &blk);
+		if (retval == 0)
+			*out = blk;
+		return retval;
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bitmap))
+		return EINVAL;
+
+	start >>= bitmap->cluster_bits;
+	end >>= bitmap->cluster_bits;
+
+	if (start < bitmap->start || end > bitmap->end || start > end) {
+		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, start);
+		return EINVAL;
+	}
+
+	while (start <= end) {
+		b = bitmap->bitmap_ops->test_bmap(bitmap, start);
+		if (b) {
+			*out = start << bitmap->cluster_bits;
+			return 0;
+		}
+		start++;
+	}
+
+	return ENOENT;
+}
diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
index 57bfd6c..4e02ade 100644
--- a/lib/ext2fs/tst_bitmaps.c
+++ b/lib/ext2fs/tst_bitmaps.c
@@ -436,6 +436,39 @@ void do_ffzb(int argc, char *argv[])
 	printf("First unmarked block is %llu\n", out);
 }
 
+void do_ffsb(int argc, char *argv[])
+{
+	unsigned int start, end;
+	int err;
+	errcode_t retval;
+	blk64_t out;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	if (argc != 3 && argc != 3) {
+		com_err(argv[0], 0, "Usage: ffsb <start> <end>");
+		return;
+	}
+
+	start = parse_ulong(argv[1], argv[0], "start", &err);
+	if (err)
+		return;
+
+	end = parse_ulong(argv[2], argv[0], "end", &err);
+	if (err)
+		return;
+
+	retval = ext2fs_find_first_set_block_bitmap2(test_fs->block_map,
+						      start, end, &out);
+	if (retval) {
+		printf("ext2fs_find_first_set_block_bitmap2() returned %s\n",
+		       error_message(retval));
+		return;
+	}
+	printf("First marked block is %llu\n", out);
+}
+
 
 void do_zerob(int argc, char *argv[])
 {
@@ -559,6 +592,38 @@ void do_ffzi(int argc, char *argv[])
 	printf("First unmarked inode is %u\n", out);
 }
 
+void do_ffsi(int argc, char *argv[])
+{
+	unsigned int start, end;
+	int err;
+	errcode_t retval;
+	ext2_ino_t out;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	if (argc != 3 && argc != 3) {
+		com_err(argv[0], 0, "Usage: ffsi <start> <end>");
+		return;
+	}
+
+	start = parse_ulong(argv[1], argv[0], "start", &err);
+	if (err)
+		return;
+
+	end = parse_ulong(argv[2], argv[0], "end", &err);
+	if (err)
+		return;
+
+	retval = ext2fs_find_first_set_inode_bitmap2(test_fs->inode_map,
+						     start, end, &out);
+	if (retval) {
+		printf("ext2fs_find_first_set_inode_bitmap2() returned %s\n",
+		       error_message(retval));
+		return;
+	}
+	printf("First marked inode is %u\n", out);
+}
 
 void do_zeroi(int argc, char *argv[])
 {
diff --git a/lib/ext2fs/tst_bitmaps_cmd.ct b/lib/ext2fs/tst_bitmaps_cmd.ct
index 1e1e5d3..13b7fa7 100644
--- a/lib/ext2fs/tst_bitmaps_cmd.ct
+++ b/lib/ext2fs/tst_bitmaps_cmd.ct
@@ -24,6 +24,9 @@ request do_testb, "Test block",
 request do_ffzb, "Find first zero block",
 	find_first_zero_block, ffzb;
 
+request do_ffsb, "Find first set block",
+	find_first_set_block, ffsb;
+
 request do_zerob, "Clear block bitmap",
 	clear_block_bitmap, zerob;
 
@@ -39,6 +42,9 @@ request do_testi, "Test inode",
 request do_ffzi, "Find first zero inode",
 	find_first_zero_inode, ffzi;
 
+request do_ffsi, "Find first set inode",
+	find_first_set_inode, ffsi;
+
 request do_zeroi, "Clear inode bitmap",
 	clear_inode_bitmap, zeroi;
 
diff --git a/lib/ext2fs/tst_bitmaps_cmds b/lib/ext2fs/tst_bitmaps_cmds
index 31e2a60..7492592 100644
--- a/lib/ext2fs/tst_bitmaps_cmds
+++ b/lib/ext2fs/tst_bitmaps_cmds
@@ -19,8 +19,17 @@ dump_bb
 ffzb 11 16
 ffzb 12 16
 ffzb 12 20
+ffsb 0 127
+ffsb 1 128
+ffsb 1 127
+ffsb 1 10
+ffsb 1 11
+ffsb 12 12
+ffsb 13 12
+ffsb 12 15
 clearb 13
 ffzb 12 20
+ffsb 13 18
 setb 13
 clearb 12 7
 testb 12 7
@@ -42,8 +51,15 @@ dump_ib
 ffzi 1 6
 ffzi 2 5
 ffzi 2 6
+ffsi 0 31
+ffsi 1 33
+ffsi 1 32
+ffsi 2 32
+ffsi 6 32
 cleari 4
 ffzi 2 6
+ffsi 4 32
+ffsi 5 32
 zeroi
 testi 5
 seti 5
@@ -95,5 +111,38 @@ clearb 2
 clearb 3
 clearb 7
 dump_bb
+ffsb 14 127
+ffsb 15 127
+ffsb 36 127
+ffsb 32 127
+ffsb 52 127
+ffsb 53 127
+ffsb 46 127
+ffsb 45 127
+ffsb 41 127
+ffsb 20 127
+ffsb 1 127
+ffsb 2 127
+ffsb 3 127
+ffsb 4 127
+ffsb 5 127
+ffsb 6 127
+ffsb 7 127
+ffsb 8 127
+ffzb 1 127
+ffzb 2 127
+ffzb 3 127
+ffzb 4 127
+ffzb 5 127
+ffzb 6 127
+ffzb 7 127
+ffzb 8 127
+ffzb 45 127
+ffzb 46 127
+ffzb 47 127
+ffzb 48 127
+ffzb 49 127
+ffzb 50 127
+ffzb 51 127
 quit
 
diff --git a/lib/ext2fs/tst_bitmaps_exp b/lib/ext2fs/tst_bitmaps_exp
index 2d62b66..6b22666 100644
--- a/lib/ext2fs/tst_bitmaps_exp
+++ b/lib/ext2fs/tst_bitmaps_exp
@@ -43,10 +43,28 @@ tst_bitmaps: ffzb 12 16
 ext2fs_find_first_zero_block_bitmap2() returned No such file or directory
 tst_bitmaps: ffzb 12 20
 First unmarked block is 17
+tst_bitmaps: ffsb 0 127
+ext2fs_find_first_set_block_bitmap2() returned Invalid argument
+tst_bitmaps: ffsb 1 128
+ext2fs_find_first_set_block_bitmap2() returned Invalid argument
+tst_bitmaps: ffsb 1 127
+First marked block is 12
+tst_bitmaps: ffsb 1 10
+ext2fs_find_first_set_block_bitmap2() returned No such file or directory
+tst_bitmaps: ffsb 1 11
+ext2fs_find_first_set_block_bitmap2() returned No such file or directory
+tst_bitmaps: ffsb 12 12
+First marked block is 12
+tst_bitmaps: ffsb 13 12
+ext2fs_find_first_set_block_bitmap2() returned Invalid argument
+tst_bitmaps: ffsb 12 15
+First marked block is 12
 tst_bitmaps: clearb 13
 Clearing block 13, was set before
 tst_bitmaps: ffzb 12 20
 First unmarked block is 13
+tst_bitmaps: ffsb 13 18
+First marked block is 14
 tst_bitmaps: setb 13
 Setting block 13, was clear before
 tst_bitmaps: clearb 12 7
@@ -91,10 +109,24 @@ tst_bitmaps: ffzi 2 5
 ext2fs_find_first_zero_inode_bitmap2() returned No such file or directory
 tst_bitmaps: ffzi 2 6
 First unmarked inode is 6
+tst_bitmaps: ffsi 0 31
+ext2fs_find_first_set_inode_bitmap2() returned Invalid argument
+tst_bitmaps: ffsi 1 33
+ext2fs_find_first_set_inode_bitmap2() returned Invalid argument
+tst_bitmaps: ffsi 1 32
+First marked inode is 2
+tst_bitmaps: ffsi 2 32
+First marked inode is 2
+tst_bitmaps: ffsi 6 32
+ext2fs_find_first_set_inode_bitmap2() returned No such file or directory
 tst_bitmaps: cleari 4
 Clearing inode 4, was set before
 tst_bitmaps: ffzi 2 6
 First unmarked inode is 4
+tst_bitmaps: ffsi 4 32
+First marked inode is 5
+tst_bitmaps: ffsi 5 32
+First marked inode is 5
 tst_bitmaps: zeroi
 Clearing inode bitmap.
 tst_bitmaps: testi 5
@@ -207,5 +239,71 @@ Clearing block 7, was set before
 tst_bitmaps: dump_bb
 block bitmap: b92a85e6c4680d000000000000000000
 bits set: 25
+tst_bitmaps: ffsb 14 127
+First marked block is 14
+tst_bitmaps: ffsb 15 127
+First marked block is 17
+tst_bitmaps: ffsb 36 127
+First marked block is 39
+tst_bitmaps: ffsb 32 127
+First marked block is 32
+tst_bitmaps: ffsb 52 127
+First marked block is 52
+tst_bitmaps: ffsb 53 127
+ext2fs_find_first_set_block_bitmap2() returned No such file or directory
+tst_bitmaps: ffsb 46 127
+First marked block is 46
+tst_bitmaps: ffsb 45 127
+First marked block is 46
+tst_bitmaps: ffsb 41 127
+First marked block is 44
+tst_bitmaps: ffsb 20 127
+First marked block is 24
+tst_bitmaps: ffsb 1 127
+First marked block is 1
+tst_bitmaps: ffsb 2 127
+First marked block is 4
+tst_bitmaps: ffsb 3 127
+First marked block is 4
+tst_bitmaps: ffsb 4 127
+First marked block is 4
+tst_bitmaps: ffsb 5 127
+First marked block is 5
+tst_bitmaps: ffsb 6 127
+First marked block is 6
+tst_bitmaps: ffsb 7 127
+First marked block is 8
+tst_bitmaps: ffsb 8 127
+First marked block is 8
+tst_bitmaps: ffzb 1 127
+First unmarked block is 2
+tst_bitmaps: ffzb 2 127
+First unmarked block is 2
+tst_bitmaps: ffzb 3 127
+First unmarked block is 3
+tst_bitmaps: ffzb 4 127
+First unmarked block is 7
+tst_bitmaps: ffzb 5 127
+First unmarked block is 7
+tst_bitmaps: ffzb 6 127
+First unmarked block is 7
+tst_bitmaps: ffzb 7 127
+First unmarked block is 7
+tst_bitmaps: ffzb 8 127
+First unmarked block is 9
+tst_bitmaps: ffzb 45 127
+First unmarked block is 45
+tst_bitmaps: ffzb 46 127
+First unmarked block is 48
+tst_bitmaps: ffzb 47 127
+First unmarked block is 48
+tst_bitmaps: ffzb 48 127
+First unmarked block is 48
+tst_bitmaps: ffzb 49 127
+First unmarked block is 50
+tst_bitmaps: ffzb 50 127
+First unmarked block is 50
+tst_bitmaps: ffzb 51 127
+First unmarked block is 53
 tst_bitmaps: quit
 tst_bitmaps: 
-- 
1.8.5.rc3.362.gdf10213

