From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 version3] Extent overlap bugfix in ext4
Date: Tue, 9 Jan 2007 11:21:20 +0530
Message-ID: <20070109055120.GA5938@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com> <20070103060601.GB5343@amitarora.in.ibm.com> <20070104085407.GC5345@amitarora.in.ibm.com> <m3zm8zdqjn.fsf@bzzz.home.net> <20070104112707.GB15920@amitarora.in.ibm.com> <m3r6ubdnuj.fsf@bzzz.home.net> <20070104172329.GA23612@amitarora.in.ibm.com> <459D4C58.5010502@us.ibm.com> <20070105121335.GA6211@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49800 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXAIFv1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jan 2007 00:51:27 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l095oJC0022953
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jan 2007 00:50:19 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l095pPch454682
	for <linux-ext4@vger.kernel.org>; Mon, 8 Jan 2007 22:51:25 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l095pO27002053
	for <linux-ext4@vger.kernel.org>; Mon, 8 Jan 2007 22:51:25 -0700
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <20070105121335.GA6211@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is the revised version of the patch. This takes care of following
review comments from Mingming and Alex:
 a> Not to use ext4_ext_find_extent() in check_overlap(), since it is an
expensive operation.
 b> Use "unsigned long" for (logical) block numbers everywhere.
 c> Return true/false by check_overlap(), rather than extent pointer or
the block number.
 d> Update the extent length of nexext in check_overlap(), if there is
an overlap detected.


Signed-off-by: Amit Arora <aarora@in.ibm.com>
---
 fs/ext4/extents.c               |   50 ++++++++++++++++++++++++++++++++++++++--
 include/linux/ext4_fs_extents.h |    1 
 2 files changed, 49 insertions(+), 2 deletions(-)

Index: linux-2.6.19.prealloc/fs/ext4/extents.c
===================================================================
--- linux-2.6.19.prealloc.orig/fs/ext4/extents.c
+++ linux-2.6.19.prealloc/fs/ext4/extents.c
@@ -1119,6 +1119,45 @@ ext4_can_extents_be_merged(struct inode 
 }
 
 /*
+ * ext4_ext_check_overlap:
+ * check if a portion of the "newext" extent overlaps with an
+ * existing extent.
+ *
+ * If there is an overlap discovered, it updates the length of the newext
+ * such that there will be no overlap, and then returns 1.
+ * If there is no overlap found, it returns 0.
+ */
+unsigned int ext4_ext_check_overlap(struct inode *inode,
+					struct ext4_extent *newext,
+					struct ext4_ext_path *path)
+{
+	unsigned long b1, b2;
+	unsigned int depth, len1;
+
+	b1 = le32_to_cpu(newext->ee_block);
+	len1 = le16_to_cpu(newext->ee_len);
+	depth = ext_depth(inode);
+	if (!path[depth].p_ext)
+		goto out;
+	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
+
+	/* get the next allocated block if the extent in the path
+	 * is before the requested block(s) */
+	if (b2 < b1) {
+		b2 = ext4_ext_next_allocated_block(path);
+		if (b2 == EXT_MAX_BLOCK)
+			goto out;
+	}
+
+	if (b1 + len1 > b2) {
+		newext->ee_len = cpu_to_le16(b2 - b1);
+		return 1;
+	}
+out:
+	return 0;
+}
+
+/*
  * ext4_ext_insert_extent:
  * tries to merge requsted extent into the existing extent or
  * inserts requested extent as new one into the tree,
@@ -2016,7 +2055,15 @@ int ext4_ext_get_blocks(handle_t *handle
 
 	/* allocate new block */
 	goal = ext4_ext_find_goal(inode, path, iblock);
-	allocated = max_blocks;
+
+	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
+	newex.ee_block = cpu_to_le32(iblock);
+	newex.ee_len = cpu_to_le16(max_blocks);
+	err = ext4_ext_check_overlap(inode, &newex, path);
+	if (err)
+		allocated = le16_to_cpu(newex.ee_len);
+	else
+		allocated = max_blocks;
 	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
 	if (!newblock)
 		goto out2;
@@ -2024,7 +2071,6 @@ int ext4_ext_get_blocks(handle_t *handle
 			goal, newblock, allocated);
 
 	/* try to insert new extent into found leaf and return */
-	newex.ee_block = cpu_to_le32(iblock);
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(allocated);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
Index: linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.19.prealloc.orig/include/linux/ext4_fs_extents.h
+++ linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h
@@ -190,6 +190,7 @@ ext4_ext_invalidate_cache(struct inode *
 
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
+extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
--
Regards,
Amit Arora 
