From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Allocate entire range in zero range
Date: Thu, 5 Mar 2015 12:43:58 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503051242280.24744@localhost.localdomain>
References: <1424278168-13711-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: esandeen@redhat.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbbCELoF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Mar 2015 06:44:05 -0500
In-Reply-To: <1424278168-13711-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric, can I get some review on this one ?

Ted, I think this is quite critical, could you please ACK this one
so we know whether it's going in or not ?

Thanks!
-Lukas

On Wed, 18 Feb 2015, Lukas Czerner wrote:

> Date: Wed, 18 Feb 2015 17:49:28 +0100
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH] ext4: Allocate entire range in zero range
> 
> Currently there is a bug in zero range code which causes zero range
> calls to only allocate block aligned portion of the range, while
> ignoring the rest in some cases.
> 
> In some cases, namely if the end of the range is past isize, we do
> attempt to preallocate the last nonaligned block. However this might
> cause kernel to BUG() in some carefully designed zero range requests on
> setups where page size > block size.
> 
> Fix this problem by first preallocating the entire range, including the
> nonaligned edges and converting the written extents to unwritten in the
> next step. This approach will also give us the advantage of having the
> range to be as linearly contiguous as possible.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bed4308..aa52242 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4803,12 +4803,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	else
>  		max_blocks -= lblk;
>  
> -	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
> -		EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
> -		EXT4_EX_NOCACHE;
> -	if (mode & FALLOC_FL_KEEP_SIZE)
> -		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
> -
>  	mutex_lock(&inode->i_mutex);
>  
>  	/*
> @@ -4825,15 +4819,28 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  		ret = inode_newsize_ok(inode, new_size);
>  		if (ret)
>  			goto out_mutex;
> -		/*
> -		 * If we have a partial block after EOF we have to allocate
> -		 * the entire block.
> -		 */
> -		if (partial_end)
> -			max_blocks += 1;
>  	}
>  
> +	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
> +	if (mode & FALLOC_FL_KEEP_SIZE)
> +		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
> +
> +	/* Preallocate the range including the unaligned edges */
> +	if (partial_begin || partial_end) {
> +		ret = ext4_alloc_file_blocks(file,
> +				round_down(offset, 1 << blkbits) >> blkbits,
> +				(round_up((offset + len), 1 << blkbits) -
> +				 round_down(offset, 1 << blkbits)) >> blkbits,
> +				new_size, flags, mode);
> +		if (ret)
> +			goto out_mutex;
> +
> +	}
> +
> +	/* Zero range excluding the unaligned edges */
>  	if (max_blocks > 0) {
> +		flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
> +			  EXT4_EX_NOCACHE);
>  
>  		/* Now release the pages and zero block aligned part of pages*/
>  		truncate_pagecache_range(inode, start, end - 1);
> 
