From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 04/15] libext2fs: remove unnecessary casts to ext2fs_generic_bitmap
Date: Mon, 29 Nov 2010 17:55:06 +0900
Message-ID: <1291020917-8671-5-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40591 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0K2Izd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:33 -0500
Received: by gyb11 with SMTP id 11so1865466gyb.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:32 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/ext2fs/gen_bitmap64.c |   69 +++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 9f23b92..eb87b6d 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -144,7 +144,7 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
 		return;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		ext2fs_free_generic_bitmap((ext2fs_generic_bitmap) bmap);
+		ext2fs_free_generic_bitmap(bmap);
 		return;
 	}
 
@@ -171,8 +171,7 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
 		return EINVAL;
 
 	if (EXT2FS_IS_32_BITMAP(src))
-		return ext2fs_copy_generic_bitmap((ext2fs_generic_bitmap) src,
-						  (ext2fs_generic_bitmap *) dest);
+		return ext2fs_copy_generic_bitmap(src, dest);
 
 	if (!EXT2FS_IS_64_BITMAP(src))
 		return EINVAL;
@@ -222,11 +221,9 @@ errcode_t ext2fs_resize_generic_bmap(ext2fs_generic_bitmap bmap,
 	if (!bmap)
 		return EINVAL;
 
-	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		return ext2fs_resize_generic_bitmap(bmap->magic,
-						    new_end, new_real_end,
-						    (ext2fs_generic_bitmap) bmap);
-	}
+	if (EXT2FS_IS_32_BITMAP(bmap))
+		return ext2fs_resize_generic_bitmap(bmap->magic, new_end,
+						    new_real_end, bmap);
 
 	if (!EXT2FS_IS_64_BITMAP(bmap))
 		return EINVAL;
@@ -245,7 +242,7 @@ errcode_t ext2fs_fudge_generic_bmap_end(ext2fs_generic_bitmap bitmap,
 		ext2_ino_t tmp_oend;
 		int retval;
 
-		retval = ext2fs_fudge_generic_bitmap_end((ext2fs_generic_bitmap) bitmap,
+		retval = ext2fs_fudge_generic_bitmap_end(bitmap,
 							 bitmap->magic, neq,
 							 end, &tmp_oend);
 		if (oend)
@@ -269,11 +266,8 @@ __u64 ext2fs_get_generic_bmap_start(ext2fs_generic_bitmap bitmap)
 	if (!bitmap)
 		return EINVAL;
 
-	if (EXT2FS_IS_32_BITMAP(bitmap)) {
-		return ext2fs_get_generic_bitmap_start((ext2fs_generic_bitmap)
-						       bitmap);
-
-	}
+	if (EXT2FS_IS_32_BITMAP(bitmap))
+		return ext2fs_get_generic_bitmap_start(bitmap);
 
 	if (!EXT2FS_IS_64_BITMAP(bitmap))
 		return EINVAL;
@@ -286,11 +280,8 @@ __u64 ext2fs_get_generic_bmap_end(ext2fs_generic_bitmap bitmap)
 	if (!bitmap)
 		return EINVAL;
 
-	if (EXT2FS_IS_32_BITMAP(bitmap)) {
-		return ext2fs_get_generic_bitmap_end((ext2fs_generic_bitmap)
-						       bitmap);
-
-	}
+	if (EXT2FS_IS_32_BITMAP(bitmap))
+		return ext2fs_get_generic_bitmap_end(bitmap);
 
 	if (!EXT2FS_IS_64_BITMAP(bitmap))
 		return EINVAL;
@@ -300,10 +291,8 @@ __u64 ext2fs_get_generic_bmap_end(ext2fs_generic_bitmap bitmap)
 
 void ext2fs_clear_generic_bmap(ext2fs_generic_bitmap bitmap)
 {
-	if (EXT2FS_IS_32_BITMAP(bitmap)) {
-		ext2fs_clear_generic_bitmap((ext2fs_generic_bitmap) bitmap);
-		return;
-	}
+	if (EXT2FS_IS_32_BITMAP(bitmap))
+		ext2fs_clear_generic_bitmap(bitmap);
 
 	bitmap->bitmap_ops->clear_bmap (bitmap);
 }
@@ -316,12 +305,11 @@ int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap bitmap,
 
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
 		if (arg & ~0xffffffffULL) {
-			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bitmap,
+			ext2fs_warn_bitmap2(bitmap,
 					    EXT2FS_MARK_ERROR, 0xffffffff);
 			return 0;
 		}
-		return ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap)
-						  bitmap, arg);
+		return ext2fs_mark_generic_bitmap(bitmap, arg);
 	}
 
 	if (!EXT2FS_IS_64_BITMAP(bitmap))
