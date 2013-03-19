From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH 2/5] libext2fs: find_first_set() for bitmaps.
Date: Tue, 19 Mar 2013 20:06:01 +0400
Message-ID: <1363709164-3210-3-git-send-email-qrxd43@motorola.com>
References: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:40852 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3CSQG3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 12:06:29 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.22.94.168])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2JG9MCl027529
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 12:09:22 -0400 (EDT)
Received: from mail-ea0-f176.google.com (mail-ea0-f176.google.com [209.85.215.176])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2JG9LZm027509
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 12:09:22 -0400 (EDT)
Received: by mail-ea0-f176.google.com with SMTP id h10so329569eaj.35
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 09:06:23 -0700 (PDT)
In-Reply-To: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Generic implementation of find_first_set for bitmaps.
Make ffs/ffz work for cluster bitmaps.

Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>
---
 lib/ext2fs/bitops.h           |   41 +++++++++++++++++++
 lib/ext2fs/bmap64.h           |    4 +-
 lib/ext2fs/ext2fs.h           |    3 ++
 lib/ext2fs/gen_bitmap.c       |   23 +++++++++++
 lib/ext2fs/gen_bitmap64.c     |   89 +++++++++++++++++++++++++++++++++++++----
 lib/ext2fs/tst_bitmaps.c      |   66 ++++++++++++++++++++++++++++++
 lib/ext2fs/tst_bitmaps_cmd.ct |    6 +++
 7 files changed, 224 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 1559539..523d07d 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -149,6 +149,14 @@ extern errcode_t ext2fs_find_first_zero_inode_bitmap2(ext2fs_inode_bitmap bitmap
 						      ext2_ino_t start,
 						      ext2_ino_t end,
 						      ext2_ino_t *out);
+extern errcode_t ext2fs_find_first_set_block_bitmap2(ext2fs_block_bitmap bitmap,
+						     blk64_t start,
+						     blk64_t end,
+						     blk64_t *out);
+extern errcode_t ext2fs_find_first_set_inode_bitmap2(ext2fs_inode_bitmap bitmap,
+						     ext2_ino_t start,
+						     ext2_ino_t end,
+						     ext2_ino_t *out);
 extern blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap bitmap);
 extern ext2_ino_t ext2fs_get_inode_bitmap_start2(ext2fs_inode_bitmap bitmap);
 extern blk64_t ext2fs_get_block_bitmap_end2(ext2fs_block_bitmap bitmap);
@@ -190,6 +198,9 @@ extern void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bitmap,
 extern errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 						     __u64 start, __u64 end,
 						     __u64 *out);
+extern errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
+						    __u64 start, __u64 end,
+						    __u64 *out);
 
 /*
  * The inline routines themselves...
@@ -596,6 +607,36 @@ _INLINE_ errcode_t ext2fs_find_first_zero_inode_bitmap2(ext2fs_inode_bitmap bitm
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
+		*out = o;
+	return rv;
+}
+
 _INLINE_ blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap bitmap)
 {
 	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap) bitmap);
diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
index c5384c9..40fec22 100644
--- a/lib/ext2fs/bmap64.h
+++ b/lib/ext2fs/bmap64.h
@@ -90,10 +90,12 @@ struct ext2_bitmap_ops {
 	void (*clear_bmap)(ext2fs_generic_bitmap bitmap);
 	void (*print_stats)(ext2fs_generic_bitmap);
 
-	/* Find the first zero bit between start and end, inclusive.
+	/* Find the first zero/set bit between start and end, inclusive.
 	 * May be NULL, in which case a generic function is used. */
 	errcode_t (*find_first_zero)(ext2fs_generic_bitmap bitmap,
 				     __u64 start, __u64 end, __u64 *out);
+	errcode_t (*find_first_set)(ext2fs_generic_bitmap bitmap,
+				    __u64 start, __u64 end, __u64 *out);
 };
 
 extern struct ext2_bitmap_ops ext2fs_blkmap64_bitarray;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7139b4d..cbefdb9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1237,6 +1237,9 @@ extern errcode_t ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 extern errcode_t ext2fs_find_first_zero_generic_bitmap(ext2fs_generic_bitmap bitmap,
 						       __u32 start, __u32 end,
 						       __u32 *out);
+extern errcode_t ext2fs_find_first_set_generic_bitmap(ext2fs_generic_bitmap bitmap,
+						      __u32 start, __u32 end,
+						      __u32 *out);
 
 /* gen_bitmap64.c */
 void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap);
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index 0bff854..07215cd 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -527,6 +527,29 @@ errcode_t ext2fs_find_first_zero_generic_bitmap(ext2fs_generic_bitmap bitmap,
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
+
 
 int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 				   blk_t block, int num)
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 42a97d4..80502b5 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -800,17 +800,14 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 					      __u64 start, __u64 end, __u64 *out)
 {
 	int b;
+	errcode_t retval = ENOENT;
+	__u64 original_start = start;
 
 	if (!bitmap)
 		return EINVAL;
 
-	if (EXT2FS_IS_64_BITMAP(bitmap) && bitmap->bitmap_ops->find_first_zero)
-		return bitmap->bitmap_ops->find_first_zero(bitmap, start,
-							   end, out);
-
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
 		blk_t blk = 0;
-		errcode_t retval;
 
 		if (((start) & ~0xffffffffULL) ||
 		    ((end) & ~0xffffffffULL)) {
@@ -836,14 +833,92 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 		return EINVAL;
 	}
 
+	if (bitmap->bitmap_ops->find_first_zero) {
+		retval = bitmap->bitmap_ops->find_first_zero(bitmap, start,
+							     end, out);
+
+		if (!retval)
+			*out <<= bitmap->cluster_bits;
+		goto out;
+	}
+
+
 	while (start <= end) {
 		b = bitmap->bitmap_ops->test_bmap(bitmap, start);
 		if (!b) {
 			*out = start << bitmap->cluster_bits;
-			return 0;
+			retval = 0;
+			break;
 		}
 		start++;
 	}
 
-	return ENOENT;
+out:
+	if (!retval && *out < original_start)
+		*out = original_start;
+
+	return retval;
+}
+
+errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
+					     __u64 start, __u64 end, __u64 *out)
+{
+	int b;
+	errcode_t retval = ENOENT;
+	__u64 original_start = start;
+
+	if (!bitmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bitmap)) {
+		blk_t blk = 0;
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
+	if (bitmap->bitmap_ops->find_first_set) {
+		retval = bitmap->bitmap_ops->find_first_set(bitmap, start,
+							    end, out);
+		if (!retval)
+			*out <<= bitmap->cluster_bits;
+		goto out;
+	}
+
+
+	while (start <= end) {
+		b = bitmap->bitmap_ops->test_bmap(bitmap, start);
+		if (b) {
+			*out = start << bitmap->cluster_bits;
+			retval = 0;
+			break;
+		}
+		start++;
+	}
+
+out:
+	if (!retval && *out < original_start)
+		*out = original_start;
+
+	return retval;
 }
diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
index 57bfd6c..dffceab 100644
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
@@ -559,6 +592,39 @@ void do_ffzi(int argc, char *argv[])
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
+
 
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
 
-- 
1.7.10.4

