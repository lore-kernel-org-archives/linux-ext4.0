From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6 ]Ext4 credits caclulation cleanup and fix that for
	nonextent writepage
Date: Wed, 13 Aug 2008 15:49:43 +0530
Message-ID: <20080813101943.GF6439@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop> <1218558354.6766.40.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:51980 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750782AbYHMKT5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 06:19:57 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7DAJkYX017199
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 15:49:46 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7DAJklv1036498
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 15:49:46 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7DAJjhM015871
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 15:49:45 +0530
Content-Disposition: inline
In-Reply-To: <1218558354.6766.40.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2008 at 09:25:54AM -0700, Mingming Cao wrote:
> +int ext4_meta_trans_blocks(struct inode* inode, int nrblocks, int idxblocks)
> +{
> +	int groups, gdpblocks;
> +	int ret = 0;
> +
> +	groups = nrblocks + idxblocks;
> +	gdpblocks = groups;
> +	if (groups > EXT4_SB(inode->i_sb)->s_groups_count)
> +		groups = EXT4_SB(inode->i_sb)->s_groups_count;
> +	if (groups > EXT4_SB(inode->i_sb)->s_gdb_count)
> +		gdpblocks = EXT4_SB(inode->i_sb)->s_gdb_count;


I guess we should pass chunk to ext4_meta_trans_blocks also.
if (chunk) we should update only one group descriptor and one
bitmap block ie, 
if(chunk)
	groups = 1 + idxblocks;



> +
> +	/* bitmaps and block group descriptor blocks */
> +	ret += groups + gdpblocks;
> +
> +	ret += idxblocks;
> +
> +	/* journalled mode, include buffer to modify data blocks */
> +	if (ext4_should_journal_data(inode))
> +		ret += nrblocks;
> +
> +	/* Blocks for super block, inode, quota and xattr blocks */
> +	ret += EXT4_META_TRANS_BLOCKS(inode->i_sb);
> +
> +	return ret;
> +}
> +
....
...

> +static int ext4_writeblocks_trans_credits_old(struct inode *inode, int nrblocks,
> +					      int chunk)
>  {
> -	int bpp = ext4_journal_blocks_per_page(inode);
> -	int indirects = (EXT4_NDIR_BLOCKS % bpp) ? 5 : 3;
> +	int indirects;
>  	int ret;
> 
> -	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> -		return ext4_ext_writepage_trans_blocks(inode, bpp);
> -
> -	if (ext4_should_journal_data(inode))
> -		ret = 3 * (bpp + indirects) + 2;
> -	else
> -		ret = 2 * (bpp + indirects) + 2;
> +	/*
> +	 * How many index blocks need to touch to modify nrblocks?
> +	 * The "Chunk" flag indicating whether the nrblocks is
> +	 * physically contigous on disk
> +	 *
> + 	 * For Direct IO and fallocate, they calls get_block to allocate
> + 	 * one single extent at a time, so they could set the "Chunk" flag
> +	 */
> +	indirects = ext4_indirect_trans_blocks(inode, nrblocks, chunk);
> 
> -#ifdef CONFIG_QUOTA
> -	/* We know that structure was already allocated during DQUOT_INIT so
> -	 * we will be updating only the data blocks + inodes */
> -	ret += 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
> -#endif
> +	/* Account for block group bitmaps and block groups
> +	 * descriptors.Worse case, the nrblocks+indirects blocks spread
> +	 * over different block groups
> +	 */
> +	ret = ext4_meta_trans_blocks(inode, nrblocks, indirects);
> 
>  	return ret;
>  }

-aneesh
