From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to
 provide stable pages during write
Date: Mon, 17 Dec 2012 11:23:59 +0100
Message-ID: <20121217102359.GH5133@quack.suse.cz>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080811.23360.98131.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2LQKYN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2012 05:24:13 -0500
Content-Disposition: inline
In-Reply-To: <20121213080811.23360.98131.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 13-12-12 00:08:11, Darrick J. Wong wrote:
> Several complaints have been received regarding long file write latencies when
> memory pages must be held stable during writeback.  Since it might not be
> acceptable to stall programs for the entire duration of a page write (which may
> take many milliseconds even on good hardware), enable a second strategy wherein
> pages are snapshotted as part of submit_bio; the snapshot can be held stable
> while writes continue.
> 
> This provides a band-aid to provide stable page writes on jbd without needing
> to backport the fixed locking scheme in jbd2.  A mount option is added to ext4
> to allow administrators to enable it there.
> 
> For those wondering about the ext3 bandage -- fixing the jbd locking (which was
> done as part of ext4dev years ago) is a lot of surgery, and setting
> PG_writeback on data pages when we actually hold the page lock dropped ext3
> performance by nearly an order of magnitude.  If we're going to migrate iscsi
> and raid to use stable page writes, the complaints about high latency will
> likely return.  We might as well centralize their page snapshotting thing to
> one place.
  Umm, I kind of like this solution for ext3...

> diff --git a/mm/Kconfig b/mm/Kconfig
> index a3f8ddd..78db0e1 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -224,6 +224,16 @@ config BOUNCE
>  	def_bool y
>  	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
>  
> +# On the 'tile' arch, USB OHCI needs the bounce pool since tilegx will often
> +# have more than 4GB of memory, but we don't currently use the IOTLB to present
> +# a 32-bit address to OHCI.  So we need to use a bounce pool instead.
> +#
> +# We also use the bounce pool to provide stable page writes for users that
> +# don't (or can't) afford the wait latency.
> +config NEED_BOUNCE_POOL
> +	bool
> +	default y if (TILE && USB_OHCI_HCD) || (BLK_DEV_INTEGRITY && (EXT3_FS || EXT4_FS))
> +
  This means that NEED_BOUNCE_POOL is going to be enabled on pretty much
any distro kernel...

>  config NR_QUICK
>  	int
>  	depends on QUICKLIST
> diff --git a/mm/bounce.c b/mm/bounce.c
> index 0420867..fa11935 100644
> --- a/mm/bounce.c
> +++ b/mm/bounce.c
> @@ -178,6 +178,38 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
>  	__bounce_end_io_read(bio, isa_page_pool, err);
>  }
>  
> +#ifdef CONFIG_NEED_BOUNCE_POOL
> +static int might_snapshot_stable_page_write(struct bio **bio_orig)
> +{
> +	return bio_data_dir(*bio_orig) == WRITE;
> +}
... so might might_snapshot_stable_page_write() will be true for each
write. And thus blk_queue_bounce() becomes considerably more expensive?
Also calling should_snapshot_stable_pages() for every page seems to be
stupid since its result is going to be the same for all the pages in the
bio (well, I could imagine setups where it won't be but do we want to
support them?).

So cannot we just make a function like should_snapshot_stable_pages() to
test whether we really need the bouncing, use it in blk_queue_bounce() and
then pass the information to __blk_queue_bounce() if needed?

								Honza

> +static int should_snapshot_stable_pages(struct page *page, int rw)
> +{
> +	struct backing_dev_info *bdi;
> +	struct address_space *mapping = page_mapping(page);
> +
> +	if (!mapping)
> +		return 0;
> +	bdi = mapping->backing_dev_info;
> +	if (!bdi_cap_stable_pages_required(bdi))
> +		return 0;
> +
> +	return mapping->host->i_sb->s_flags & MS_SNAP_STABLE &&
> +	       rw == WRITE;
> +}
> +#else
> +static int might_snapshot_stable_page_write(struct bio **bio_orig)
> +{
> +	return 0;
> +}
> +
> +static int should_snapshot_static_pages(struct page *page, int rw)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_NEED_BOUNCE_POOL */
> +
>  static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  			       mempool_t *pool)
>  {
> @@ -192,7 +224,8 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
>  		/*
>  		 * is destination page below bounce pfn?
>  		 */
> -		if (page_to_pfn(page) <= queue_bounce_pfn(q))
> +		if (page_to_pfn(page) <= queue_bounce_pfn(q) &&
> +		    !should_snapshot_stable_pages(page, rw))
>  			continue;
>  
>  		/*
> @@ -284,7 +317,8 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
>  	 * don't waste time iterating over bio segments
>  	 */
>  	if (!(q->bounce_gfp & GFP_DMA)) {
> -		if (queue_bounce_pfn(q) >= blk_max_pfn)
> +		if (queue_bounce_pfn(q) >= blk_max_pfn &&
> +		    !might_snapshot_stable_page_write(bio_orig))
>  			return;
>  		pool = page_pool;
>  	} else {
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 3e4a8cc..fbd8efb 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2291,6 +2291,10 @@ void wait_for_stable_page(struct page *page)
>  
>  	if (!bdi_cap_stable_pages_required(bdi))
>  		return;
> +#ifdef CONFIG_NEED_BOUNCE_POOL
> +	if (mapping->host->i_sb->s_flags & MS_SNAP_STABLE)
> +		return;
> +#endif /* CONFIG_NEED_BOUNCE_POOL */
>  
>  	wait_on_page_writeback(page);
>  }
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