@@ -343,12 +331,11 @@ int ext2fs_unmark_generic_bmap(ext2fs_generic_bitmap bitmap,
 
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
 		if (arg & ~0xffffffffULL) {
-			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bitmap,
+			ext2fs_warn_bitmap2(bitmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return 0;
 		}
-		return ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap)
-						  bitmap, arg);
+		return ext2fs_unmark_generic_bitmap(bitmap, arg);
 	}
 
 	if (!EXT2FS_IS_64_BITMAP(bitmap))
@@ -370,12 +357,11 @@ int ext2fs_test_generic_bmap(ext2fs_generic_bitmap bitmap,
 
 	if (EXT2FS_IS_32_BITMAP(bitmap)) {
 		if (arg & ~0xffffffffULL) {
-			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bitmap,
+			ext2fs_warn_bitmap2(bitmap,
 					    EXT2FS_TEST_ERROR, 0xffffffff);
 			return 0;
 		}
-		return ext2fs_test_generic_bitmap((ext2fs_generic_bitmap)
-						  bitmap, arg);
+		return ext2fs_test_generic_bitmap(bitmap, arg);
 	}
 
 	if (!EXT2FS_IS_64_BITMAP(bitmap))
@@ -398,13 +384,12 @@ errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap bmap,
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
 		if ((start+num) & ~0xffffffffULL) {
-			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+			ext2fs_warn_bitmap2(bmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return EINVAL;
 		}
-		return ext2fs_set_generic_bitmap_range((ext2fs_generic_bitmap) bmap,
-						       bmap->magic, start, num,
-						       in);
+		return ext2fs_set_generic_bitmap_range(bmap, bmap->magic,
+						       start, num, in);
 	}
 
 	if (!EXT2FS_IS_64_BITMAP(bmap))
@@ -422,13 +407,12 @@ errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap bmap,
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
 		if ((start+num) & ~0xffffffffULL) {
-			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+			ext2fs_warn_bitmap2(bmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return EINVAL;
 		}
-		return ext2fs_get_generic_bitmap_range((ext2fs_generic_bitmap) bmap,
-						       bmap->magic, start, num,
-						       out);
+		return ext2fs_get_generic_bitmap_range(bmap, bmap->magic,
+						       start, num, out);
 	}
 
 	if (!EXT2FS_IS_64_BITMAP(bmap))
@@ -451,8 +435,7 @@ errcode_t ext2fs_compare_generic_bmap(errcode_t neq,
 	/* Now we know both bitmaps have the same magic */
 	if (EXT2FS_IS_32_BITMAP(bm1))
 		return ext2fs_compare_generic_bitmap(bm1->magic, neq,
-					     (ext2fs_generic_bitmap) bm1,
-					     (ext2fs_generic_bitmap) bm2);
+						     bm1, bm2);
 
 	if (!EXT2FS_IS_64_BITMAP(bm1))
 		return EINVAL;
@@ -474,7 +457,7 @@ void ext2fs_set_generic_bmap_padding(ext2fs_generic_bitmap bmap)
 	__u64	start, num;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		ext2fs_set_generic_bitmap_padding((ext2fs_generic_bitmap) bmap);
+		ext2fs_set_generic_bitmap_padding(bmap);
 		return;
 	}
 
-- 
1.7.0.4

