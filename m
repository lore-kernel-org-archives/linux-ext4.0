From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] libext2fs: add 32-bit compat code for ext2fs_find_first_zero_generic_bmap()
Date: Fri,  6 Apr 2012 11:59:04 -0700
Message-ID: <1333738746-5857-1-git-send-email-tytso@mit.edu>
References: <20120406185759.GA5584@thunk.org>
Cc: rjones@redhat.com, sami.liedes@iki.fi,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60245 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882Ab2DFTyN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:54:13 -0400
In-Reply-To: <20120406185759.GA5584@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The lack of 32-bit support was causing febootstrap to crash since it
wasn't passing EXT2_FLAG_64BITS when opening the file system, so we
were still using the legacy bitmaps.

Addresses-Red-Hat-Bugzilla: #808421

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h       |    3 +++
 lib/ext2fs/gen_bitmap.c   |   25 +++++++++++++++++++++++++
 lib/ext2fs/gen_bitmap64.c |   32 ++++++++++++++++++++++++++++----
 3 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 68e94a3..fda6ade 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1169,6 +1169,9 @@ extern errcode_t ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 						 errcode_t magic,
 						 __u32 start, __u32 num,
 						 void *in);
+extern errcode_t ext2fs_find_first_zero_generic_bitmap(ext2fs_generic_bitmap bitmap,
+						       __u32 start, __u32 end,
+						       __u32 *out);
 
 /* gen_bitmap64.c */
 
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index 6679bff..0bff854 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -504,6 +504,30 @@ static int ext2fs_test_clear_generic_bitmap_range(ext2fs_generic_bitmap bitmap,
 	return ext2fs_mem_is_zero(ADDR + start_byte, len_byte);
 }
 
+errcode_t ext2fs_find_first_zero_generic_bitmap(ext2fs_generic_bitmap bitmap,
+						__u32 start, __u32 end,
+						__u32 *out)
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
+		if (!b) {
+			*out = start;
+			return 0;
+		}
+		start++;
+	}
+
+	return ENOENT;
+}
+
+
 int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 				   blk_t block, int num)
 {
@@ -558,3 +582,4 @@ void ext2fs_unmark_block_bitmap_range(ext2fs_block_bitmap bitmap,
 		ext2fs_fast_clear_bit(block + i - bitmap->start,
 				      bitmap->bitmap);
 }
+
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index e765d2c..07d6d52 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -770,12 +770,36 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 {
 	int b;
 
-	if (bitmap->bitmap_ops->find_first_zero)
-		return bitmap->bitmap_ops->find_first_zero(bitmap, start, end, out);
+	if (!bitmap)
+		return EINVAL;
 
-	if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bits)
+	if (EXT2FS_IS_64_BITMAP(bitmap) && bitmap->bitmap_ops->find_first_zero)
+		return bitmap->bitmap_ops->find_first_zero(bitmap, start,
+							   end, out);
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
+		retval = ext2fs_find_first_zero_generic_bitmap(bitmap, start,
+							       end, &blk);
+		if (retval == 0)
+			*out = blk;
+		return retval;
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bitmap))
 		return EINVAL;
 
+	start >>= bitmap->cluster_bits;
+	end >>= bitmap->cluster_bits;
+
 	if (start < bitmap->start || end > bitmap->end || start > end) {
 		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, start);
 		return EINVAL;
@@ -784,7 +808,7 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 	while (start <= end) {
 		b = bitmap->bitmap_ops->test_bmap(bitmap, start);
 		if (!b) {
-			*out = start;
+			*out = start << bitmap->cluster_bits;
 			return 0;
 		}
 		start++;
-- 
1.7.10.rc3

