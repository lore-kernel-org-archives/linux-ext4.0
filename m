From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/2] block: skip elevator initialization for flush
 requests
Date: Wed, 2 Feb 2011 17:06:49 -0500
Message-ID: <20110202220649.GA20538@redhat.com>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202215152.GC12559@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
	tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110202215152.GC12559@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 02 2011 at  4:51pm -0500,
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Feb 01, 2011 at 05:46:12PM -0500, Mike Snitzer wrote:
> > Skip elevator initialization during request allocation if REQ_SORTED
> > is not set in the @rw_flags passed to the request allocator.
> > 
> > Set REQ_SORTED for all requests that may be put on IO scheduler.  Flush
> > requests are not put on IO scheduler so REQ_SORTED is not set for
> > them.
> 
> So we are doing all this so that elevator_private and flush data can
> share the space through union and we can avoid increasing the size
> of struct rq by 1 pointer (4 or 8 bytes depneding on arch)? 

Correct.

> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 72dd23b..f6fcc64 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1197,6 +1202,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
> >  	const unsigned short prio = bio_prio(bio);
> >  	const bool sync = !!(bio->bi_rw & REQ_SYNC);
> >  	const bool unplug = !!(bio->bi_rw & REQ_UNPLUG);
> > +	const bool flush = !!(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
> >  	const unsigned long ff = bio->bi_rw & REQ_FAILFAST_MASK;
> >  	int where = ELEVATOR_INSERT_SORT;
> >  	int rw_flags;
> > @@ -1210,7 +1216,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
> >  
> >  	spin_lock_irq(q->queue_lock);
> >  
> > -	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
> > +	if (flush) {
> >  		where = ELEVATOR_INSERT_FLUSH;
> >  		goto get_rq;
> >  	}
> > @@ -1293,6 +1299,14 @@ get_rq:
> >  		rw_flags |= REQ_SYNC;
> >  
> >  	/*
> > +	 * Set REQ_SORTED for all requests that may be put on IO scheduler.
> > +	 * The request allocator's IO scheduler initialization will be skipped
> > +	 * if REQ_SORTED is not set.
> > +	 */
> 
> Do you want to mention here that why do we want to avoid IO scheduler
> initialization. Specifically mention that set_request() is avoided so
> that elevator_private[*] are not initialized and that space can be
> used by flush request data.

Sure, I'll post a v3 for this patch with that edit and your Acked-by.

Thanks,
Mike
