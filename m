From: Mingming <cmm@us.ibm.com>
Subject: [PATCH 1/2] code clean up for dio fallocate handling
Date: Wed, 07 Oct 2009 10:19:13 -0700
Message-ID: <1254935953.18662.2.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36235 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548AbZJGRUB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Oct 2009 13:20:01 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n97HEjvk014834
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 11:14:45 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n97HJGUZ213768
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 11:19:17 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n97HJEx3001187
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 11:19:15 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: code clean up for dio fallocate handling

In the non async IO direct IO case, the io_end structure could be NULL.
The ext4_debug() call in ext4_end_io_dio() (inode.c) should be moved
after checking the io_end structure to be a non NULL pointer.

The comment above ext4_get_block_dio_write() ("Maximum
number of blocks...") is a duplicate; the original and correct comment
is above the #define DIO_MAX_BLOCKS up above.

The check for allocated > max_blocks in ext4_split_unwritten_extents()
can be removed, since the code returns immediately once allocated blocks
is less or equals to the requested blocks to convert.

Based on review comments from Curt Wohlgemuth.

Signed-off-by:	Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/extents.c |   96
+++++++++++++++++++++++++-----------------------------
 fs/ext4/inode.c   |    9 ++---
 2 files changed, 50 insertions(+), 55 deletions(-)

Index: linux-2.6.31-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.31-rc4/fs/ext4/extents.c
@@ -2806,6 +2806,7 @@ static int ext4_split_unwritten_extents(
 	ext4_fsblk_t newblock;
 	int err = 0;
 	int ret = 0;
+	unsigned int newdepth;
 
 	ext_debug("ext4_split_unwritten_extents: inode %lu,"
 		  "iblock %llu, max_blocks %u\n", inode->i_ino,
@@ -2845,61 +2846,56 @@ static int ext4_split_unwritten_extents(
 	 * we insert ex3, if ex1 is NULL. This is to avoid temporary
 	 * overlap of blocks.
 	 */
-	if (!ex1 && allocated > max_blocks)
+	if (!ex1)
 		ex2->ee_len = cpu_to_le16(max_blocks);
 	/* ex3: to ee_block + ee_len : uninitialised */
-	if (allocated > max_blocks) {
-		unsigned int newdepth;
-		ex3 = &newex;
-		ex3->ee_block = cpu_to_le32(iblock + max_blocks);
-		ext4_ext_store_pblock(ex3, newblock + max_blocks);
-		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
-		ext4_ext_mark_uninitialized(ex3);
-		err = ext4_ext_insert_extent(handle, inode, path, ex3, flags);
-		if (err == -ENOSPC) {
-			err =  ext4_ext_zeroout(inode, &orig_ex);
-			if (err)
-				goto fix_extent_len;
-			/* update the extent length and mark as initialized */
-			ex->ee_block = orig_ex.ee_block;
-			ex->ee_len   = orig_ex.ee_len;
-			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
-			ext4_ext_dirty(handle, inode, path + depth);
-			/* zeroed the full extent */
-			/* blocks available from iblock */
-			return allocated;
-
-		} else if (err)
-			goto fix_extent_len;
-		/*
-		 * The depth, and hence eh & ex might change
-		 * as part of the insert above.
-		 */
-		newdepth = ext_depth(inode);
-		/*
-		 * update the extent length after successful insert of the
-		 * split extent
-		 */
-		orig_ex.ee_len = cpu_to_le16(ee_len -
-						ext4_ext_get_actual_len(ex3));
-		depth = newdepth;
-		ext4_ext_drop_refs(path);
-		path = ext4_ext_find_extent(inode, iblock, path);
-		if (IS_ERR(path)) {
-			err = PTR_ERR(path);
-			goto out;
-		}
-		eh = path[depth].p_hdr;
-		ex = path[depth].p_ext;
-		if (ex2 != &newex)
-			ex2 = ex;
-
-		err = ext4_ext_get_access(handle, inode, path + depth);
+	ex3 = &newex;
+	ex3->ee_block = cpu_to_le32(iblock + max_blocks);
+	ext4_ext_store_pblock(ex3, newblock + max_blocks);
+	ex3->ee_len = cpu_to_le16(allocated - max_blocks);
+	ext4_ext_mark_uninitialized(ex3);
+	err = ext4_ext_insert_extent(handle, inode, path, ex3, flags);
+	if (err == -ENOSPC) {
+		err =  ext4_ext_zeroout(inode, &orig_ex);
 		if (err)
-			goto out;
+			goto fix_extent_len;
+		/* update the extent length and mark as initialized */
+		ex->ee_block = orig_ex.ee_block;
+		ex->ee_len   = orig_ex.ee_len;
+		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+		ext4_ext_dirty(handle, inode, path + depth);
+		return allocated;
 
-		allocated = max_blocks;
+	} else if (err)
+		goto fix_extent_len;
+	/*
+	 * The depth, and hence eh & ex might change
+	 * as part of the insert above.
+	 */
+	newdepth = ext_depth(inode);
+	/*
+	 * update the extent length after successful insert of the
+	 * split extent
+	 */
+	orig_ex.ee_len = cpu_to_le16(ee_len -
+					ext4_ext_get_actual_len(ex3));
+	depth = newdepth;
+	ext4_ext_drop_refs(path);
+	path = ext4_ext_find_extent(inode, iblock, path);
+	if (IS_ERR(path)) {
+		err = PTR_ERR(path);
+		goto out;
 	}
+	eh = path[depth].p_hdr;
+	ex = path[depth].p_ext;
+	if (ex2 != &newex)
+		ex2 = ex;
+
+	err = ext4_ext_get_access(handle, inode, path + depth);
+	if (err)
+		goto out;
+
+	allocated = max_blocks;
 	/*
 	 * If there was a change of depth as part of the
 	 * insertion of ex3 above, we need to update the length
Index: linux-2.6.31-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/inode.c
+++ linux-2.6.31-rc4/fs/ext4/inode.c
@@ -3367,8 +3367,6 @@ out:
 	return ret;
 }
 
-/* Maximum number of blocks we map for direct IO at once. */
