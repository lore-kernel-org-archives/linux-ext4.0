From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] blkdev: add flush generation counter
Date: Thu, 18 Apr 2013 16:34:59 +0200
Message-ID: <20130418143459.GA10243@quack.suse.cz>
References: <87wqs4kiyi.fsf@openvz.org>
 <1365968068-11766-1-git-send-email-dmonakhov@openvz.org>
 <20130415141439.GH2299@quack.suse.cz>
 <87sj2psfws.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, axboe@kernel.dk
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989Ab3DROfD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Apr 2013 10:35:03 -0400
Content-Disposition: inline
In-Reply-To: <87sj2psfws.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 17-04-13 12:46:43, Dmitry Monakhov wrote:
> On Mon, 15 Apr 2013 16:14:39 +0200, Jan Kara <jack@suse.cz> wrote:
> > On Sun 14-04-13 23:34:27, Dmitry Monakhov wrote:
> > > Callers may use this counter to optimize flushes
> > > 
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > > ---
> > >  block/blk-core.c       |    1 +
> > >  block/blk-flush.c      |    3 ++-
> > >  include/linux/blkdev.h |    1 +
> > >  3 files changed, 4 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > index 074b758..afb5a4b 100644
> > > --- a/block/blk-core.c
> > > +++ b/block/blk-core.c
> > > @@ -537,6 +537,7 @@ void blk_cleanup_queue(struct request_queue *q)
> > >  	spin_unlock_irq(lock);
> > >  	mutex_unlock(&q->sysfs_lock);
> > >  
> > > +	atomic_set(&q->flush_tag, 0);
> > >  	/*
> > >  	 * Drain all requests queued before DYING marking. Set DEAD flag to
> > >  	 * prevent that q->request_fn() gets invoked after draining finished.
> > > diff --git a/block/blk-flush.c b/block/blk-flush.c
> > > index cc2b827..b1adc75 100644
> > > --- a/block/blk-flush.c
> > > +++ b/block/blk-flush.c
> > > @@ -203,7 +203,7 @@ static void flush_end_io(struct request *flush_rq, int error)
> > >  	/* account completion of the flush request */
> > >  	q->flush_running_idx ^= 1;
> > >  	elv_completed_request(q, flush_rq);
> > > -
> > > +	atomic_inc(&q->flush_tag);
> > >  	/* and push the waiting requests to the next stage */
> > >  	list_for_each_entry_safe(rq, n, running, flush.list) {
> > >  		unsigned int seq = blk_flush_cur_seq(rq);
> > > @@ -268,6 +268,7 @@ static bool blk_kick_flush(struct request_queue *q)
> > >  	q->flush_rq.end_io = flush_end_io;
> > >  
> > >  	q->flush_pending_idx ^= 1;
> > > +	atomic_inc(&q->flush_tag);
> > >  	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
> > >  	return true;
> > >  }
> >   But this doesn't quite work, does it? When fs reads flush_tag counter,
> > CACHE_FLUSH command can be already issued so you are not sure how the IO
> > you are issuing relates to the cache flush in flight. If you want to make
> > this work, you really need two counters - one for flush submissions and one
> > for flush completions. Fs would need to read the submission counter before
> > issuing the IO and the completion counter when it wants to make sure date is
> > on the stable storage. But it all gets somewhat complex and I'm not sure
> > it's worth it given the block layer tries to merge flush requests by
> > itself. But you can try for correct implementation and measure the
> > performance impact of course...
> 
> Probably I've missed good comments, but I've tried to make things correct
> Here are an flush implementation assumptions from block/blk-flush.c:
> 
> Currently, the following conditions are used to determine when to e flush.
> 
> C1. At any given time, only one flush shall be in progress.  This is
>     double buffering sufficient.
> C2. Flush is deferred if any request is executing DATA of its ence.
>     This avoids issuing separate POSTFLUSHes for requests which ed
>     PREFLUSH.
> C3. The second condition is ignored if there is a request which has
>     waited longer than FLUSH_PENDING_TIMEOUT.  This is to avoid
>     starvation in the unlikely case where there are continuous am of
>     FUA (without FLUSH) requests.
> 
> So if we will increment flush_tag counter in two places:
> blk_kick_flush: the place where flush request is issued
> flush_end_io : the place where flush is completed
> And by using rule (C1) we can guarantee that
> 
> if (flush_tag & 0x1 == 1) then flush_tag  is in progress
> if (flush_tag & 0x1 == 0) then (flush_tag & ~(0x1)) completed
> In other words we can define it as:
> 
> FLUSH_TAG_IDX    = (flush_tag +1) & ~0x1
> FLUSH_TAG_STATE  = flush_tag & 0x1 ? IN_PROGRESS : COMPLETED
> 
> After that we can define rules for flush optimization:
> We can be sure that our data was flushed only if:
> 1) data's bio was completed before flush request was QUEUED
>    and COMPLETED
> So in terms of formulas we can write it like follows:
> is_data_flushed = (blkdev->flush_tag & ~(0x1)) >
>                   ((data->flush_tag + 0x1) & (~0x1))
  Ah, clever! But then please
a) create a function with the condition so that it doesn't have to be
   opencoded in every place using the counter
b) add a detailed comment before that function explaining why it works.
   Something like what you wrote in this email...

  Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
