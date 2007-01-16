From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Resubmit][PATCH 1/1] Extent overlap bugfix in ext4
Date: Tue, 16 Jan 2007 10:19:16 -0800
Message-ID: <45AD1724.3040903@us.ibm.com>
References: <20070116101316.GA1763@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:56298 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXAPSTW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2007 13:19:22 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0GIJJu4023290
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 13:19:19 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0GIJJEh512798
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 11:19:19 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0GIJJtm018100
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 11:19:19 -0700
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070116101316.GA1763@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Amit K. Arora wrote:
> Note: This patch is being resubmitted as part of the recall of all the
> patches for ext4. It uses 2.6.20-rc5 version as the base.
> 
> Problem Description:
> -------------------
> The ext4_ext_get_blocks() and ext4_ext_insert_extent() routines do not
> have a complete check for extent overlap, when a new extent needs to be
> inserted in an inode. With the current implementation, an overlap is
> possible when the new extent being inserted has ee_block that is not
> part of any of the existing extents, but the tail/center portion of this
> new extent _is_. This is possible only when we are writing/preallocating
> blocks across a hole.
> Though this problem was discovered while stress testing persistent
> preallocation patches (using modified fsx-linux); this essentially is an
> independent problem and should be fixed by a separate patch. Hence this
> fix.
> 
> The Fix:
> -------
> The suggested patch fixes this by having a check in get_blocks() for
> finding if the new extent overlaps with an existing one. If it does, the
> length of the new extent is modified such that the overlap does not
> happen at all.

Looks good.
You could add my name to signed off.

Mingming


> Other option discussed:
> ----------------------
> The other option discussed was to not to use ext4_ext_get_blocks() for
> persistent preallocation, and use ext4_ext_walk_space() with some helper
> function instead. This was considered because walk_space() already does
> a complete check for overlap and hence we can avoid duplication of this
> part of the logic in get_blocks(). But, again, there will be a
> duplication of code in the new helper function that may be required for
> this (like, calling ext4_new_blocks() and ext4_ext_insert_extent()).
> 
> Updates from the original (first) version:
> -----------------------------------------
> This patch takes care of following review comments from Mingming, Alex
> and Suparna:
> (a) Not to use ext4_ext_find_extent() in check_overlap(), since it is an
> expensive operation.
> (b) Use "unsigned long" for (logical) block numbers everywhere.
> (c) Return true/false by check_overlap(), rather than extent pointer or
> the block number.
> (d) Update the length of the new extent in check_overlap(), if there is
> an overlap detected.
> (e) No need to have a check in insert_extent() (i.e. no BUG_ON required)
> 
> 
> Here is the patch:
> 
> Signed-off-by: Amit Arora <aarora@in.ibm.com>
> ---
>  fs/ext4/extents.c               |   50 ++++++++++++++++++++++++++++++++++++++--
>  include/linux/ext4_fs_extents.h |    1
>  2 files changed, 49 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.20-rc5/fs/ext4/extents.c
> ===================================================================
> --- linux-2.6.20-rc5.orig/fs/ext4/extents.c
> +++ linux-2.6.20-rc5/fs/ext4/extents.c
> @@ -1129,6 +1129,45 @@ ext4_can_extents_be_merged(struct inode
>  }
> 
>  /*
> + * ext4_ext_check_overlap:
> + * check if a portion of the "newext" extent overlaps with an
> + * existing extent.
> + *
> + * If there is an overlap discovered, it updates the length of the newext
> + * such that there will be no overlap, and then returns 1.
> + * If there is no overlap found, it returns 0.
> + */
> +unsigned int ext4_ext_check_overlap(struct inode *inode,
> +					struct ext4_extent *newext,
> +					struct ext4_ext_path *path)
> +{
> +	unsigned long b1, b2;
> +	unsigned int depth, len1;
> +
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
> +	if (b1 + len1 > b2) {
> +		newext->ee_len = cpu_to_le16(b2 - b1);
> +		return 1;
> +	}
> +out:
> +	return 0;
> +}
> +
> +/*
>   * ext4_ext_insert_extent:
>   * tries to merge requsted extent into the existing extent or
>   * inserts requested extent as new one into the tree,
> @@ -2032,7 +2071,15 @@ int ext4_ext_get_blocks(handle_t *handle
> 
>  	/* allocate new block */
>  	goal = ext4_ext_find_goal(inode, path, iblock);
> -	allocated = max_blocks;
> +
> +	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
> +	newex.ee_block = cpu_to_le32(iblock);
> +	newex.ee_len = cpu_to_le16(max_blocks);
> +	err = ext4_ext_check_overlap(inode, &newex, path);
> +	if (err)
> +		allocated = le16_to_cpu(newex.ee_len);
> +	else
> +		allocated = max_blocks;
>  	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
>  	if (!newblock)
>  		goto out2;
> @@ -2040,7 +2087,6 @@ int ext4_ext_get_blocks(handle_t *handle
>  			goal, newblock, allocated);
> 
>  	/* try to insert new extent into found leaf and return */
> -	newex.ee_block = cpu_to_le32(iblock);
>  	ext4_ext_store_pblock(&newex, newblock);
>  	newex.ee_len = cpu_to_le16(allocated);
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex);
> Index: linux-2.6.20-rc5/include/linux/ext4_fs_extents.h
> ===================================================================
> --- linux-2.6.20-rc5.orig/include/linux/ext4_fs_extents.h
> +++ linux-2.6.20-rc5/include/linux/ext4_fs_extents.h
> @@ -190,6 +190,7 @@ ext4_ext_invalidate_cache(struct inode *
> 
>  extern int ext4_extent_tree_init(handle_t *, struct inode *);
>  extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
> +extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
>  extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
>  extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
>  extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
> --
> Regards,
> Amit Arora
