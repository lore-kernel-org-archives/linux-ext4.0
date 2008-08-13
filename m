From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6 ]Ext4: journal credits reservation fixes for DIO,
	fallocate
Date: Wed, 13 Aug 2008 14:23:07 +0530
Message-ID: <20080813085307.GC6439@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop> <1218558590.6766.47.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36474 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754874AbYHMIxW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 04:53:22 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7D8rBlh001777
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 14:23:11 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7D8rBGE1585322
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 14:23:11 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7D8rAjl010187
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 14:23:11 +0530
Content-Disposition: inline
In-Reply-To: <1218558590.6766.47.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2008 at 09:29:50AM -0700, Mingming Cao wrote:
> 
......
....

> 
> ===================================================================
> Index: linux-2.6.27-rc1/fs/ext4/extents.c
> ===================================================================
> --- linux-2.6.27-rc1.orig/fs/ext4/extents.c	2008-08-11 22:25:39.000000000 -0700
> +++ linux-2.6.27-rc1/fs/ext4/extents.c	2008-08-11 22:25:55.000000000 -0700
> @@ -2799,7 +2799,7 @@ void ext4_ext_truncate(struct inode *ino
>  	/*
>  	 * probably first extent we're gonna free will be last in block
>  	 */
> -	err = ext4_writepage_trans_blocks(inode) + 3;
> +	err = ext4_writepage_trans_blocks(inode);
>  	handle = ext4_journal_start(inode, err);
>  	if (IS_ERR(handle))
>  		return;
> @@ -2951,10 +2951,9 @@ long ext4_fallocate(struct inode *inode,
>  	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
>  							- block;
>  	/*
> -	 * credits to insert 1 extent into extent tree + buffers to be able to
> -	 * modify 1 super block, 1 block bitmap and 1 group descriptor.
> +	 * credits to insert 1 extent into extent tree
>  	 */
> -	credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb) + 3;
> +	credits = ext4_data_trans_blocks(inode, max_blocks);


Why do we need to consider data=journaled mode here. We are not writing
any data here. Instead we are just inserting an extent.


>  	mutex_lock(&inode->i_mutex);
>  retry:
>  	while (ret >= 0 && ret < max_blocks) {
> Index: linux-2.6.27-rc1/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.27-rc1.orig/fs/ext4/inode.c	2008-08-11 22:18:31.000000000 -0700
> +++ linux-2.6.27-rc1/fs/ext4/inode.c	2008-08-11 22:25:55.000000000 -0700
> @@ -1041,18 +1041,6 @@ static void ext4_da_update_reserve_space
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
> 
> -/* Maximum number of blocks we map for direct IO at once. */
> -#define DIO_MAX_BLOCKS 4096
> -/*
> - * Number of credits we need for writing DIO_MAX_BLOCKS:
> - * We need sb + group descriptor + bitmap + inode -> 4
> - * For B blocks with A block pointers per block we need:
> - * 1 (triple ind.) + (B/A/A + 2) (doubly ind.) + (B/A + 2) (indirect).
> - * If we plug in 4096 for B and 256 for A (for 1KB block size), we get 25.
> - */
> -#define DIO_CREDITS 25
> -
> -
>  /*
>   * The ext4_get_blocks_wrap() function try to look up the requested blocks,
>   * and returns if the blocks are already mapped.
> @@ -1164,19 +1152,23 @@ int ext4_get_blocks_wrap(handle_t *handl
>  	return retval;
>  }
> 
> +/* Maximum number of blocks we map for direct IO at once. */
> +#define DIO_MAX_BLOCKS 4096
> +
>  static int ext4_get_block(struct inode *inode, sector_t iblock,
>  			struct buffer_head *bh_result, int create)
>  {
>  	handle_t *handle = ext4_journal_current_handle();
>  	int ret = 0, started = 0;
>  	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> +	int dio_credits;
> 
>  	if (create && !handle) {
>  		/* Direct IO write... */
>  		if (max_blocks > DIO_MAX_BLOCKS)
>  			max_blocks = DIO_MAX_BLOCKS;
> -		handle = ext4_journal_start(inode, DIO_CREDITS +
> -			      2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
> +		dio_credits = ext4_data_trans_blocks(inode, max_blocks);
> +		handle = ext4_journal_start(inode, dio_credits);

Even in data=journal mode directIO will put the buffer_heads to journal
right ? . So should we use ext4_data_trans_blocks here ?



>  		if (IS_ERR(handle)) {
>  			ret = PTR_ERR(handle);
>  			goto out;
> @@ -2222,7 +2214,7 @@ static int ext4_da_writepage(struct page
>   * for DIO, writepages, and truncate
>   */
>  #define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
> -#define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS
> +#define EXT4_MAX_WRITEBACK_CREDITS    25
> 
>  static int ext4_da_writepages(struct address_space *mapping,
>  				struct writeback_control *wbc)
> @@ -4429,7 +4421,8 @@ static int ext4_writeblocks_trans_credit
> 
>  /*
> 

....
....

-aneesh
