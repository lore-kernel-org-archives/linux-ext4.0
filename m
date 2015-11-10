From: Jan Kara <jack@suse.cz>
Subject: Re: memory leak: data=journal and {collapse,insert,zero}_range
Date: Tue, 10 Nov 2015 15:49:46 +0100
Message-ID: <20151110144946.GB3156@quack.suse.cz>
References: <20151017160230.GA19968@thunk.org>
 <009301d10b2f$b410e6b0$1c32b410$@samsung.com>
 <20151020155443.GM2972@thunk.org>
 <011f01d10be5$099d38d0$1cd7aa70$@samsung.com>
 <20151021145214.GC2165@thunk.org>
 <004301d11aae$72683a40$5738aec0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbbKJOtu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2015 09:49:50 -0500
Content-Disposition: inline
In-Reply-To: <004301d11aae$72683a40$5738aec0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 09-11-15 14:21:11, Namjae Jeon wrote:
> > 
> > On Wed, Oct 21, 2015 at 06:44:10PM +0900, Namjae Jeon wrote:
> > > > Interestingly we're not seeing these memory leaks on the truncate
> > > > path, so I suspect the issue is in how collapse range is clearing
> > > > pages from the page cache, especially pages that were freshly written
> > > > to the journal by the commit but which hadn't yet been writtten to
> > > > disk and then marked as complete so we can allow the relevant
> > > > transaction to be checkpointed.  (Although we're not leaking the
> > > > journal head structures, but only the buffer heads, so the story most
> > > > be a bit more complicated than that.)
> > >
> > > Okay, Thanks for sharing your view and points !!
> > >
> > > Currently I can reproduce memory leak issue without collase/insert/zero range.
> > > conditions like the following.(collase/insert/zero range are disable with -I -C -z option and add -y
> > option instead of -W)
> > >   1. small size parition(1GB)
> > >   2. run fsx with these options "./fsx -N 30000 -o 128000 -l 500000 -r 4096 -t 512 -w 512 -Z -R -y -
> > I -C -z testfile"
> > > And same result with generic/091 is showing (buffer_head leak)
> > >
> > > So I am starting to find root-cause base on your points.
> > > I will share the result or the patch.
> > 
> > Thanks, that's very interesting data point.  So this makes it appear
> > that the problem *is* probably with how we deal with checkpointing
> > buffers after the pages get discarded using either a truncate or a
> > collapse_range, since the 'y' option causes a lot fsync's, and hence
> > commits, some of which are happening after a truncate command.
> > 
> > Thanks for a taking a look at this.  I really appreciate it.
> > 
> > Cheers,
> 
> 
> Hi Ted,
> 
> Could you review this patch?
> 
> Thanks!
> ---------------------------------------------------------------------------------
> Subject: [PATCH] jbd2: try to free buffers from truncated page after
>  checkpoint
> 
> when ext4 is mounted in data=journal mode, and truncate operation
> such as settatr(size), collopse, insert and zero range are used, there are
> are many truncated pages with NULL page->mapping. Such truncated pages
> pile up quickly due to truncate_pagecache on data pages associated with journal.
> As page->mapping is NULL for such truncated pages, they are not freed
> by drop cache(3) or umount. As a result, MemFree in /proc/meminfo decreases
> quickly and active buffer_head slab objects grow in /proc/slabinfo.
> This patch attempts to free buffers from such pages at the end of jbd2
> checkpoint, if pages do not have any busy buffers and NULL mapping. 

Hum, why such pages didn't get freed by release_buffer_page() call
happening when processing transaction's forget list? Because the idea is
that such pages should be discarded at that point...

								Honza
> 
> ---
>  fs/jbd2/checkpoint.c | 11 +++++++++++
>  fs/jbd2/commit.c     |  2 +-
>  include/linux/jbd2.h |  1 +
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 4227dc4..bf68442 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -529,6 +529,7 @@ int __jbd2_journal_remove_checkpoint(struct journal_head *jh)
>  	transaction_t *transaction;
>  	journal_t *journal;
>  	int ret = 0;
> +	struct buffer_head *bh;
>  
>  	JBUFFER_TRACE(jh, "entry");
>  
> @@ -538,10 +539,20 @@ int __jbd2_journal_remove_checkpoint(struct journal_head *jh)
>  	}
>  	journal = transaction->t_journal;
>  
> +	bh = jh2bh(jh);
> +	get_bh(bh);
>  	JBUFFER_TRACE(jh, "removing from transaction");
>  	__buffer_unlink(jh);
>  	jh->b_cp_transaction = NULL;
>  	jbd2_journal_put_journal_head(jh);
> +	/*
> +	 * if journal head is freed, try to free buffers from a truncated
> +	 * page, if page buffers are not busy and page->mapping is NULL
> +	 */
> +	if (!buffer_jbd(bh))
> +		release_buffer_page(bh);
> +	else
> +		__brelse(bh);
>  
>  	if (transaction->t_checkpoint_list != NULL ||
>  	    transaction->t_checkpoint_io_list != NULL)
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index b73e021..d94ec3f 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -63,7 +63,7 @@ static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
>   * Called under lock_journal(), and possibly under journal_datalist_lock.  The
>   * caller provided us with a ref against the buffer, and we drop that here.
>   */
> -static void release_buffer_page(struct buffer_head *bh)
> +void release_buffer_page(struct buffer_head *bh)
>  {
>  	struct page *page;
>  
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index edb640a..523f345 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1039,6 +1039,7 @@ int __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
>  void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
>  
>  /* Commit management */
> +extern void release_buffer_page(struct buffer_head *);
>  extern void jbd2_journal_commit_transaction(journal_t *);
>  
>  /* Checkpoint list management */
> 
> ----------------------------------------------------------
> > 
> > 					- Ted
> > 
> > 
> > 
> > 
> > 
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
