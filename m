From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 2/6 v5] Ext4 Punch Hole Support: Split Extents
Date: Tue, 19 Apr 2011 00:41:23 -0700
Message-ID: <4DAD3CA3.1040400@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45386 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1DSHl2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 03:41:28 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3J7FLpm011127
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:15:21 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3J7fRKP2703544
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:41:27 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3J7fRkw023069
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:41:27 -0400
Received: from [9.48.114.155] (sig-9-48-114-155.mts.ibm.com [9.48.114.155])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p3J7fQq9023041
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:41:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_split_unwritten_extents routine has been modified
to also handle initialized extents and renamed to
ext4_ext_split_extents.  This routine is used to split
an extent that needs to be partially converted to
an uninitialized extent.

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 6c1f415... a256ba3... M	fs/ext4/ext4.h
:100644 100644 0b186d9... 4d9f06d... M	fs/ext4/extents.c
 fs/ext4/ext4.h    |    5 ++++
 fs/ext4/extents.c |   63 +++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6c1f415..a256ba3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -516,6 +516,11 @@ struct ext4_new_group_data {
 #define EXT4_GET_BLOCKS_PUNCH_OUT_EXT		0x0020
 
 /*
+ * Flags used by ext4_ext_split_extents
+ */
+#define EXT4_SPLIT_EXTENTS_UNWRITTEN	0x0001
+
+/*
  * Flags used by ext4_free_blocks
  */
 #define EXT4_FREE_BLOCKS_METADATA	0x0001
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0b186d9..4d9f06d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -46,6 +46,13 @@
 
 #include <trace/events/ext4.h>
 
+static int ext4_ext_split_extents(handle_t *handle,
+					struct inode *inode,
+					struct ext4_map_blocks *map,
+					struct ext4_ext_path *path,
+					int map_blocks_flags,
+					int split_flags);
+
 static int ext4_ext_truncate_extend_restart(handle_t *handle,
 					    struct inode *inode,
 					    int needed)
@@ -2868,13 +2875,27 @@ fix_extent_len:
  * being filled will be convert to initialized by the end_io callback function
  * via ext4_convert_unwritten_extents().
  *
+ * @handle:           The journal handle
+ * @inode:            The files inode
+ * @map:              Map structure that specifies
+ *                       which blocks need to be split out
+ * @path:             The path to the extent
+ * @map_blocks_flags: Get blocks flags used to insert the new extent
+ * @split_flags:      Optional split extents flag that may be used
+ *
+ *                    EXT4_SPLIT_EXTENTS_UNWRITTEN:
+ *                    Used to split unwriten extents.  The extents
+ *                    that are split will be set to unwritten, or
+ *                    zero'd out if the split fails
+ *
  * Returns the size of uninitialized extent to be written on success.
  */
-static int ext4_split_unwritten_extents(handle_t *handle,
+static int ext4_ext_split_extents(handle_t *handle,
 					struct inode *inode,
 					struct ext4_map_blocks *map,
 					struct ext4_ext_path *path,
-					int flags)
+					int map_blocks_flags,
+					int split_flags)
 {
 	struct ext4_extent *ex, newex, orig_ex;
 	struct ext4_extent *ex1 = NULL;
@@ -2885,8 +2906,9 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	ext4_fsblk_t newblock;
 	int err = 0;
 	int may_zeroout;
+	int uninitialized = 0;
 
-	ext_debug("ext4_split_unwritten_extents: inode %lu, logical"
+	ext_debug("ext4_ext_split_extents: inode %lu, logical"
 		"block %llu, max_blocks %u\n", inode->i_ino,
 		(unsigned long long)map->m_lblk, map->m_len);
 
@@ -2902,6 +2924,9 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	allocated = ee_len - (map->m_lblk - ee_block);
 	newblock = map->m_lblk - ee_block + ext4_ext_pblock(ex);
 
+	uninitialized = split_flags & EXT4_SPLIT_EXTENTS_UNWRITTEN ?
+			1 : ext4_ext_is_uninitialized(ex);
+
 	ex2 = ex;
 	orig_ex.ee_block = ex->ee_block;
 	orig_ex.ee_len   = cpu_to_le16(ee_len);
@@ -2911,7 +2936,8 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	 * It is safe to convert extent to initialized via explicit
 	 * zeroout only if extent is fully insde i_size or new_size.
 	 */
-	may_zeroout = ee_block + ee_len <= eof_block;
+	may_zeroout = split_flags & EXT4_SPLIT_EXTENTS_UNWRITTEN ?
+			ee_block + ee_len <= eof_block : 0;
 
 	/*
  	 * If the uninitialized extent begins at the same logical
@@ -2928,7 +2954,8 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	if (map->m_lblk > ee_block) {
 		ex1 = ex;
 		ex1->ee_len = cpu_to_le16(map->m_lblk - ee_block);
-		ext4_ext_mark_uninitialized(ex1);
+		if (uninitialized)
+			ext4_ext_mark_uninitialized(ex1);
 		ex2 = &newex;
 	}
 	/*
@@ -2945,8 +2972,10 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 		ex3->ee_block = cpu_to_le32(map->m_lblk + map->m_len);
 		ext4_ext_store_pblock(ex3, newblock + map->m_len);
 		ex3->ee_len = cpu_to_le16(allocated - map->m_len);
-		ext4_ext_mark_uninitialized(ex3);
-		err = ext4_ext_insert_extent(handle, inode, path, ex3, flags);
+		if (uninitialized)
+			ext4_ext_mark_uninitialized(ex3);
+		err = ext4_ext_insert_extent(handle, inode, path, ex3,
+			map_blocks_flags);
 		if (err == -ENOSPC && may_zeroout) {
 			err =  ext4_ext_zeroout(inode, &orig_ex);
 			if (err)
@@ -2973,7 +3002,8 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 		 */
 		ee_len -= ext4_ext_get_actual_len(ex3);
 		orig_ex.ee_len = cpu_to_le16(ee_len);
-		may_zeroout = ee_block + ee_len <= eof_block;
+		may_zeroout = split_flags & EXT4_SPLIT_EXTENTS_UNWRITTEN ?
+				ee_block + ee_len <= eof_block : 0;
 
 		depth = newdepth;
 		ext4_ext_drop_refs(path);
@@ -3000,7 +3030,8 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	if (ex1 && ex1 != ex) {
 		ex1 = ex;
 		ex1->ee_len = cpu_to_le16(map->m_lblk - ee_block);
-		ext4_ext_mark_uninitialized(ex1);
+		if (uninitialized)
+			ext4_ext_mark_uninitialized(ex1);
 		ex2 = &newex;
 	}
 	/*
@@ -3010,7 +3041,8 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	ex2->ee_block = cpu_to_le32(map->m_lblk);
 	ext4_ext_store_pblock(ex2, newblock);
 	ex2->ee_len = cpu_to_le16(allocated);
-	ext4_ext_mark_uninitialized(ex2);
+	if (uninitialized)
+		ext4_ext_mark_uninitialized(ex2);
 	if (ex2 != ex)
 		goto insert;
 	/* Mark modified extent as dirty */
@@ -3018,7 +3050,8 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	ext_debug("out here\n");
 	goto out;
 insert:
-	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
+	err = ext4_ext_insert_extent(handle, inode, path, &newex,
+		map_blocks_flags);
 	if (err == -ENOSPC && may_zeroout) {
 		err =  ext4_ext_zeroout(inode, &orig_ex);
 		if (err)
@@ -3040,7 +3073,8 @@ fix_extent_len:
 	ex->ee_block = orig_ex.ee_block;
 	ex->ee_len   = orig_ex.ee_len;
 	ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
-	ext4_ext_mark_uninitialized(ex);
+	if (uninitialized)
+		ext4_ext_mark_uninitialized(ex);
 	ext4_ext_dirty(handle, inode, path + depth);
 	return err;
 }
@@ -3175,8 +3209,9 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 
 	/* get_block() before submit the IO, split the extent */
 	if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
-		ret = ext4_split_unwritten_extents(handle, inode, map,
-						   path, flags);
+		ret = ext4_ext_split_extents(handle, inode, map,
+						path, flags,
+						EXT4_SPLIT_EXTENTS_UNWRITTEN);
 		/*
 		 * Flag the inode(non aio case) or end_io struct (aio case)
 		 * that this IO needs to convertion to written when IO is
-- 
1.7.1

