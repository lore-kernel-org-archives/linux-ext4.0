From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 04 Jan 2007 10:50:00 -0800
Message-ID: <459D4C58.5010502@us.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com>	<1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>	<20070103060601.GB5343@amitarora.in.ibm.com>	<20070104085407.GC5345@amitarora.in.ibm.com> <m3zm8zdqjn.fsf@bzzz.home.net>	<20070104112707.GB15920@amitarora.in.ibm.com> <m3r6ubdnuj.fsf@bzzz.home.net> <20070104172329.GA23612@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:42654 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXADSuK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jan 2007 13:50:10 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l04Io2c2016602
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 13:50:02 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l04Io2d7378344
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 11:50:02 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l04Io1wo020516
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 11:50:02 -0700
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070104172329.GA23612@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, Amit,

Have you looked at ext4_ext_walk_space()? It calculate the right extent 
length to allocate to avoid overlap before calling block allocation 
callback function is called.

Amit K. Arora wrote:
>  /*
> + * ext4_ext_check_overlap:
> + * check if a portion of the "newext" extent overlaps with an
> + * existing extent.
> + *
> + * If there is an overlap discovered, it returns the (logical) block
> + * number of the first block in the next extent (the existing extent
> + * which covers few of the new requested blocks)
> + * If there is no overlap found, it returns 0.
> + */

What if the start logical block of the exisitng extent is 0 and there is 
overlap? I think that is possible. For example, the exisitng extent is 
(0,100) and you want to insert new extent (0,500), this will certainly 
fail to report the overlap.


> +unsigned int ext4_ext_check_overlap(struct inode *inode,

We shall be consistant with other data type used for logical block, 
right now is unsigned long. Probably replace that with ext4_fsblk_t type 
when that cleanup is introduced.

> +					struct ext4_extent *newext,
> +					struct ext4_ext_path *path)
> +{
> +	unsigned int depth, b1, len1, b2;
> +
unsigned long type for b1 and b2.

> +	b1 = le32_to_cpu(newext->ee_block);
> +	len1 = le16_to_cpu(newext->ee_len);
> +	depth = ext_depth(inode);
> +	if (!path[depth].p_ext)
> +		goto out;
> +	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
> +
> +	/* get the next allocated block if the extent in the path
> +	 * is before the requested block(s) */
> +	if (b2 < b1) {
> +		b2 = ext4_ext_next_allocated_block(path);
> +		if (b2 == EXT_MAX_BLOCK)
> +			goto out;
> +	}
> +
> +	if (b1 + len1 > b2)
> +		return b2;
> +out:
> +	return 0;
> +}
> +

Since this overlap check function is called inside 
ext4_ext_insert_extent(), I think this function should check for all 
kinds of overlaps. Here you only check if the new extent is overlap with 
the next extent. Looking at ext4_ext_walk_space(), there are total three 
kinds of overlaps:
1) righ port of new extent overlap with path->p_ext,
2) left port of new extent overlap with path->p_ext
2) right port of new extent overlap with next extent

I think we are almost repeating the same logic in ext4_ext_walk_space() 
here.

> +/*
>   * ext4_ext_insert_extent:
>   * tries to merge requsted extent into the existing extent or
>   * inserts requested extent as new one into the tree,
> @@ -1133,12 +1170,25 @@ int ext4_ext_insert_extent(handle_t *han
>  	struct ext4_extent *nearex; /* nearest extent */
>  	struct ext4_ext_path *npath = NULL;
>  	int depth, len, err, next;
> +	unsigned int oblock;
>
unsigned long type for oblock

>  	BUG_ON(newext->ee_len == 0);
>  	depth = ext_depth(inode);
>  	ex = path[depth].p_ext;
>  	BUG_ON(path[depth].p_hdr == NULL);
> 
> +	/* check for overlap */
> +	oblock = ext4_ext_check_overlap(inode, newext, path);
> +	if (oblock) {
> +		printk(KERN_ERR "ERROR: newext=%u/%u overlaps with an "
> +				"existing extent, which starts with %u\n",
> +				le32_to_cpu(newext->ee_block),
> +				le16_to_cpu(newext->ee_len),
> +				oblock);
> +		ext4_ext_show_leaf(inode, path);
> +		BUG();
> +	}

How about return true or false from ext4_ext_check_overlap()? Inside 
that function put the correct new extent logical block number and extent 
length that safe to insert? Afterall the returning oblock is used in 
ext4_ext_get_blocks() to calculate the safe extent to allocate.

> +
>  	/* try to insert block into found extent and return */
>  	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
>  		ext_debug("append %d block to %d:%d (from %llu)\n",
> @@ -1984,6 +2034,10 @@ int ext4_ext_get_blocks(handle_t *handle
>  		 */
>  		if (ee_len > EXT_MAX_LEN)
>  			goto out2;
> +
> +		if (iblock < ee_block && iblock + max_blocks >= ee_block)
> +			allocated = ee_block - iblock;
> +
>  		/* if found extent covers block, simply return it */
>  	        if (iblock >= ee_block && iblock < ee_block + ee_len) {
>  			newblock = iblock - ee_block + ee_start;

Here I realize that the way that ext4_ext_get_blocks() handles the 
requested extent has hole on the right side is: simply returns the left 
port of the extent which already has blocks allocated. This is actually 
what non_extent get_blocks does also. caller of get_blocks() including 
preallocation code in ioctl will continue calling get_blocks to allocate 
blocks for the hole.

Probably we shall make this clear in the comment.
> @@ -2016,7 +2070,17 @@ int ext4_ext_get_blocks(handle_t *handle
> 
>  	/* allocate new block */
>  	goal = ext4_ext_find_goal(inode, path, iblock);
> -	allocated = max_blocks;
> +
> +	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
> +	newex.ee_block = cpu_to_le32(iblock);
> +	if (!allocated) {
> +		newex.ee_len = cpu_to_le16(max_blocks);
> +		allocated = ext4_ext_check_overlap(inode, &newex, path);
> +		if (allocated)
> +			allocated = allocated - iblock;
> +		else
> +			allocated = max_blocks;
> +	}
>  	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
>  	if (!newblock)
>  		goto out2;
> @@ -2024,7 +2088,6 @@ int ext4_ext_get_blocks(handle_t *handle
>  			goal, newblock, allocated);
> 
>  	/* try to insert new extent into found leaf and return */
> -	newex.ee_block = cpu_to_le32(iblock);
>  	ext4_ext_store_pblock(&newex, newblock);
>  	newex.ee_len = cpu_to_le16(allocated);
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex);
> Index: linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h
> ===================================================================
> --- linux-2.6.19.prealloc.orig/include/linux/ext4_fs_extents.h
> +++ linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h
> @@ -190,6 +190,7 @@ ext4_ext_invalidate_cache(struct inode *
> 
>  extern int ext4_extent_tree_init(handle_t *, struct inode *);
>  extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
> +extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
>  extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
>  extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
>  extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
> 
