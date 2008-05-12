From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] fix extent_goto for non-0 leaf levels
Date: Mon, 12 May 2008 18:13:49 -0500
Message-ID: <4828CF2D.9010804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbYELXNw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 19:13:52 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4CNDpAo000597
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 19:13:51 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CNDpVJ010386
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 19:13:51 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CNDn59016285
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 19:13:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The logic for stopping at the right level in extent_goto was wrong,
so if you asked it to go to any level other than 0 (the leaf
level) it would fail.

Also add this argument to the tst_extents goto command to test it.

(I thought this was a failure in my split code but it was this
helper that was causing problems...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/ext2fs/extent.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/extent.c	2008-05-12 17:25:04.000000000 -0500
+++ e2fsprogs/lib/ext2fs/extent.c	2008-05-12 18:06:16.997505603 -0500
@@ -556,6 +556,9 @@ errcode_t ext2fs_extent_free_path(ext2_e
 /*
  * Go to the node at leaf_level which contains logical block blk.
  *
+ * leaf_level is height from the leaf node level, i.e.
+ * leaf_level 0 is at leaf node, leaf_level 1 is 1 above etc.
+ *
  * If "blk" has no mapping (hole) then handle is left at last
  * extent before blk.
  */
@@ -569,9 +572,15 @@ static errcode_t extent_goto(ext2_extent
 	if (retval)
 		return retval;
 
+	if (leaf_level > handle->max_depth) {
+		dbg_printf("leaf level %d greater than tree depth %d\n",
+			leaf_level, handle->max_depth);
+		return EXT2_ET_OP_NOT_SUPPORTED;
+	}
+
 	dbg_print_extent("root", &extent);
 	while (1) {
-		if (handle->level - leaf_level == handle->max_depth) {
+		if (handle->max_depth - handle->level == leaf_level) {
 			/* block is in this &extent */
 			if ((blk >= extent.e_lblk) &&
 			    (blk < extent.e_lblk + extent.e_len))
@@ -1140,6 +1149,7 @@ void do_goto_block(int argc, char **argv
 	errcode_t		retval;
 	int			op = EXT2_EXTENT_NEXT_LEAF;
 	blk_t			blk;
+	int			level = 0;
 
 	if (check_fs_open(argv[0]))
 		return;
@@ -1149,18 +1159,23 @@ void do_goto_block(int argc, char **argv
 		return;
 	}
 
-	if (argc != 2) {
-		fprintf(stderr, "%s block\n", argv[0]);
+	if (argc < 2 || argc > 3) {
+		fprintf(stderr, "%s block [level]\n", argv[0]);
 		return;
 	}
 
 	if (strtoblk(argv[0], argv[1], &blk))
 		return;
 
-	retval = ext2fs_extent_goto(current_handle, (blk64_t) blk);
+	if (argc == 3)
+		if (strtoblk(argv[0], argv[2], &level))
+			return;
+
+	retval = extent_goto(current_handle, level, (blk64_t) blk);
+
 	if (retval) {
-		com_err(argv[0], retval, "while trying to go to block %lu",
-			blk);
+		com_err(argv[0], retval, "while trying to go to block %lu, level %d",
+			blk, level);
 		return;
 	}
 

