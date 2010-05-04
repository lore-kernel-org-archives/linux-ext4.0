From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH, RFC 2/2] ext4: Convert callers of ext4_get_blocks() to use ext4_map_blocks()
Date: Tue, 04 May 2010 15:34:59 +0530
Message-ID: <878w80htis.fsf@linux.vnet.ibm.com>
References: <1272927081-12694-1-git-send-email-tytso@mit.edu> <1272927081-12694-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53975 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0EDKFG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 06:05:06 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id o44A5GGJ026387
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 20:05:16 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o449wBAJ1294392
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 19:58:11 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o44A53lt007551
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 20:05:03 +1000
In-Reply-To: <1272927081-12694-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon,  3 May 2010 18:51:21 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> @@ -2560,45 +2522,50 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  		invalid_block = ~0;
> 
>  	BUG_ON(create == 0);
> -	BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
> +	BUG_ON(bh->b_size != inode->i_sb->s_blocksize);
> +
> +	map.m_lblk = iblock;
> +	map.m_len = 1;
> 
>  	/*
>  	 * first, we need to know whether the block is allocated already
>  	 * preallocated blocks are unmapped but should treated
>  	 * the same as allocated blocks.
>  	 */
> -	ret = ext4_get_blocks(NULL, inode, iblock, 1,  bh_result, 0);
> -	if ((ret == 0) && !buffer_delay(bh_result)) {
> -		/* the block isn't (pre)allocated yet, let's reserve space */
> -		/*
> -		 * XXX: __block_prepare_write() unmaps passed block,
> -		 * is it OK?
> -		 */
> -		ret = ext4_da_reserve_space(inode, iblock);
> -		if (ret)
> -			/* not enough space to reserve */
> -			return ret;
> -
> -		map_bh(bh_result, inode->i_sb, invalid_block);
> -		set_buffer_new(bh_result);
> -		set_buffer_delay(bh_result);
> -	} else if (ret > 0) {
> -		bh_result->b_size = (ret << inode->i_blkbits);
> -		if (buffer_unwritten(bh_result)) {
> -			/* A delayed write to unwritten bh should
> -			 * be marked new and mapped.  Mapped ensures
> -			 * that we don't do get_block multiple times
> -			 * when we write to the same offset and new
> -			 * ensures that we do proper zero out for
> -			 * partial write.
> +	ret = ext4_map_blocks(NULL, inode, &map, 0);
> +	if (ret < 0)
> +		return ret;
> +	if (ret == 0) {
> +		if (!buffer_delay(bh)) {


bh flags are not set here. This check should be based on map.m_flags.




> +			/*
> +			 * XXX: __block_prepare_write() unmaps passed
> +			 * block, is it OK?
>  			 */
> -			set_buffer_new(bh_result);
> -			set_buffer_mapped(bh_result);
> +			ret = ext4_da_reserve_space(inode, iblock);
> +			if (ret)
> +				return ret; /* not enough space to reserve */
> +
> +			map_bh(bh, inode->i_sb, invalid_block);
> +			set_buffer_new(bh);
> +			set_buffer_delay(bh);
>  		}
> -		ret = 0;
> +		return 0;
>  	}
> 

Only thing i am worried about is we were modifying bh_flags in all
possible confusing ways. We may want to make sure we get the update
correct. I am still going through the patch after applying it to the
tree. So may take more time to look at the full changeset.

-aneesh
