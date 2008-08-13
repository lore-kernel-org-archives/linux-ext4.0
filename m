From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6 ]Ext4: journal credits reservation fixes for extent
	file writepage
Date: Wed, 13 Aug 2008 14:07:49 +0530
Message-ID: <20080813083749.GB6439@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop> <1218558473.6766.44.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:35673 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbYHMIng (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 04:43:36 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7D8g0ea031842
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 18:42:00 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7D8c4W02486484
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 18:38:04 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7D8c4xP002750
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 18:38:04 +1000
Content-Disposition: inline
In-Reply-To: <1218558473.6766.44.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2008 at 09:27:53AM -0700, Mingming Cao wrote:

....
....

> 
>  /*
> - * ext4_ext_calc_credits_for_insert:
> - * This routine returns max. credits that the extent tree can consume.
> - * It should be OK for low-performance paths like ->writepage()
> - * To allow many writing processes to fit into a single transaction,
> - * the caller should calculate credits under i_data_sem and
> - * pass the actual path.
> + * ext4_ext_calc_credits_for_single_extent:
> + * This routine returns max. credits that needed to insert an extent
> + * to the extent tree.
> + * When pass the actual path, the caller should calculate credits
> + * under i_data_sem.
>   */
> -int ext4_ext_calc_credits_for_insert(struct inode *inode,
> +int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
>  						struct ext4_ext_path *path)
>  {
> -	int depth, needed;
> +	int depth = ext_depth(inode);
> 
>  	if (path) {
>  		/* probably there is space in leaf? */
> -		depth = ext_depth(inode);
>  		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
>  				< le16_to_cpu(path[depth].p_hdr->eh_max))
> -			return 1;
> +			return 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
>  	}
> 
> -	/*
> -	 * given 32-bit logical block (4294967296 blocks), max. tree
> -	 * can be 4 levels in depth -- 4 * 340^4 == 53453440000.
> -	 * Let's also add one more level for imbalance.
> -	 */
> -	depth = 5;
> -
> -	/* allocation of new data block(s) */
> -	needed = 2;
> +	return ext4_ext_writepage_trans_blocks(inode, num, 1);


single extent insert should not look at journaling mode or not
In the above with path specified we don't look at journaling mode
but ext4_ext_writepage_trans_blocks will do


> +}
> 
> -	/*
> -	 * tree can be full, so it would need to grow in depth:
> -	 * we need one credit to modify old root, credits for
> -	 * new root will be added in split accounting
> -	 */
> -	needed += 1;
> +/*
> + * How many index/leaf blocks need to change/allocate to modify nrblocks?
> + *
> + * if nrblocks are fit in a single extent (chunk flag is 1), then
> + * in the worse case, each tree level index/leaf need to be changed
> + * if the tree split due to insert a new extent, then the old tree
> + * index/leaf need to be updated too
> + *
> + * If the nrblocks are discontigous, they could cause
> + * the whole tree split more than once, but this is really rare.
> + */
> +static int ext4_ext_index_trans_blocks(struct inode *inode, int num, int chunk)
> +{
> +	int index;
> +	int depth = ext_depth(inode);
> 
> -	/*
> -	 * Index split can happen, we would need:
> -	 *    allocate intermediate indexes (bitmap + group)
> -	 *  + change two blocks at each level, but root (already included)
> -	 */
> -	needed += (depth * 2) + (depth * 2);
> 
> -	/* any allocation modifies superblock */
> -	needed += 1;
> +	if (chunk)
> +		index = depth * 2;
> +	else
> +		index = depth * 3;
> 
> -	return needed;
> +	return index;
>  }
> 

....

-aneesh
