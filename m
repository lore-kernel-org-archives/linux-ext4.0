From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 04/12] libext: optimize find_first_set() for bitarray-based bitmaps
Date: Mon, 20 Jan 2014 00:54:06 -0500
Message-ID: <1390197254-14583-5-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49948 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaATFyY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:24 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Basically just a trivial adaption of the find_first_zero() function
for bitarray-based bitmaps.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_ba.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
index 284236d..894293a 100644
--- a/lib/ext2fs/blkmap64_ba.c
+++ b/lib/ext2fs/blkmap64_ba.c
@@ -391,6 +391,80 @@ static errcode_t ba_find_first_zero(ext2fs_generic_bitmap bitmap,
 	return ENOENT;
 }
 
+/* Find the first one bit between start and end, inclusive. */
+static errcode_t ba_find_first_set(ext2fs_generic_bitmap bitmap,
+				    __u64 start, __u64 end, __u64 *out)
+{
+	ext2fs_ba_private bp = (ext2fs_ba_private)bitmap->private;
+	unsigned long bitpos = start - bitmap->start;
+	unsigned long count = end - start + 1;
+	int byte_found = 0; /* whether a != 0xff byte has been found */
+	const unsigned char *pos;
+	unsigned long max_loop_count, i;
+
+	/* scan bits until we hit a byte boundary */
+	while ((bitpos & 0x7) != 0 && count > 0) {
+		if (ext2fs_test_bit64(bitpos, bp->bitarray)) {
+			*out = bitpos + bitmap->start;
+			return 0;
+		}
+		bitpos++;
+		count--;
+	}
+
+	if (!count)
+		return ENOENT;
+
+	pos = ((unsigned char *)bp->bitarray) + (bitpos >> 3);
+	/* scan bytes until 8-byte (64-bit) aligned */
+	while (count >= 8 && (((unsigned long)pos) & 0x07)) {
+		if (*pos != 0) {
+			byte_found = 1;
+			break;
+		}
+		pos++;
+		count -= 8;
+		bitpos += 8;
+	}
+
+	if (!byte_found) {
+		max_loop_count = count >> 6; /* 8-byte blocks */
+		i = max_loop_count;
+		while (i) {
+			if (*((const __u64 *)pos) != 0)
+				break;
+			pos += 8;
+			i--;
+		}
+		count -= 64 * (max_loop_count - i);
+		bitpos += 64 * (max_loop_count - i);
+
+		max_loop_count = count >> 3;
+		i = max_loop_count;
+		while (i) {
+			if (*pos != 0) {
+				byte_found = 1;
+				break;
+			}
+			pos++;
+			i--;
+		}
+		count -= 8 * (max_loop_count - i);
+		bitpos += 8 * (max_loop_count - i);
+	}
+
+	/* Here either count < 8 or byte_found == 1. */
+	while (count-- > 0) {
+		if (ext2fs_test_bit64(bitpos, bp->bitarray)) {
+			*out = bitpos + bitmap->start;
+			return 0;
+		}
+		bitpos++;
+	}
+
+	return ENOENT;
+}
+
 struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
 	.type = EXT2FS_BMAP64_BITARRAY,
 	.new_bmap = ba_new_bmap,
@@ -407,5 +481,6 @@ struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
 	.get_bmap_range = ba_get_bmap_range,
 	.clear_bmap = ba_clear_bmap,
 	.print_stats = ba_print_stats,
-	.find_first_zero = ba_find_first_zero
+	.find_first_zero = ba_find_first_zero,
+	.find_first_set = ba_find_first_set
 };
-- 
1.8.5.rc3.362.gdf10213

