From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 4 Jan 2007 22:53:29 +0530
Message-ID: <20070104172329.GA23612@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com> <20070103060601.GB5343@amitarora.in.ibm.com> <20070104085407.GC5345@amitarora.in.ibm.com> <m3zm8zdqjn.fsf@bzzz.home.net> <20070104112707.GB15920@amitarora.in.ibm.com> <m3r6ubdnuj.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:57438 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045AbXADRXo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jan 2007 12:23:44 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l04HNd8x018816
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 12:23:39 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l04HNdLK412646
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 10:23:39 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l04HNcE4008485
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 10:23:39 -0700
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m3r6ubdnuj.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 04, 2007 at 02:37:40PM +0300, Alex Tomas (AT) wrote:
> >>>>> Amit K Arora (AKA) writes:
>  AT> I'm also not sure we need ext4_ext_find_extent() here.
>    AKA> Do you mean ext4_ext_next_allocated_block() above ? We anyhow have to
>    AKA> call find_extent() to get the possible neighbouring extent.
>      AT> no, I exactly meant ext4_ext_find_extent(). it's expensive
>      AT> compared to ext4_ext_next_allocated_block().
>      AT> and if I understand right, you don't need whole extent, you
>      AT> just need to know next allocated block, which can be retrieved
>      AT> from index even. this is what ext4_ext_next_allocated_block() does.

Ok, Thanks!
Here is the updated patch.


Signed-off-by: Amit Arora <aarora@in.ibm.com>

---
 fs/ext4/extents.c               |   67 ++++++++++++++++++++++++++++++++++++++--
 include/linux/ext4_fs_extents.h |    1 
 2 files changed, 66 insertions(+), 2 deletions(-)

Index: linux-2.6.19.prealloc/fs/ext4/extents.c
===================================================================
--- linux-2.6.19.prealloc.orig/fs/ext4/extents.c
+++ linux-2.6.19.prealloc/fs/ext4/extents.c
@@ -1119,6 +1119,43 @@ ext4_can_extents_be_merged(struct inode 
 }
 
 /*
+ * ext4_ext_check_overlap:
+ * check if a portion of the "newext" extent overlaps with an
+ * existing extent.
+ *
+ * If there is an overlap discovered, it returns the (logical) block
+ * number of the first block in the next extent (the existing extent
+ * which covers few of the new requested blocks)
+ * If there is no overlap found, it returns 0.
+ */
+unsigned int ext4_ext_check_overlap(struct inode *inode,
+					struct ext4_extent *newext,
+					struct ext4_ext_path *path)
+{
+	unsigned int depth, b1, len1, b2;
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
+	if (b1 + len1 > b2)
+		return b2;
+out:
+	return 0;
+}
+
+/*
  * ext4_ext_insert_extent:
  * tries to merge requsted extent into the existing extent or
  * inserts requested extent as new one into the tree,
@@ -1133,12 +1170,25 @@ int ext4_ext_insert_extent(handle_t *han
 	struct ext4_extent *nearex; /* nearest extent */
 	struct ext4_ext_path *npath = NULL;
 	int depth, len, err, next;
+	unsigned int oblock;
 
 	BUG_ON(newext->ee_len == 0);
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	BUG_ON(path[depth].p_hdr == NULL);
 
+	/* check for overlap */
+	oblock = ext4_ext_check_overlap(inode, newext, path);
+	if (oblock) {
+		printk(KERN_ERR "ERROR: newext=%u/%u overlaps with an "
+				"existing extent, which starts with %u\n",
+				le32_to_cpu(newext->ee_block),
+				le16_to_cpu(newext->ee_len),
+				oblock);
+		ext4_ext_show_leaf(inode, path);
+		BUG();
+	}
+
 	/* try to insert block into found extent and return */
 	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
 		ext_debug("append %d block to %d:%d (from %llu)\n",
@@ -1984,6 +2034,10 @@ int ext4_ext_get_blocks(handle_t *handle
 		 */
 		if (ee_len > EXT_MAX_LEN)
 			goto out2;
+
+		if (iblock < ee_block && iblock + max_blocks >= ee_block)
+			allocated = ee_block - iblock;
+
 		/* if found extent covers block, simply return it */
 	        if (iblock >= ee_block && iblock < ee_block + ee_len) {
 			newblock = iblock - ee_block + ee_start;
@@ -2016,7 +2070,17 @@ int ext4_ext_get_blocks(handle_t *handle
 
 	/* allocate new block */
 	goal = ext4_ext_find_goal(inode, path, iblock);
-	allocated = max_blocks;
+
+	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
+	newex.ee_block = cpu_to_le32(iblock);
+	if (!allocated) {
+		newex.ee_len = cpu_to_le16(max_blocks);
+		allocated = ext4_ext_check_overlap(inode, &newex, path);
+		if (allocated)
+			allocated = allocated - iblock;
+		else
+			allocated = max_blocks;
+	}
 	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
 	if (!newblock)
 		goto out2;
@@ -2024,7 +2088,6 @@ int ext4_ext_get_blocks(handle_t *handle
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
