From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] ext4: Fix file fragmentation during large file
	write.
Date: Mon, 13 Oct 2008 15:22:40 +0530
Message-ID: <20081013095240.GB7819@skywalker>
References: <1223751880-16325-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223751880-16325-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223751880-16325-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223751880-16325-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m31vyly2q8.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58859 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762468AbYJMJxD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 05:53:03 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9D9pggj000309
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 20:51:42 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9D9r0Hu4829238
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 20:53:00 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9D9qxnd006957
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 20:52:59 +1100
Content-Disposition: inline
In-Reply-To: <m31vyly2q8.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2008 at 12:31:43AM +0400, Dmitri Monakhov wrote:
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:
> 
> > The range_cyclic writeback mode uses the address_space writeback_index
> > as the start index for writeback.  With delayed allocation we were
> > updating writeback_index wrongly resulting in highly fragmented file.
> > Number of extents reduced from 4000 to 27 for a 3GB file with the below
> > patch.
> Hi i've played with fragmentation patches with following result:
> I've had several crash and deadlocks
> for example objects wasn't freed on umount:
>  EXT4-fs: mballoc: 12800 blocks 13 reqs (6 success)
>  EXT4-fs: mballoc: 7 extents scanned, 12 goal hits, 1 2^N hits, 0 breaks, 0 lost
>  EXT4-fs: mballoc: 1 generated and it took 3024
>  EXT4-fs: mballoc: 7608 preallocated, 1536 discarded
>  slab error in kmem_cache_destroy(): cache `ext4_prealloc_space': Can't free all objects
>  Pid: 7703, comm: rmmod Not tainted 2.6.27-rc8 #3
> 
>  Call Trace:
>   [<ffffffff8028b011>] kmem_cache_destroy+0x7d/0xc0
>   [<ffffffffa03ca057>] exit_ext4_mballoc+0x10/0x1e [ext4dev]
>   [<ffffffffa03d35b3>] exit_ext4_fs+0x1f/0x2f [ext4dev]
>   [<ffffffff80250dff>] sys_delete_module+0x199/0x1f3
>   [<ffffffff8025d06e>] audit_syscall_entry+0x12d/0x160
>   [<ffffffff8020be0b>] system_call_fastpath+0x16/0x1b
> Some times sync has stuck.
> I'm not shure is it because of current patch set, but where is at least one
> brand new bug. See later.


I can't reproduce this. I build ext as a module and tried to unload the
module. Actually the umount should have released all the objects in
slab. Can you get the /proc/slabinfo output when this happens ?


> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > ---
> >  fs/ext4/inode.c |   83 +++++++++++++++++++++++++++++++++----------------------
> >  1 files changed, 50 insertions(+), 33 deletions(-)
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index cba7960..844c136 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1648,6 +1648,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
> >  	int ret = 0, err, nr_pages, i;
> >  	unsigned long index, end;
> >  	struct pagevec pvec;
> > +	long pages_skipped;
> >  
> >  	BUG_ON(mpd->next_page <= mpd->first_page);
> >  	pagevec_init(&pvec, 0);
> > @@ -1655,7 +1656,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
> >  	end = mpd->next_page - 1;
> [1] In fact mpd->next_page may be bigger whan (index + wbc->nr_to_write)
> this result in incorrect math while exit from mpage_da_writepages()
> Probably we have bound end_index here. 

write_cache_pages also will write more than requested. The
pagevec_lookup_tag can return more than nr_to_write page which
implies wbc->nr_to_write can go negative.


>        end = min(mpd->next_page, index +wbc->nr_to_write) -1;
> >  
> >  	while (index <= end) {
> > -		/* XXX: optimize tail */
> >  		/*
> >  		 * We can use PAGECACHE_TAG_DIRTY lookup here because
> >  		 * even though we have cleared the dirty flag on the page
> > @@ -1673,8 +1673,13 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
> >  		for (i = 0; i < nr_pages; i++) {
> >  			struct page *page = pvec.pages[i];
> >  
> > +			pages_skipped = mpd->wbc->pages_skipped;
> >  			err = mapping->a_ops->writepage(page, mpd->wbc);
> > -			if (!err)
> > +			if (!err && (pages_skipped == mpd->wbc->pages_skipped))
> > +				/*
> > +				 * have successfully written the page
> > +				 * without skipping the same
> > +				 */
> >  				mpd->pages_written++;
> >  			/*
> >  			 * In error case, we have to continue because
> > @@ -2110,7 +2115,6 @@ static int mpage_da_writepages(struct address_space *mapping,
> >  			       struct writeback_control *wbc,
> >  			       struct mpage_da_data *mpd)
> >  {
> > -	long to_write;
> >  	int ret;
> >  
> >  	if (!mpd->get_block)
> > @@ -2125,10 +2129,7 @@ static int mpage_da_writepages(struct address_space *mapping,
> >  	mpd->pages_written = 0;
> >  	mpd->retval = 0;
> >  
> > -	to_write = wbc->nr_to_write;
> > -
> >  	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
> > -
> >  	/*
> >  	 * Handle last extent of pages
> >  	 */
> > @@ -2137,7 +2138,7 @@ static int mpage_da_writepages(struct address_space *mapping,
> >  			mpage_da_submit_io(mpd);
> >  	}
> >  
> > -	wbc->nr_to_write = to_write - mpd->pages_written;
> > +	wbc->nr_to_write -= mpd->pages_written;
> due to [1] wbc->nr_write becomes negative here


wbc->nr_ti_write can go negative right ?



> >  	return ret;
> >  }
> >  
> > @@ -2366,11 +2367,14 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
> >  static int ext4_da_writepages(struct address_space *mapping,
> >  			      struct writeback_control *wbc)
> >  {
> > +	pgoff_t	index;
> > +	int range_whole = 0;
> >  	handle_t *handle = NULL;
> > +	long pages_written = 0;
> >  	struct mpage_da_data mpd;
> >  	struct inode *inode = mapping->host;
> > +	int no_nrwrite_update, no_index_update;
> >  	int needed_blocks, ret = 0, nr_to_writebump = 0;
> > -	long to_write, pages_skipped = 0;
> >  	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
> >  
> >  	/*
> > @@ -2390,16 +2394,27 @@ static int ext4_da_writepages(struct address_space *mapping,
> >  		nr_to_writebump = sbi->s_mb_stream_request - wbc->nr_to_write;
> >  		wbc->nr_to_write = sbi->s_mb_stream_request;
> >  	}
> > +	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
> > +		range_whole = 1;
> >  
> > -
> > -	pages_skipped = wbc->pages_skipped;
> > +	if (wbc->range_cyclic)
> > +		index = mapping->writeback_index;
> > +	else
> > +		index = wbc->range_start >> PAGE_CACHE_SHIFT;
> >  
> >  	mpd.wbc = wbc;
> >  	mpd.inode = mapping->host;
> >  
> > -restart_loop:
> > -	to_write = wbc->nr_to_write;
> > -	while (!ret && to_write > 0) {
> > +	/*
> > +	 * we don't want write_cache_pages to update
> > +	 * nr_to_write and writeback_index
> > +	 */
> > +	no_nrwrite_update = wbc->no_nrwrite_update;
> > +	wbc->no_nrwrite_update = 1;
> > +	no_index_update = wbc->no_index_update;
> > +	wbc->no_index_update   = 1;
> > +
> > +	while (!ret && wbc->nr_to_write > 0) {
> >  
> >  		/*
> >  		 * we  insert one extent at a time. So we need
> > @@ -2420,46 +2435,48 @@ static int ext4_da_writepages(struct address_space *mapping,
> >  			dump_stack();
> >  			goto out_writepages;
> >  		}
> > -		to_write -= wbc->nr_to_write;
> > -
> >  		mpd.get_block = ext4_da_get_block_write;
> >  		ret = mpage_da_writepages(mapping, wbc, &mpd);
> >  
> >  		ext4_journal_stop(handle);
> >  
> > -		if (mpd.retval == -ENOSPC)
> > +		if (mpd.retval == -ENOSPC) {
> > +			/* commit the transaction which would
> > +			 * free blocks released in the transaction
> > +			 * and try again
> > +			 */
> >  			jbd2_journal_force_commit_nested(sbi->s_journal);
> > -
> > -		/* reset the retry count */
> > -		if (ret == MPAGE_DA_EXTENT_TAIL) {
> > +			ret = 0;
> > +		} else if (ret == MPAGE_DA_EXTENT_TAIL) {
> >  			/*
> >  			 * got one extent now try with
> >  			 * rest of the pages
> >  			 */
> > -			to_write += wbc->nr_to_write;
> > +			pages_written += mpd.pages_written;
> >  			ret = 0;
> > -		} else if (wbc->nr_to_write) {
> > +		} else if (wbc->nr_to_write)
> >  			/*
> >  			 * There is no more writeout needed
> >  			 * or we requested for a noblocking writeout
> >  			 * and we found the device congested
> >  			 */
> > -			to_write += wbc->nr_to_write;
> >  			break;
> > -		}
> > -		wbc->nr_to_write = to_write;
> > -	}
> > -
> > -	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
> > -		/* We skipped pages in this loop */
> > -		wbc->nr_to_write = to_write +
> > -				wbc->pages_skipped - pages_skipped;
> > -		wbc->pages_skipped = pages_skipped;
> > -		goto restart_loop;
> >  	}
> > +	/* Update index */
> > +	index += pages_written;
> > +	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
> > +		/*
> > +		 * set the writeback_index so that range_cyclic
> > +		 * mode will write it back later
> > +		 */
> > +		mapping->writeback_index = index;
> >  
> >  out_writepages:
> > -	wbc->nr_to_write = to_write - nr_to_writebump;
> > +	if (!no_nrwrite_update)
> > +		wbc->no_nrwrite_update = 0;
> > +	if (!no_index_update)
> > +		wbc->no_index_update   = 0;
> > +	wbc->nr_to_write -= nr_to_writebump;
> >  	return ret;
> >  }
> BTW: please add following cleanup fix.
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6efa4ca..c248cbc 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2603,7 +2603,7 @@ static int ext4_da_write_end(struct file *file,
>  	handle_t *handle = ext4_journal_current_handle();
>  	loff_t new_i_size;
>  	unsigned long start, end;
> -	int write_mode = (int)fsdata;
> +	int write_mode = (int)(unsigned long)fsdata;
> 
>  	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
>  		if (ext4_should_order_data(inode)) {
> 

Eric Sandeen already fixed it in the pathqueue.I can also
see mainline having the fix. Which kernel are you trying ?

-aneesh
