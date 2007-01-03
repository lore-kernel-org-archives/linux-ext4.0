From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Tue, 02 Jan 2007 17:35:28 -0800
Message-ID: <1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:43307 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbXACBfd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jan 2007 20:35:33 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l031ZUlE012965
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 20:35:30 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l031ZUZQ159088
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 18:35:30 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l031ZToE004862
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 18:35:30 -0700
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070102090909.GA20503@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-01-02 at 14:39 +0530, Amit K. Arora wrote:

> This problem was first sighted while stress testing (using modified
> fsx-linux stress test) persistent preallocation patches that I posted
> earlier.  Though I am not able to reproduce this bug (extent overlap)
> without the persistent preallocation patches (because a write through a
> hole results in get_blocks() of a single block at a time), but I think
> that it is an independant problem and should be solved with a separate
> patch. Hence this patch.
> 

Ah...without preallocation, I guess the problem still will be uncovered
when we have delayed allocation, that makes multiple block allocation
across hole possible.

>  /*
> + * ext4_ext_check_overlap:
> + * check if a portion of the "newext" extent overlaps with an
> + * existing extent.
> + */
> +struct ext4_extent * ext4_ext_check_overlap(struct inode *inode,
> +					struct ext4_extent *newext)
> +{
> +	struct ext4_ext_path *path;
> +	struct ext4_extent *ex;
> +	unsigned int depth, b1, b2, len1;
> +
> +	b1 = le32_to_cpu(newext->ee_block);
> +	len1 = le16_to_cpu(newext->ee_len);
> +	path = ext4_ext_find_extent(inode, b1, NULL);
> +	if (IS_ERR(path))
> +		return NULL;
> +
> +	depth = ext_depth(inode);
> +	ex = path[depth].p_ext;
> +	if (!ex)
> +		return NULL;
> +

I am confused, when we come here, isn't we confirmed that we need block
allocation, thus there is no extent start from b1?

> +	b2 = ext4_ext_next_allocated_block(path);
> +	if (b2 == EXT_MAX_BLOCK)
> +
> 		return NULL;
> +	path = ext4_ext_find_extent(inode, b2, path);
> +	if (IS_ERR(path))
> +		return NULL;
> +	BUG_ON(path[depth].p_hdr == NULL);
> +	ex = path[depth].p_ext;
> +

How useful to have the next extent pointer?It seems only used to print
out warning messages. I am a little concerned about the expensive
ext4_ext_find_extent(). After all ext4_ext_next_allocated_block()
already returns the start block of next extent, isn't it?

> +	if (b1 + len1 > b2)
> +		return ex;
> +
> +	return NULL;
> +}
> +
> +/*
>   * ext4_ext_insert_extent:
>   * tries to merge requsted extent into the existing extent or
>   * inserts requested extent as new one into the tree,
> @@ -1129,7 +1167,7 @@
>  				struct ext4_extent *newext)
>  {
>  	struct ext4_extent_header * eh;
> -	struct ext4_extent *ex, *fex;
> +	struct ext4_extent *ex, *fex, *rex;
>  	struct ext4_extent *nearex; /* nearest extent */
>  	struct ext4_ext_path *npath = NULL;
>  	int depth, len, err, next;
> @@ -1139,6 +1177,18 @@
>  	ex = path[depth].p_ext;
>  	BUG_ON(path[depth].p_hdr == NULL);
> 
> +	/* check for overlap */
> +	rex = ext4_ext_check_overlap(inode, newext);
> +	if (rex) {
> +		printk(KERN_ERR "ERROR: ex=%u/%u overlaps newext=%u/%u\n",
> +				le32_to_cpu(rex->ee_block),
> +				le16_to_cpu(rex->ee_len),
> +				le32_to_cpu(newext->ee_block),
> +				le16_to_cpu(newext->ee_len));
> +		ext4_ext_show_leaf(inode, path);
> +		BUG();
> +	}
> +
>  	/* try to insert block into found extent and return */
>  	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
>  		ext_debug("append %d block to %d:%d (from %llu)\n",
> @@ -1921,7 +1971,7 @@
>  			int create, int extend_disksize)
>  {
>  	struct ext4_ext_path *path = NULL;
> -	struct ext4_extent newex, *ex;
> +	struct ext4_extent newex, *ex, *ex2;
>  	ext4_fsblk_t goal, newblock;
>  	int err = 0, depth;
>  	unsigned long allocated = 0;
> @@ -1984,6 +2034,10 @@
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
> @@ -2016,7 +2070,17 @@
> 
>  	/* allocate new block */
>  	goal = ext4_ext_find_goal(inode, path, iblock);
> -	allocated = max_blocks;
> +
> +	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
> +	newex.ee_block = cpu_to_le32(iblock);
> +	if (!allocated) {
> +		newex.ee_len = cpu_to_le16(max_blocks);
> +		ex2 = ext4_ext_check_overlap(inode, &newex);
> +		if (ex2)
> +			allocated = le32_to_cpu(ex2->ee_block) - iblock;
> +		else
> +			allocated = max_blocks;
> +	}
>  	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
>  	if (!newblock)
>  		goto out2;
> @@ -2024,7 +2088,6 @@
>  			goal, newblock, allocated);
> 
>  	/* try to insert new extent into found leaf and return */
> -	newex.ee_block = cpu_to_le32(iblock);
>  	ext4_ext_store_pblock(&newex, newblock);
>  	newex.ee_len = cpu_to_le16(allocated);
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex);
> Index: linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h
> ===================================================================
> --- linux-2.6.19.prealloc.orig/include/linux/ext4_fs_extents.h	2007-01-02 14:21:57.000000000 +0530
> +++ linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h	2007-01-02 14:22:00.000000000 +0530
> @@ -190,6 +190,7 @@
> 
>  extern int ext4_extent_tree_init(handle_t *, struct inode *);
>  extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
> +extern struct ext4_extent * ext4_ext_check_overlap(struct inode *, struct ext4_extent *);
>  extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
>  extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
>  extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
> --
> Regards,
> Amit Arora
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
