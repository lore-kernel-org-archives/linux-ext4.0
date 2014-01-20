From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 03/12] libext2fs: build tst_bitmaps with rep invariants checking enabled
Date: Mon, 20 Jan 2014 00:54:05 -0500
Message-ID: <1390197254-14583-4-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49964 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaATFy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:28 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When building tst_bitmaps, enable #define DEBUG_RB, so we are
always testing the sanity of the in-memory representation of the
bitmap when using red-black trees as part of a "make check" run.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in   |  7 ++++---
 lib/ext2fs/blkmap64_rb.c | 14 +++++++++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index ef55e08..090b89a 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -372,10 +372,11 @@ tst_bitmaps_cmd.c: tst_bitmaps_cmd.ct
 	$(E) "	MK_CMDS $@"
 	$(Q) DIR=$(srcdir) $(MK_CMDS) $(srcdir)/tst_bitmaps_cmd.ct
 
-tst_bitmaps: tst_bitmaps.o tst_bitmaps_cmd.o $(STATIC_LIBEXT2FS) \
-		$(DEPSTATIC_LIBSS) $(DEPSTATIC_LIBCOM_ERR)
+tst_bitmaps: tst_bitmaps.o tst_bitmaps_cmd.o $(srcdir)/blkmap64_rb.c \
+		$(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
-	$(Q) $(CC) -o $@ tst_bitmaps.o tst_bitmaps_cmd.o $(ALL_CFLAGS) \
+	$(Q) $(CC) -o $@ tst_bitmaps.o tst_bitmaps_cmd.o \
+		-DDEBUG_RB $(srcdir)/blkmap64_rb.c $(ALL_CFLAGS) \
 		$(STATIC_LIBEXT2FS) $(STATIC_LIBSS) $(STATIC_LIBCOM_ERR) \
 		$(SYSLIBS)
 
diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index a189590..0e0a217 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -135,7 +135,7 @@ err_out:
 }
 #else
 #define check_tree(root, msg) do {} while (0)
-#define print_tree(root, msg) do {} while (0)
+#define print_tree(root) do {} while (0)
 #endif
 
 static void rb_get_new_extent(struct bmap_rb_extent **ext, __u64 start,
@@ -569,11 +569,14 @@ static int rb_remove_extent(__u64 start, __u64 count,
 static int rb_mark_bmap(ext2fs_generic_bitmap bitmap, __u64 arg)
 {
 	struct ext2fs_rb_private *bp;
+	int retval;
 
 	bp = (struct ext2fs_rb_private *) bitmap->private;
 	arg -= bitmap->start;
 
-	return rb_insert_extent(arg, 1, bp);
+	retval = rb_insert_extent(arg, 1, bp);
+	check_tree(&bp->root, __func__);
+	return retval;
 }
 
 static int rb_unmark_bmap(ext2fs_generic_bitmap bitmap, __u64 arg)
@@ -610,6 +613,7 @@ static void rb_mark_bmap_extent(ext2fs_generic_bitmap bitmap, __u64 arg,
 	arg -= bitmap->start;
 
 	rb_insert_extent(arg, num, bp);
+	check_tree(&bp->root, __func__);
 }
 
 static void rb_unmark_bmap_extent(ext2fs_generic_bitmap bitmap, __u64 arg,
@@ -714,11 +718,14 @@ static errcode_t rb_set_bmap_range(ext2fs_generic_bitmap bitmap,
 
 		rb_insert_extent(start + first_set - bitmap->start,
 				 i - first_set, bp);
+		check_tree(&bp->root, __func__);
 		first_set = -1;
 	}
-	if (first_set != -1)
+	if (first_set != -1) {
 		rb_insert_extent(start + first_set - bitmap->start,
 				 num - first_set, bp);
+		check_tree(&bp->root, __func__);
+	}
 
 	return 0;
 }
@@ -799,6 +806,7 @@ static void rb_clear_bmap(ext2fs_generic_bitmap bitmap)
 	bp->rcursor = NULL;
 	bp->rcursor_next = NULL;
 	bp->wcursor = NULL;
+	check_tree(&bp->root, __func__);
 }
 
 #ifdef BMAP_STATS
-- 
1.8.5.rc3.362.gdf10213

