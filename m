From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 23:57:41 +0530
Message-ID: <20080820182741.GA6417@skywalker>
References: <20080820054339.GB6381@skywalker> <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:49842 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbYHTS2G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 14:28:06 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7KIRaNK017001
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 04:27:36 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KIS1DV4231240
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 04:28:01 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KIS1a1020049
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 04:28:01 +1000
Content-Disposition: inline
In-Reply-To: <20080820115331.GA9965@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 07:53:31AM -0400, Theodore Tso wrote:
> On Wed, Aug 20, 2008 at 04:16:44PM +0530, Aneesh Kumar K.V wrote:
> > > mpage_da_map_blocks block allocation failed for inode 323784 at logical
> > > offset 313 with max blocks 11 with error -28
> > > This should not happen.!! Data will be lost
> 
> We don't actually lose the data if free blocks are subsequently made
> available, correct?
> 
> > I tried this patch. There are still multiple ways we can get wrong free
> > block count. The patch reduced the number of errors. So we are doing
> > better with patch. But I guess we can't use the percpu_counter based
> > free block accounting with delalloc. Without delalloc it is ok even if
> > we find some wrong free blocks count . The actual block allocation will fail in
> > that case and we handle it perfectly fine. With delalloc we cannot
> > afford to fail the block allocation. Should we look at a free block
> > accounting rewrite using simple ext4_fsblk_t and and a spin lock ?
> 
> It would be a shame if we did given that the whole point of the percpu
> counter was to avoid a scalability bottleneck.  Perhaps we could take
> a filesystem-level spinlock only when the number of free blocks as
> reported by the percpu_counter falls below some critical level?
> 
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1543,7 +1543,14 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
> >  	}
> >  	/* reduce fs free blocks counter */
> >  	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> > -
> > +	/*
> > +	 * Now check whether the block count has gone negative.
> > +	 * Some other CPU could have reserved blocks in between
> > +	 */
> > +	if (percpu_counter_read(&sbi->s_freeblocks_counter) < 0) {
> > +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +		return -ENOSPC;
> > +	}
> 
> 
> I think you want to do the check before calling percpu_counter_sub();
> otherwise when you return ENOSPC the free blocks counter ends up
> getting reduced (and gets left negative).
> 
> Also, this is one of the places where it might help if we did
> something like:
> 
> 	freeblocks = percpu_counter_read(&sbi->s_freeblocks_counter);
> 	if (freeblocks < NR_CPUS*4)
> 		freeblocks = percpu_counter_sum(&sbi->s_freeblocks_counter);
> 
> 	if (freeblocks < total) {
> 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 		return -ENOSPC;
> 	}
> 
> BTW, I was looking at the percpu_counter interface, and I'm confused
> why we have percpu_counter_sum_and_set() and percpu_counter_sum().  If
> we're taking the fbc->lock to calculate the precise value of the
> counter, why not simply set fbc->count?  
> 
> Also, it is singularly unfortunate that certain interfaces, such as
> percpu_counter_sum_and_set() only exist for CONFIG_SMP.  This is
> definitely post-2.6.27, but it seems to me that we probably want
> something like percpu_counter_compare_lt() which does something like this:
> 
> static inline int percpu_counter_compare_lt(struct percpu_counter *fbc,
> 					    s64 amount)
> {
> #ifdef CONFIG_SMP
> 	if ((fbc->count - amount) < FBC_BATCH)
> 		percpu_counter_sum_and_set(fbc);
> #endif
> 	return 	(fbc->count < amount);
> }
> 
> ... which we would then use in ext4_has_free_blocks() and
> ext4_da_reserve_space().
> 

Let's say FBC_BATCH = 64 and fbc->count = 100 and we have four cpus and
each cpu request for 30 blocks. each CPU does

in ext4_has_free_blocks:
free_blocks - nblocks = 100 - 30 = 70 and is > FBC_BATCH So we don't do
percpu_counter_sum_and_set
That means ext4_has_free_blocks return success

Now while claiming blocks we do
__percpu_counter_add(fbc, 30, 64)

here  30  < 64. That means we don't do fbc->count += count.
so fbc->count remains as 100 and we have 4  cpu successfully
allocating 30 blocks which means we have to satisfy 120 blocks.

-aneesh

