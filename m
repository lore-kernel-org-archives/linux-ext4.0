From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
Date: Mon, 17 Dec 2012 14:56:17 -0800
Message-ID: <20121217225617.GB10874@blackbox.djwong.org>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080811.23360.98131.stgit@blackbox.djwong.org>
 <20121216161336.GA6243@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25711 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LQW5k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Dec 2012 17:57:40 -0500
Content-Disposition: inline
In-Reply-To: <20121216161336.GA6243@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2012 at 12:13:36AM +0800, Zheng Liu wrote:
> On Thu, Dec 13, 2012 at 12:08:11AM -0800, Darrick J. Wong wrote:
> > diff --git a/mm/bounce.c b/mm/bounce.c
> > index 0420867..fa11935 100644
> > --- a/mm/bounce.c
> > +++ b/mm/bounce.c
> > @@ -178,6 +178,38 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
> >  	__bounce_end_io_read(bio, isa_page_pool, err);
> >  }
> >  
> > +#ifdef CONFIG_NEED_BOUNCE_POOL
> > +static int might_snapshot_stable_page_write(struct bio **bio_orig)
> > +{
> > +	return bio_data_dir(*bio_orig) == WRITE;
> > +}
> > +
> > +static int should_snapshot_stable_pages(struct page *page, int rw)
> > +{
> > +	struct backing_dev_info *bdi;
> > +	struct address_space *mapping = page_mapping(page);
> > +
> > +	if (!mapping)
> > +		return 0;
> > +	bdi = mapping->backing_dev_info;
> > +	if (!bdi_cap_stable_pages_required(bdi))
> > +		return 0;
> > +
> > +	return mapping->host->i_sb->s_flags & MS_SNAP_STABLE &&
> > +	       rw == WRITE;
> > +}
> > +#else
> > +static int might_snapshot_stable_page_write(struct bio **bio_orig)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int should_snapshot_static_pages(struct page *page, int rw)
>                               ^^^^^^
>                               It should be _stable_.

Good catch!  Thank you!

--D
> 
> Regards,
>                                                 - Zheng
> > +{
> > +	return 0;
> > +}
> > +#endif /* CONFIG_NEED_BOUNCE_POOL */
> > +
> >  static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
> >  			       mempool_t *pool)
> >  {
> > @@ -192,7 +224,8 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
> >  		/*
> >  		 * is destination page below bounce pfn?
> >  		 */
> > -		if (page_to_pfn(page) <= queue_bounce_pfn(q))
> > +		if (page_to_pfn(page) <= queue_bounce_pfn(q) &&
> > +		    !should_snapshot_stable_pages(page, rw))
> >  			continue;
> >  
> >  		/*
> > @@ -284,7 +317,8 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
> >  	 * don't waste time iterating over bio segments
> >  	 */
> >  	if (!(q->bounce_gfp & GFP_DMA)) {
> > -		if (queue_bounce_pfn(q) >= blk_max_pfn)
> > +		if (queue_bounce_pfn(q) >= blk_max_pfn &&
> > +		    !might_snapshot_stable_page_write(bio_orig))
> >  			return;
> >  		pool = page_pool;
> >  	} else {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
