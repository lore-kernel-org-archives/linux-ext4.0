From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 4 Jan 2007 14:24:07 +0530
Message-ID: <20070104085407.GC5345@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com> <20070103060601.GB5343@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:40661 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXADIyP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jan 2007 03:54:15 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l048sDJP000826
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 03:54:13 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l048sDQ2533424
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 01:54:13 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l048sCCa009149
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 01:54:13 -0700
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <20070103060601.GB5343@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 03, 2007 at 11:36:01AM +0530, Amit K. Arora wrote:
> >
> > > +	b2 = ext4_ext_next_allocated_block(path);
> > > +	if (b2 == EXT_MAX_BLOCK)
> > > +
> > > 		return NULL;
> > > +	path = ext4_ext_find_extent(inode, b2, path);
> > > +	if (IS_ERR(path))
> > > +		return NULL;
> > > +	BUG_ON(path[depth].p_hdr == NULL);
> > > +	ex = path[depth].p_ext;
> > > +
> >
> > How useful to have the next extent pointer?It seems only used to print
> > out warning messages. I am a little concerned about the expensive
> > ext4_ext_find_extent(). After all ext4_ext_next_allocated_block()
> > already returns the start block of next extent, isn't it?
> 
> Ok, agreed. Will get rid of this extra code.

Here is the new patch. Please review.
Thanks!


Signed-off-by: Amit Arora <aarora@in.ibm.com>

---
 fs/ext4/extents.c               |   71 ++++++++++++++++++++++++++++++++++++++--
 include/linux/ext4_fs_extents.h |    1 
 2 files changed, 70 insertions(+), 2 deletions(-)

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
+ * Returns 1 if it finds an extent which may overlap with the
+ * new extent, and puts the logical block number of the first block
+ * of this extent at a location pointed by the "block" argument.
+ * If there is no such extent, it returns 0.
+ * Returns errno, incase of an error.
+ */
+int ext4_ext_check_overlap(struct inode *inode,
+					struct ext4_extent *newext,
+					unsigned long *block)
+{
+	struct ext4_ext_path *path;
+	unsigned int depth, b1, len1;
+	int ret = 0;
+
+	b1 = le32_to_cpu(newext->ee_block);
+	len1 = le16_to_cpu(newext->ee_len);
+	path = ext4_ext_find_extent(inode, b1, NULL);
+	if (IS_ERR(path)) {
+		ret = PTR_ERR(path);
+		goto out;
+	}
+	depth = ext_depth(inode);
+	BUG_ON(path[depth].p_ext == NULL && depth != 0);
+
+	*block = ext4_ext_next_allocated_block(path);
+	if (*block == EXT_MAX_BLOCK)
+		goto out;
+
+	if (b1 + len1 > *block)
+		ret = 1;
+out:
+	return ret;
+}
+
+/*
  * ext4_ext_insert_extent:
  * tries to merge requsted extent into the existing extent or
  * inserts requested extent as new one into the tree,
@@ -1133,12 +1172,25 @@ int ext4_ext_insert_extent(handle_t *han
 	struct ext4_extent *nearex; /* nearest extent */
 	struct ext4_ext_path *npath = NULL;
 	int depth, len, err, next;
+	unsigned long oblock;
 
 	BUG_ON(newext->ee_len == 0);
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	BUG_ON(path[depth].p_hdr == NULL);
 
+	/* check for overlap */
+	err = ext4_ext_check_overlap(inode, newext, &oblock);
+	if (err > 0) {
+		printk(KERN_ERR "ERROR: newext=%u/%u overlaps with an "
+				"existing extent, which starts with %lu\n",
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
@@ -1984,6 +2036,10 @@ int ext4_ext_get_blocks(handle_t *handle
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
@@ -2016,7 +2072,19 @@ int ext4_ext_get_blocks(handle_t *handle
 
 	/* allocate new block */
 	goal = ext4_ext_find_goal(inode, path, iblock);
-	allocated = max_blocks;
+
+	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
+	newex.ee_block = cpu_to_le32(iblock);
+	if (!allocated) {
+		newex.ee_len = cpu_to_le16(max_blocks);
+		err = ext4_ext_check_overlap(inode, &newex, &allocated);
+		if (err < 0)
+			goto out2;
+		else if (!err)
+			allocated = max_blocks;
+		else
+			allocated = allocated - iblock;
+	}
 	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
 	if (!newblock)
 		goto out2;
@@ -2024,7 +2092,6 @@ int ext4_ext_get_blocks(handle_t *handle
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
+extern int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, unsigned long *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
--
Regards,
Amit Arora
