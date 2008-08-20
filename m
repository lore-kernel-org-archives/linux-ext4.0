From: Theodore Tso <tytso@mit.edu>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 07:53:31 -0400
Message-ID: <20080820115331.GA9965@mit.edu>
References: <20080820054339.GB6381@skywalker> <20080820104644.GA11267@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54228 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752787AbYHTLxf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 07:53:35 -0400
Content-Disposition: inline
In-Reply-To: <20080820104644.GA11267@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 04:16:44PM +0530, Aneesh Kumar K.V wrote:
> > mpage_da_map_blocks block allocation failed for inode 323784 at logical
> > offset 313 with max blocks 11 with error -28
> > This should not happen.!! Data will be lost

We don't actually lose the data if free blocks are subsequently made
available, correct?

> I tried this patch. There are still multiple ways we can get wrong free
> block count. The patch reduced the number of errors. So we are doing
> better with patch. But I guess we can't use the percpu_counter based
> free block accounting with delalloc. Without delalloc it is ok even if
> we find some wrong free blocks count . The actual block allocation will fail in
> that case and we handle it perfectly fine. With delalloc we cannot
> afford to fail the block allocation. Should we look at a free block
> accounting rewrite using simple ext4_fsblk_t and and a spin lock ?

It would be a shame if we did given that the whole point of the percpu
counter was to avoid a scalability bottleneck.  Perhaps we could take
a filesystem-level spinlock only when the number of free blocks as
reported by the percpu_counter falls below some critical level?

> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1543,7 +1543,14 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
>  	}
>  	/* reduce fs free blocks counter */
>  	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> -
> +	/*
> +	 * Now check whether the block count has gone negative.
> +	 * Some other CPU could have reserved blocks in between
> +	 */
> +	if (percpu_counter_read(&sbi->s_freeblocks_counter) < 0) {
> +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +		return -ENOSPC;
> +	}


I think you want to do the check before calling percpu_counter_sub();
otherwise when you return ENOSPC the free blocks counter ends up
getting reduced (and gets left negative).

Also, this is one of the places where it might help if we did
something like:

	freeblocks = percpu_counter_read(&sbi->s_freeblocks_counter);
	if (freeblocks < NR_CPUS*4)
		freeblocks = percpu_counter_sum(&sbi->s_freeblocks_counter);

	if (freeblocks < total) {
		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
		return -ENOSPC;
	}

BTW, I was looking at the percpu_counter interface, and I'm confused
why we have percpu_counter_sum_and_set() and percpu_counter_sum().  If
we're taking the fbc->lock to calculate the precise value of the
counter, why not simply set fbc->count?  

Also, it is singularly unfortunate that certain interfaces, such as
percpu_counter_sum_and_set() only exist for CONFIG_SMP.  This is
definitely post-2.6.27, but it seems to me that we probably want
something like percpu_counter_compare_lt() which does something like this:

static inline int percpu_counter_compare_lt(struct percpu_counter *fbc,
					    s64 amount)
{
#ifdef CONFIG_SMP
	if ((fbc->count - amount) < FBC_BATCH)
		percpu_counter_sum_and_set(fbc);
#endif
	return 	(fbc->count < amount);
}

... which we would then use in ext4_has_free_blocks() and
ext4_da_reserve_space().

						- Ted
