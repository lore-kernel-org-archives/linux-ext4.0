From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Fri, 5 Jan 2007 17:43:35 +0530
Message-ID: <20070105121335.GA6211@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com> <20070103060601.GB5343@amitarora.in.ibm.com> <20070104085407.GC5345@amitarora.in.ibm.com> <m3zm8zdqjn.fsf@bzzz.home.net> <20070104112707.GB15920@amitarora.in.ibm.com> <m3r6ubdnuj.fsf@bzzz.home.net> <20070104172329.GA23612@amitarora.in.ibm.com> <459D4C58.5010502@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46493 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161075AbXAEMNk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jan 2007 07:13:40 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l05CDd6J007674
	for <linux-ext4@vger.kernel.org>; Fri, 5 Jan 2007 07:13:39 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l05CDdhp220110
	for <linux-ext4@vger.kernel.org>; Fri, 5 Jan 2007 07:13:39 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l05CDcLD004420
	for <linux-ext4@vger.kernel.org>; Fri, 5 Jan 2007 07:13:39 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <459D4C58.5010502@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 04, 2007 at 10:50:00AM -0800, Mingming Cao wrote:
> Hi, Amit,
Hi Mingming,
 
> Have you looked at ext4_ext_walk_space()? It calculate the right extent
> length to allocate to avoid overlap before calling block allocation
> callback function is called.
Yes. More on this below...
> 
> Amit K. Arora wrote:
> > /*
> >+ * ext4_ext_check_overlap:
> >+ * check if a portion of the "newext" extent overlaps with an
> >+ * existing extent.
> >+ *
> >+ * If there is an overlap discovered, it returns the (logical) block
> >+ * number of the first block in the next extent (the existing extent
> >+ * which covers few of the new requested blocks)
> >+ * If there is no overlap found, it returns 0.
> >+ */
> 
> What if the start logical block of the exisitng extent is 0 and there is
> overlap? I think that is possible. For example, the exisitng extent is
> (0,100) and you want to insert new extent (0,500), this will certainly
> fail to report the overlap.
As Alex mentioned, this case is taken care of by ext4_ext_get_blocks().
 
> >+unsigned int ext4_ext_check_overlap(struct inode *inode,
> 
> We shall be consistant with other data type used for logical block,
> right now is unsigned long. Probably replace that with ext4_fsblk_t type
> when that cleanup is introduced.
Ok, will use "unsigned long".

> 
> >+					struct ext4_extent *newext,
> >+					struct ext4_ext_path *path)
> >+{
> >+	unsigned int depth, b1, len1, b2;
> >+
> unsigned long type for b1 and b2.
Ok.
> 
> >+	b1 = le32_to_cpu(newext->ee_block);
> >+	len1 = le16_to_cpu(newext->ee_len);
> >+	depth = ext_depth(inode);
> >+	if (!path[depth].p_ext)
> >+		goto out;
> >+	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
> >+
> >+	/* get the next allocated block if the extent in the path
> >+	 * is before the requested block(s) */
> >+	if (b2 < b1) {
> >+		b2 = ext4_ext_next_allocated_block(path);
> >+		if (b2 == EXT_MAX_BLOCK)
> >+			goto out;
> >+	}
> >+
> >+	if (b1 + len1 > b2)
> >+		return b2;
> >+out:
> >+	return 0;
> >+}
> >+
> 
> Since this overlap check function is called inside
> ext4_ext_insert_extent(), I think this function should check for all
> kinds of overlaps. Here you only check if the new extent is overlap with
> the next extent. Looking at ext4_ext_walk_space(), there are total three
> kinds of overlaps:
> 1) righ port of new extent overlap with path->p_ext,
> 2) left port of new extent overlap with path->p_ext
> 3) right port of new extent overlap with next extent

I think all the three conditions above are being checked. The second
condition is taken care of by the ext4_ext_get_blocks(). And the rest
two checks are being made in the ext4_ext_check_overlap().
check_overlap() first checks if the right portion of the new extent
overlaps with the path->p_ext. If not, then only it checks for an
overlap with the next extent.

> 
> I think we are almost repeating the same logic in ext4_ext_walk_space()
> here.

I understand that some portion of the logic in ext4_ext_walk_space() is
being duplicated here in check_overlap(). But, if we have to use
walk_space(), we will need to write a new helper function which will
result in some duplicate code in get_blocks() and
ext4_wb_handle_extent() (like, calling ext4_new_blocks and then
insert_extent()) as well. Unless, ext4_wb_handle_extent() is modified to match
our requirement of persistent preallocation. I am not sure how
complicated and worth that may be.

> 
> >+/*
> >  * ext4_ext_insert_extent:
> >  * tries to merge requsted extent into the existing extent or
> >  * inserts requested extent as new one into the tree,
> >@@ -1133,12 +1170,25 @@ int ext4_ext_insert_extent(handle_t *han
> > 	struct ext4_extent *nearex; /* nearest extent */
> > 	struct ext4_ext_path *npath = NULL;
> > 	int depth, len, err, next;
> >+	unsigned int oblock;
> >
> unsigned long type for oblock
Ok.
> 
> > 	BUG_ON(newext->ee_len == 0);
> > 	depth = ext_depth(inode);
> > 	ex = path[depth].p_ext;
> > 	BUG_ON(path[depth].p_hdr == NULL);
> >
> >+	/* check for overlap */
> >+	oblock = ext4_ext_check_overlap(inode, newext, path);
> >+	if (oblock) {
> >+		printk(KERN_ERR "ERROR: newext=%u/%u overlaps with an "
> >+				"existing extent, which starts with %u\n",
> >+				le32_to_cpu(newext->ee_block),
> >+				le16_to_cpu(newext->ee_len),
> >+				oblock);
> >+		ext4_ext_show_leaf(inode, path);
> >+		BUG();
> >+	}
> 
> How about return true or false from ext4_ext_check_overlap()? Inside
> that function put the correct new extent logical block number and extent
> length that safe to insert? Afterall the returning oblock is used in
> ext4_ext_get_blocks() to calculate the safe extent to allocate.
Ok.
> 
> >+
> > 	/* try to insert block into found extent and return */
> > 	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
> > 		ext_debug("append %d block to %d:%d (from %llu)\n",
> >@@ -1984,6 +2034,10 @@ int ext4_ext_get_blocks(handle_t *handle
> > 		 */
> > 		if (ee_len > EXT_MAX_LEN)
> > 			goto out2;
> >+
> >+		if (iblock < ee_block && iblock + max_blocks >= ee_block)
> >+			allocated = ee_block - iblock;
> >+
> > 		/* if found extent covers block, simply return it */
> > 	        if (iblock >= ee_block && iblock < ee_block + ee_len) {
> > 			newblock = iblock - ee_block + ee_start;
> 
> Here I realize that the way that ext4_ext_get_blocks() handles the
> requested extent has hole on the right side is: simply returns the left
> port of the extent which already has blocks allocated. This is actually
> what non_extent get_blocks does also. caller of get_blocks() including
> preallocation code in ioctl will continue calling get_blocks to allocate
> blocks for the hole.
> 
> Probably we shall make this clear in the comment.
Yes, a comment will be nice here. Not sure if that should be added as part
of this patch, since the required comment is generic and not related to
this bug. What do you think ?

Thanks!
--
Regards,
Amit Arora
