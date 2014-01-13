From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] libext2fs: clean up generic handling of ext2fs_find_first_{set,zero}_*()
Date: Sun, 12 Jan 2014 21:48:10 -0500
Message-ID: <1389581293-17955-2-git-send-email-tytso@mit.edu>
References: <1389581293-17955-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47850 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbaAMCsY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Jan 2014 21:48:24 -0500
In-Reply-To: <1389581293-17955-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move the error checking into the the generic bitmap code, and add
support for bitmaps with cluster_bits set.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_ba.c  |  6 -----
 lib/ext2fs/gen_bitmap64.c | 66 +++++++++++++++++++++++++++--------------------
 2 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
index 8eddde9..284236d 100644
--- a/lib/ext2fs/blkmap64_ba.c
+++ b/lib/ext2fs/blkmap64_ba.c
@@ -328,12 +328,6 @@ static errcode_t ba_find_first_zero(ext2fs_generic_bitmap bitmap,
 	const unsigned char *pos;
 	unsigned long max_loop_count, i;
 
-	if (start < bitmap->start || end > bitmap->end || start > end)
-		return EINVAL;
-
-	if (bitmap->cluster_bits)
-		return EINVAL;
-
 	/* scan bits until we hit a byte boundary */
 	while ((bitpos & 0x7) != 0 && count > 0) {
 		if (!ext2fs_test_bit64(bitpos, bp->bitarray)) {
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index fcf63ad..f4cfd40 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -801,14 +801,12 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 					      __u64 start, __u64 end, __u64 *out)
 {
 	int b;
+	__u64 cstart, cend, cout;
+	errcode_t retval;
 
 	if (!bitmap)
 		return EINVAL;
 
-	if (EXT2FS_IS_64_BITMAP(bitmap) && bitmap->bitmap_ops->find_first_zero)
-		return bitmap->bitmap_ops->find_first_zero(bitmap, start,
-							   end, out);
-
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
 		blk_t blk = 0;
 		errcode_t retval;
@@ -829,23 +827,30 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
 	if (!EXT2FS_IS_64_BITMAP(bitmap))
 		return EINVAL;
 
-	start >>= bitmap->cluster_bits;
-	end >>= bitmap->cluster_bits;
-
 	if (start < bitmap->start || end > bitmap->end || start > end) {
 		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, start);
 		return EINVAL;
 	}
 
-	while (start <= end) {
-		b = bitmap->bitmap_ops->test_bmap(bitmap, start);
-		if (!b) {
-			*out = start << bitmap->cluster_bits;
-			return 0;
-		}
-		start++;
+	cstart = start >> bitmap->cluster_bits;
+	cend = end + (1 << bitmap->cluster_bits) - 1;
+	cend >>= bitmap->cluster_bits;
+
+	if (bitmap->bitmap_ops->find_first_zero) {
+		retval = bitmap->bitmap_ops->find_first_zero(bitmap, start,
+							     end, &cout);
+		if (retval)
+			return retval;
+	found:
+		cout <<= bitmap->cluster_bits;
+		*out = (cout >= start) ? cout : start;
+		return 0;
 	}
 
+	for (cout = cstart; cout <= cend; cout++)
+		if (!bitmap->bitmap_ops->test_bmap(bitmap, cout))
+			goto found;
+
 	return ENOENT;
 }
 
@@ -853,14 +858,12 @@ errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
 					     __u64 start, __u64 end, __u64 *out)
 {
 	int b;
+	__u64 cstart, cend, cout;
+	errcode_t retval;
 
 	if (!bitmap)
 		return EINVAL;
 
-	if (EXT2FS_IS_64_BITMAP(bitmap) && bitmap->bitmap_ops->find_first_set)
-		return bitmap->bitmap_ops->find_first_set(bitmap, start,
-							  end, out);
-
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
 		blk_t blk = 0;
 		errcode_t retval;
@@ -881,22 +884,29 @@ errcode_t ext2fs_find_first_set_generic_bmap(ext2fs_generic_bitmap bitmap,
 	if (!EXT2FS_IS_64_BITMAP(bitmap))
 		return EINVAL;
 
-	start >>= bitmap->cluster_bits;
-	end >>= bitmap->cluster_bits;
-
 	if (start < bitmap->start || end > bitmap->end || start > end) {
 		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, start);
 		return EINVAL;
 	}
 
-	while (start <= end) {
-		b = bitmap->bitmap_ops->test_bmap(bitmap, start);
-		if (b) {
-			*out = start << bitmap->cluster_bits;
-			return 0;
-		}
-		start++;
+	cstart = start >> bitmap->cluster_bits;
+	cend = end + (1 << bitmap->cluster_bits) - 1;
+	cend >>= bitmap->cluster_bits;
+
+	if (bitmap->bitmap_ops->find_first_set) {
+		retval = bitmap->bitmap_ops->find_first_set(bitmap, start,
+							    end, &cout);
+		if (retval)
+			return retval;
+	found:
+		cout <<= bitmap->cluster_bits;
+		*out = (cout >= start) ? cout : start;
+		return 0;
 	}
 
+	for (cout = cstart; cout <= cend; cout++)
+		if (bitmap->bitmap_ops->test_bmap(bitmap, cout))
+			goto found;
+
 	return ENOENT;
 }
-- 
1.8.5.rc3.362.gdf10213

