From: Mingming <cmm@us.ibm.com>
Subject: [PATCH]Show unwritten extent flag in ext4_ext_show_leaf()
Date: Wed, 12 Aug 2009 08:38:21 -0700
Message-ID: <1250091501.18329.16.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:54242 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZHLPic (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2009 11:38:32 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7CFYcne004394
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 09:34:38 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7CFcNKW117266
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 09:38:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7CFcMwF003227
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 09:38:23 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_show_leaf() will display the leaf extents when extent debugging is enabled.
Printing out the unwritten bit is useful for debugging unwritten extent, allow us to see
the unwritten extents vs written extents after unwritten extents split or conversion.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/ext4_extents.h |    3 +--
 fs/ext4/extents.c      |   28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 10 deletions(-)

Index: linux-2.6.31-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.31-rc4/fs/ext4/extents.c
@@ -437,8 +437,9 @@ static void ext4_ext_show_path(struct in
 		  ext_debug("  %d->%llu", le32_to_cpu(path->p_idx->ei_block),
 			    idx_pblock(path->p_idx));
 		} else if (path->p_ext) {
-			ext_debug("  %d:%d:%llu ",
+			ext_debug("  %d:[%d]%d:%llu ",
 				  le32_to_cpu(path->p_ext->ee_block),
+			  	  ext4_ext_is_uninitialized(path->p_ext),
 				  ext4_ext_get_actual_len(path->p_ext),
 				  ext_pblock(path->p_ext));
 		} else
@@ -460,8 +461,11 @@ static void ext4_ext_show_leaf(struct in
 	eh = path[depth].p_hdr;
 	ex = EXT_FIRST_EXTENT(eh);
 
+	ext_debug("Displaying leaf extents for inode %lu\n", inode->i_ino);
+
 	for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ex++) {
-		ext_debug("%d:%d:%llu ", le32_to_cpu(ex->ee_block),
+		ext_debug("%d:[%d]%d:%llu ", le32_to_cpu(ex->ee_block),
+			  ext4_ext_is_uninitialized(ex),
 			  ext4_ext_get_actual_len(ex), ext_pblock(ex));
 	}
 	ext_debug("\n");
@@ -580,9 +584,10 @@ ext4_ext_binsearch(struct inode *inode,
 	}
 
 	path->p_ext = l - 1;
-	ext_debug("  -> %d:%llu:%d ",
+	ext_debug("  -> %d:%llu:[%d]%d ",
 			le32_to_cpu(path->p_ext->ee_block),
 			ext_pblock(path->p_ext),
+			ext4_ext_is_uninitialized(path->p_ext),
 			ext4_ext_get_actual_len(path->p_ext));
 
 #ifdef CHECK_BINSEARCH
@@ -850,9 +855,10 @@ static int ext4_ext_split(handle_t *hand
 	path[depth].p_ext++;
 	while (path[depth].p_ext <=
 			EXT_MAX_EXTENT(path[depth].p_hdr)) {
-		ext_debug("move %d:%llu:%d in new leaf %llu\n",
+		ext_debug("move %d:%llu:[%d]%d in new leaf %llu\n",
 				le32_to_cpu(path[depth].p_ext->ee_block),
 				ext_pblock(path[depth].p_ext),
+				ext4_ext_is_uninitialized(path[depth].p_ext),
 				ext4_ext_get_actual_len(path[depth].p_ext),
 				newblock);
 		/*memmove(ex++, path[depth].p_ext++,
@@ -1580,9 +1586,11 @@ int ext4_ext_insert_extent(handle_t *han
 
 	/* try to insert block into found extent and return */
 	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
-		ext_debug("append %d block to %d:%d (from %llu)\n",
+		ext_debug("append [%d]%d block to %d:[%d]%d (from %llu)\n",
+				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_len(newext),
 				le32_to_cpu(ex->ee_block),
+				ext4_ext_is_uninitialized(ex),
 				ext4_ext_get_actual_len(ex), ext_pblock(ex));
 		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
@@ -1651,9 +1659,10 @@ has_space:
 
 	if (!nearex) {
 		/* there is no extent in this leaf, create first one */
-		ext_debug("first extent in the leaf: %d:%llu:%d\n",
+		ext_debug("first extent in the leaf: %d:%llu:[%d]%d\n",
 				le32_to_cpu(newext->ee_block),
 				ext_pblock(newext),
+				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_len(newext));
 		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
 	} else if (le32_to_cpu(newext->ee_block)
@@ -1663,10 +1672,11 @@ has_space:
 			len = EXT_MAX_EXTENT(eh) - nearex;
 			len = (len - 1) * sizeof(struct ext4_extent);
 			len = len < 0 ? 0 : len;
-			ext_debug("insert %d:%llu:%d after: nearest 0x%p, "
+			ext_debug("insert %d:%llu:[%d]%d after: nearest 0x%p, "
 					"move %d from 0x%p to 0x%p\n",
 					le32_to_cpu(newext->ee_block),
 					ext_pblock(newext),
+					ext4_ext_is_uninitialized(newext),
 					ext4_ext_get_actual_len(newext),
 					nearex, len, nearex + 1, nearex + 2);
 			memmove(nearex + 2, nearex + 1, len);
@@ -1676,10 +1686,11 @@ has_space:
 		BUG_ON(newext->ee_block == nearex->ee_block);
 		len = (EXT_MAX_EXTENT(eh) - nearex) * sizeof(struct ext4_extent);
 		len = len < 0 ? 0 : len;
-		ext_debug("insert %d:%llu:%d before: nearest 0x%p, "
+		ext_debug("insert %d:%llu:[%d]%d before: nearest 0x%p, "
 				"move %d from 0x%p to 0x%p\n",
 				le32_to_cpu(newext->ee_block),
 				ext_pblock(newext),
+				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_len(newext),
 				nearex, len, nearex + 1, nearex + 2);
 		memmove(nearex + 1, nearex, len);
@@ -2743,6 +2754,7 @@ insert:
 	} else if (err)
 		goto fix_extent_len;
 out:
+	ext4_ext_show_leaf(inode, path);
 	return err ? err : allocated;
 
 fix_extent_len:
Index: linux-2.6.31-rc4/fs/ext4/ext4_extents.h
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/ext4_extents.h
+++ linux-2.6.31-rc4/fs/ext4/ext4_extents.h
@@ -43,8 +43,7 @@
 #define CHECK_BINSEARCH__
 
 /*
- * If EXT_DEBUG is defined you can use the 'extdebug' mount option
- * to get lots of info about what's going on.
+ * Turn on EXT_DEBUG to get lots of info about extents operations.
  */
 #define EXT_DEBUG__
 #ifdef EXT_DEBUG


