From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 3/6] delalloc ENOSPC: reserve blocks
Date: Mon, 2 Jun 2008 12:14:33 +0530
Message-ID: <20080602064433.GB26379@skywalker>
References: <1212363355.4368.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:35687 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYFBGou (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 02:44:50 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m526iYQQ005557
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 12:14:34 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m526i8GP745546
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 12:14:08 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m526iYPN002801
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 12:14:34 +0530
Content-Disposition: inline
In-Reply-To: <1212363355.4368.66.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 04:35:55PM -0700, Mingming Cao wrote:
> ext4: delalloc ENOSPC handling core
> 
> From: Mingming cao <cmm@us.ibm.com>
> 
> Core part of delaloc ENOSPC (block reservation.) 
> data/meta blocks are reserved on write_begin(), and per-inode reserved counters
> are updated  after block allocation.
> 
> Signed-off-by: Mingming cao <cmm@us.ibm.com>
> 
> ---
>  fs/ext4/inode.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 66 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.26-rc4/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.26-rc4.orig/fs/ext4/inode.c	2008-06-01 14:26:13.000000000 -0700
> +++ linux-2.6.26-rc4/fs/ext4/inode.c	2008-06-01 15:04:06.000000000 -0700
> @@ -38,6 +38,7 @@
>  #include "ext4_jbd2.h"
>  #include "xattr.h"
>  #include "acl.h"
> +#include "ext4_extents.h"
> 
>  static void ext4_invalidatepage(struct page *page, unsigned long offset);
> 
> @@ -1410,6 +1411,61 @@ static int ext4_journalled_write_end(str
>  	return ret ? ret : copied;
>  }
> 
> +static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
> +{
> +       struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +       unsigned long md_needed, mdblocks, total = 0;
> +
> +       /*
> +        * calculate the amount of metadata blocks to reserve

	 recalculate the amount of metadata blocks to reserve.




> +	* in order to allocate nrblocks
> +	* worse case is one extent per block
> +	*/
> +	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
> +	mdblocks = ext4_ext_calc_metadata_amount(inode, total);
> +	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
> +
> +	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
> +	total = md_needed + nrblocks;
> +
> +	if (ext4_has_free_blocks(sbi, total) < total)
> +		return -ENOSPC;
> +
> +	/* reduce fs free blocks counter */
> +	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> +
> +	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
> +	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;

Better written as
	EXT4_I(inode)->i_reserved_meta_blocks += mdblocks;

> +
> +	return 0;       /* success */
> +}
> +
> +static void ext4_da_release_space(struct inode *inode, int used, int to_free)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +	int total, mdb, release;

	int total, mdb, release, mdb_to_free;

> +
> +	/* calculate the number of metablocks still need to be reserved */
> +	total = EXT4_I(inode)->i_reserved_data_blocks - used - to_free;
> +	mdb = ext4_ext_calc_metadata_amount(inode, total);
> +
> +	/* figure out how many metablocks to release */
> +	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> +	mdb = EXT4_I(inode)->i_reserved_meta_blocks - mdb;

	mdb_to_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;


> +
> +	release = to_free + mdb;
> +
	release = to_free + mdb_to_free;


> +	/* update fs free blocks counter for truncate case */
> +	percpu_counter_add(&sbi->s_freeblocks_counter, release);
> +
> +	/* update per-inode reservations */
> +	BUG_ON(used + to_free > EXT4_I(inode)->i_reserved_data_blocks);
> +	EXT4_I(inode)->i_reserved_data_blocks -= used + to_free;
> +
> +	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
> +	EXT4_I(inode)->i_reserved_meta_blocks -= mdb;

	/*
	 * update the meta block reservation 
	 */
	EXT4_I(inode)->i_reserved_meta_blocks = mdb;

> +}
> +
>  /*
>   * this is a special callback for ->write_begin() only
>   * it's intention is to return mapped block or reserve space
> @@ -1428,13 +1484,17 @@ static int ext4_da_get_block_prep(struct
>  	 * the same as allocated blocks.
>  	 */
>  	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0);
> -	if (ret == 0) {
> -		/* the block isn't allocated yet, let's reserve space */
> -		/* XXX: call reservation here */
> +	if ((ret == 0)&& !buffer_delay(bh_result)) {
> +		/* the block isn't (pre)allocated yet, let's reserve space */
>  		/*
>  		 * XXX: __block_prepare_write() unmaps passed block,
>  		 * is it OK?
>  		 */
> +		ret = ext4_da_reserve_space(inode, 1);
> +		if (ret)
> +			/* not enough space to reserve */
> +			return ret;
> +
>  		map_bh(bh_result, inode->i_sb, 0);
>  		set_buffer_new(bh_result);
>  		set_buffer_delay(bh_result);
> @@ -1463,6 +1523,9 @@ static int ext4_da_get_block_write(struc
>  	if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
> 
> +		/* release reserved-but-unused meta blocks */
> +		ext4_da_release_space(inode, ret, 0);
> +
>  		/*
>  		 * Update on-disk size along with block allocation
>  		 * we don't use 'extend_disksize' as size may change
> 
> 


-aneesh
