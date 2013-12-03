From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 06/10] libext2fs: add explicit casts to bitops.h
Date: Tue,  3 Dec 2013 00:10:14 -0500
Message-ID: <1386047418-32431-7-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35854 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab3LCFK0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:26 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add some explicit casts to silence some -Wconversion noise.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/bitops.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index edf82f2..3e8132d 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -244,7 +244,7 @@ _INLINE_ void ext2fs_fast_set_bit(unsigned int nr,void * addr)
 	unsigned char	*ADDR = (unsigned char *) addr;
 
 	ADDR += nr >> 3;
-	*ADDR |= (1 << (nr & 0x07));
+	*ADDR |= (unsigned char) (1 << (nr & 0x07));
 }
 
 _INLINE_ void ext2fs_fast_clear_bit(unsigned int nr, void * addr)
@@ -252,7 +252,7 @@ _INLINE_ void ext2fs_fast_clear_bit(unsigned int nr, void * addr)
 	unsigned char	*ADDR = (unsigned char *) addr;
 
 	ADDR += nr >> 3;
-	*ADDR &= ~(1 << (nr & 0x07));
+	*ADDR &= (unsigned char) ~(1 << (nr & 0x07));
 }
 
 
@@ -261,7 +261,7 @@ _INLINE_ void ext2fs_fast_set_bit64(__u64 nr, void * addr)
 	unsigned char	*ADDR = (unsigned char *) addr;
 
 	ADDR += nr >> 3;
-	*ADDR |= (1 << (nr & 0x07));
+	*ADDR |= (unsigned char) (1 << (nr & 0x07));
 }
 
 _INLINE_ void ext2fs_fast_clear_bit64(__u64 nr, void * addr)
@@ -269,7 +269,7 @@ _INLINE_ void ext2fs_fast_clear_bit64(__u64 nr, void * addr)
 	unsigned char	*ADDR = (unsigned char *) addr;
 
 	ADDR += nr >> 3;
-	*ADDR &= ~(1 << (nr & 0x07));
+	*ADDR &= (unsigned char) ~(1 << (nr & 0x07));
 }
 
 
@@ -358,7 +358,7 @@ _INLINE_ __u16 ext2fs_swab16(__u16 val)
 
 _INLINE_ __u16 ext2fs_swab16(__u16 val)
 {
-	return (val >> 8) | (val << 8);
+	return (val >> 8) | (__u16) (val << 8);
 }
 
 _INLINE_ __u32 ext2fs_swab32(__u32 val)
@@ -371,7 +371,7 @@ _INLINE_ __u32 ext2fs_swab32(__u32 val)
 
 _INLINE_ __u64 ext2fs_swab64(__u64 val)
 {
-	return (ext2fs_swab32(val >> 32) |
+	return (ext2fs_swab32((__u32) (val >> 32)) |
 		(((__u64)ext2fs_swab32(val & 0xFFFFFFFFUL)) << 32));
 }
 
@@ -600,7 +600,7 @@ _INLINE_ errcode_t ext2fs_find_first_zero_inode_bitmap2(ext2fs_inode_bitmap bitm
 	rv = ext2fs_find_first_zero_generic_bmap((ext2fs_generic_bitmap) bitmap,
 						 start, end, &o);
 	if (!rv)
-		*out = o;
+		*out = (ext2_ino_t) o;
 	return rv;
 }
 
@@ -611,7 +611,7 @@ _INLINE_ blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap bitmap)
 
 _INLINE_ ext2_ino_t ext2fs_get_inode_bitmap_start2(ext2fs_inode_bitmap bitmap)
 {
-	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap) bitmap);
+	return (ext2_ino_t) ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap) bitmap);
 }
 
 _INLINE_ blk64_t ext2fs_get_block_bitmap_end2(ext2fs_block_bitmap bitmap)
@@ -621,7 +621,7 @@ _INLINE_ blk64_t ext2fs_get_block_bitmap_end2(ext2fs_block_bitmap bitmap)
 
 _INLINE_ ext2_ino_t ext2fs_get_inode_bitmap_end2(ext2fs_inode_bitmap bitmap)
 {
-	return ext2fs_get_generic_bmap_end((ext2fs_generic_bitmap) bitmap);
+	return (ext2_ino_t) ext2fs_get_generic_bmap_end((ext2fs_generic_bitmap) bitmap);
 }
 
 _INLINE_ int ext2fs_fast_test_block_bitmap_range2(ext2fs_block_bitmap bitmap,
-- 
1.8.5.rc3.362.gdf10213

