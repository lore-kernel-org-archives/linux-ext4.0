From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 3/5] fs: add nofail variant of alloc_buffer_head
Date: Tue, 24 Aug 2010 14:17:03 +0200
Message-ID: <20100824121702.GC3713@quack.suse.cz>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008240347070.19596@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab0HXMRt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Aug 2010 08:17:49 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008240347070.19596@chino.kir.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-08-10 03:50:30, David Rientjes wrote:
> Add alloc_buffer_head_nofail().  This function is equivalent to
> alloc_buffer_head(), except that it will never return NULL and instead
> loop forever trying to allocate memory.
> 
> If the first allocation attempt fails, a warning will be emitted,
> including a call trace.  Subsequent failures will suppress this warning.
> 
> This was added as a helper function for documentation and auditability.
> No future callers should be added.
  Acked-by: Jan Kara <jack@suse.cz>
for the JBD part here as well.

								Honza
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  fs/buffer.c                 |   18 ++++++++++++++++++
>  fs/gfs2/log.c               |    2 +-
>  fs/jbd/journal.c            |    2 +-
>  include/linux/buffer_head.h |    1 +
>  4 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3238,6 +3238,24 @@ struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
>  }
>  EXPORT_SYMBOL(alloc_buffer_head);
>  
> +/*
> + * NOTE: no new callers of this function should be implemented!
> + * All memory allocations should be failable whenever possible.
> + */
> +struct buffer_head *alloc_buffer_head_nofail(gfp_t gfp_flags)
> +{
> +	struct buffer_head *ret;
> +
> +	for (;;) {
> +		ret = alloc_buffer_head(gfp_flags);
> +		if (ret)
> +			return ret;
> +		WARN_ONCE(1, "Out of memory; no fallback implemented "
> +				"(flags=0x%x)\n",
> +				gfp_flags);
> +	}
> +}
> +
>  void free_buffer_head(struct buffer_head *bh)
>  {
>  	BUG_ON(!list_empty(&bh->b_assoc_buffers));
> diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> --- a/fs/gfs2/log.c
> +++ b/fs/gfs2/log.c
> @@ -523,7 +523,7 @@ struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
>  	u64 blkno = log_bmap(sdp, sdp->sd_log_flush_head);
>  	struct buffer_head *bh;
>  
> -	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
> +	bh = alloc_buffer_head_nofail(GFP_NOFS);
>  	atomic_set(&bh->b_count, 1);
>  	bh->b_state = (1 << BH_Mapped) | (1 << BH_Uptodate) | (1 << BH_Lock);
>  	set_bh_page(bh, real->b_page, bh_offset(real));
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -301,7 +301,7 @@ int journal_write_metadata_buffer(transaction_t *transaction,
>  	 */
>  	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
>  
> -	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
> +	new_bh = alloc_buffer_head_nofail(GFP_NOFS);
>  	/* keep subsequent assertions sane */
>  	new_bh->b_state = 0;
>  	init_buffer(new_bh, NULL, NULL);
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -176,6 +176,7 @@ void __breadahead(struct block_device *, sector_t block, unsigned int size);
>  struct buffer_head *__bread(struct block_device *, sector_t block, unsigned size);
>  void invalidate_bh_lrus(void);
>  struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
> +struct buffer_head *alloc_buffer_head_nofail(gfp_t gfp_flags);
>  void free_buffer_head(struct buffer_head * bh);
>  void unlock_buffer(struct buffer_head *bh);
>  void __lock_buffer(struct buffer_head *bh);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
