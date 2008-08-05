From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with delayed allocation
Date: Tue, 5 Aug 2008 18:51:33 +0530
Message-ID: <20080805132133.GA15568@skywalker>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804163505.GE9397@skywalker> <20080805064428.GB8569@mit.edu> <20080805065217.GF9397@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:45242 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760974AbYHENWg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 09:22:36 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m75DLlAY018223
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 23:21:47 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m75DMYFQ4583496
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 23:22:34 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m75DMYK5023630
	for <linux-ext4@vger.kernel.org>; Tue, 5 Aug 2008 23:22:34 +1000
Content-Disposition: inline
In-Reply-To: <20080805065217.GF9397@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 05, 2008 at 12:22:17PM +0530, Aneesh Kumar K.V wrote:
> On Tue, Aug 05, 2008 at 02:44:28AM -0400, Theodore Tso wrote:
> > On Mon, Aug 04, 2008 at 10:05:05PM +0530, Aneesh Kumar K.V wrote:
> > > 
> > > This is the complete patch that  I have. I haven't fully tested it
> > > (right now waiting for the machine to be free). This should apply 
> > > after stable-boundary-undo.patch
> > 
> > Umm... the patch doesn't apply right after the stable boundary udo
> > patch.
> > 
> > 						- Ted
> 
> I did a fresh git pull and updated the patch. I also accumulated few
> changes after words while testing on ABAT. Attaching both the patches
> below. The patches apply after ext4_journal_credits_fix_for_writepages.patch
> in the patch queue.

I still see the problem with the below changes. Now that i have read
the writeback path more closely I am not sure how it will guarantee
that all dirty pages of the inode are written back to disk before
generic_sync_sb_inodes return.

.....
....

> @@ -2202,10 +2224,7 @@ static int ext4_da_writepages(struct address_space *mapping,
>  	int ret = 0;
>  	long to_write;
>  	loff_t range_start = 0;
> -	int blocks_per_page = PAGE_CACHE_SIZE >> inode->i_blkbits;
> -	int max_credit_blocks = ext4_journal_max_transaction_buffers(inode);
> -	int need_credits_per_page =  ext4_writepages_trans_blocks(inode, 1);
> -	int max_writeback_pages = (max_credit_blocks / blocks_per_page) / need_credits_per_page;
> +	long pages_skipped = 0;
>  
>  	/*
>  	 * No pages to write? This is mainly a kludge to avoid starting
> @@ -2215,11 +2234,6 @@ static int ext4_da_writepages(struct address_space *mapping,
>  	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
>  		return 0;
>  
> -	if (wbc->nr_to_write > mapping->nrpages)
> -		wbc->nr_to_write = mapping->nrpages;
> -
> -	to_write = wbc->nr_to_write;
> -
>  	if (!wbc->range_cyclic) {
>  		/*
>  		 * If range_cyclic is not set force range_cont
> @@ -2228,26 +2242,21 @@ static int ext4_da_writepages(struct address_space *mapping,
>  		wbc->range_cont = 1;
>  		range_start =  wbc->range_start;
>  	}
> +	pages_skipped = wbc->pages_skipped;
>  
> -	while (!ret && to_write) {
> -		/*
> -		 * set the max dirty pages could be write at a time
> -		 * to fit into the reserved transaction credits
> -		 */
> -		if (wbc->nr_to_write > max_writeback_pages)
> -			wbc->nr_to_write = max_writeback_pages;
> +restart_loop:
> +	to_write = wbc->nr_to_write;
> +	while (!ret && to_write > 0) {
>  
....

.....

>  			 * or we requested for a noblocking writeout
> @@ -2288,6 +2304,15 @@ static int ext4_da_writepages(struct address_space *mapping,
>  		wbc->nr_to_write = to_write;
>  	}
>  
> +	if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
> +		/* We skipped pages in this loop */
> +		wbc->range_start = range_start;
> +		wbc->nr_to_write = to_write +
> +					wbc->pages_skipped - pages_skipped;
> +		wbc->pages_skipped = pages_skipped;
> +		goto restart_loop;
> +	}
> +



This should not be needed. I was trying to force the pages to writeback.
generic_sync_sb_inodes actually move  the inode to s_dirty if the
pages_skipped differ after a writeback. But the confusing part is we
are not looking at s_dirty list again. We move s_dirty and s_more_io to s_io
only once in queue_io

>  out_writepages:
>  	wbc->nr_to_write = to_write;
>  	if (range_start)

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8d62200..023e1a8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1790,6 +1790,13 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
>  	new.b_state = lbh->b_state;
>  	new.b_blocknr = 0;
>  	new.b_size = lbh->b_size;
> +
> +	/*
> +	 * If we didn't accumulate anything
> +	 * to write simply return
> +	 */
> +	if (!new.b_size)
> +		return;
>  	err = mpd->get_block(mpd->inode, next, &new, 1);
>  	if (err)
>  		return;
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 25adfc3..a7db10c 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -517,8 +517,12 @@ void generic_sync_sb_inodes(struct super_block *sb,
>  		cond_resched();
>  		spin_lock(&inode_lock);
>  		if (wbc->nr_to_write <= 0) {
> -			wbc->more_io = 1;
> -			break;
> +			if (wbc->sync_mode == WB_SYNC_ALL) {
> +				wbc->nr_to_write = LONG_MAX;
> +			} else {
> +				wbc->more_io = 1;
> +				break;
> +			}
>  		}
>  		if (!list_empty(&sb->s_more_io))
>  			wbc->more_io = 1;

This also should not be done. I guess we need to look at core writeback
code more closely.

-aneesh

