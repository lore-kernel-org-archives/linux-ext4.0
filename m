From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH 3/5] libext2fs: find_first_set() for bitarray bitmap
Date: Tue, 19 Mar 2013 20:06:02 +0400
Message-ID: <1363709164-3210-4-git-send-email-qrxd43@motorola.com>
References: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:54581 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3CSQGa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 12:06:30 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.22.94.168])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2JG9N2V027537
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 12:09:23 -0400 (EDT)
Received: from mail-ea0-f174.google.com (mail-ea0-f174.google.com [209.85.215.174])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2JG8w2l027272
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 12:09:22 -0400 (EDT)
Received: by mail-ea0-f174.google.com with SMTP id q10so318494eaj.5
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 09:06:24 -0700 (PDT)
In-Reply-To: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

find_first_set() implementation for bitarray bitmap,
just an inverted copy of find_first_zero().

Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>
---
 lib/ext2fs/blkmap64_ba.c |   83 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 76 insertions(+), 7 deletions(-)

diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
index 73180b0..d3bd769 100644
--- a/lib/ext2fs/blkmap64_ba.c
+++ b/lib/ext2fs/blkmap64_ba.c
@@ -332,12 +332,6 @@ static errcode_t ba_find_first_zero(ext2fs_generic_bitmap bitmap,
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
@@ -401,6 +395,80 @@ static errcode_t ba_find_first_zero(ext2fs_generic_bitmap bitmap,
 	return ENOENT;
 }
 
+/* Find the first zero bit between start and end, inclusive. */
+static errcode_t ba_find_first_set(ext2fs_generic_bitmap bitmap,
+				   __u64 start, __u64 end, __u64 *out)
+{
+	ext2fs_ba_private bp = (ext2fs_ba_private)bitmap->private;
+	unsigned long bitpos = start - bitmap->start;
+	unsigned long count = end - start + 1;
+	int byte_found = 0; /* whether a != 0x00 byte has been found */
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
+			if (*((const __u64 *)pos) != ((__u64)0))
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
@@ -417,5 +485,6 @@ struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
 	.get_bmap_range = ba_get_bmap_range,
 	.clear_bmap = ba_clear_bmap,
 	.print_stats = ba_print_stats,
-	.find_first_zero = ba_find_first_zero
+	.find_first_zero = ba_find_first_zero,
+	.find_first_set = ba_find_first_set
 };
-- 
1.7.10.4

