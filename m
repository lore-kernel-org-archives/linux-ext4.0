From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6  V2]Ext4: journal credits reservation fixes for
	extent file writepage
Date: Sat, 16 Aug 2008 09:55:03 +0530
Message-ID: <20080816042503.GB6423@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop> <1218558473.6766.44.camel@mingming-laptop> <1218847113.8183.45.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48234 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYHPEZM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2008 00:25:12 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7G4Ok8l008208
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 14:24:46 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7G4PATk297224
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 14:25:10 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7G4PAKL005199
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 14:25:10 +1000
Content-Disposition: inline
In-Reply-To: <1218847113.8183.45.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2008 at 05:38:33PM -0700, Mingming Cao wrote:
> 
> Ext4: journal credits reservation fixes for extent file writepage
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> This patch modified the writepage/write_begin credit caculation for
> extent files, to use the credits caculation helper function. 
> 
> The current calculation of how many index/leaf blocks should be
> accounted is too conservetive, it always consider the worse case, where
> the tree level is 5, and in the case of multiple chunk allocation, it
> always multiple the needed credits. This path uses the accurate depth of
> the inode with some extras to caluate the index blocks, and also less
> conservetive in the case of multiple allocation accounting.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
> ---
>  fs/ext4/ext4_extents.h |    3 +
>  fs/ext4/extents.c      |   88 ++++++++++++++++---------------------------------
>  fs/ext4/migrate.c      |    3 +
>  3 files changed, 34 insertions(+), 60 deletions(-)
> 
> Index: linux-2.6.27-rc3/fs/ext4/ext4_extents.h
> ===================================================================
> --- linux-2.6.27-rc3.orig/fs/ext4/ext4_extents.h	2008-08-15 14:43:20.000000000 -0700
> +++ linux-2.6.27-rc3/fs/ext4/ext4_extents.h	2008-08-15 14:44:15.000000000 -0700
> @@ -216,7 +216,9 @@ extern int ext4_ext_calc_metadata_amount
>  extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
>  extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
>  extern int ext4_extent_tree_init(handle_t *, struct inode *);
> -extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
> +extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
> +						   int num,
> +						   struct ext4_ext_path *path);
>  extern int ext4_ext_try_to_merge(struct inode *inode,
>  				 struct ext4_ext_path *path,
>  				 struct ext4_extent *);
> Index: linux-2.6.27-rc3/fs/ext4/extents.c
> ===================================================================
> --- linux-2.6.27-rc3.orig/fs/ext4/extents.c	2008-08-15 14:43:20.000000000 -0700
> +++ linux-2.6.27-rc3/fs/ext4/extents.c	2008-08-15 14:51:07.000000000 -0700
> @@ -1747,54 +1747,62 @@ static int ext4_ext_rm_idx(handle_t *han
>  }
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


s/num/nrblocks/


> -	int depth, needed;
> -
>  	if (path) {
> +		int depth = ext_depth(inode);
> +		int ret;
> +
>  		/* probably there is space in leaf? */
> -		depth = ext_depth(inode);
>  		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
> -				< le16_to_cpu(path[depth].p_hdr->eh_max))
> -			return 1;
> -	}
> -
> -	/*
> -	 * given 32-bit logical block (4294967296 blocks), max. tree
> -	 * can be 4 levels in depth -- 4 * 340^4 == 53453440000.
> -	 * Let's also add one more level for imbalance.
> -	 */
> -	depth = 5;
> +				< le16_to_cpu(path[depth].p_hdr->eh_max)) {
> 
> -	/* allocation of new data block(s) */
> -	needed = 2;

-aneesh
