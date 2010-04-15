From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/4] block: Implement a blk_yield function to
	voluntarily give up the I/O scheduler.
Date: Thu, 15 Apr 2010 12:33:23 +0200
Message-ID: <20100415103323.GW27497@kernel.dk>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com> <1271279826-30294-3-git-send-email-jmoyer@redhat.com> <20100414214654.GD3167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52891 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab0DOKdY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Apr 2010 06:33:24 -0400
Content-Disposition: inline
In-Reply-To: <20100414214654.GD3167@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 14 2010, Vivek Goyal wrote:
> On Wed, Apr 14, 2010 at 05:17:04PM -0400, Jeff Moyer wrote:
> > This patch implements a blk_yield to allow a process to voluntarily
> > give up its I/O scheduler time slice.  This is desirable for those processes
> > which know that they will be blocked on I/O from another process, such as
> > the file system journal thread.  Following patches will put calls to blk_yield
> > into jbd and jbd2.
> > 
> > Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> > ---
> >  block/blk-core.c         |    6 ++++
> >  block/cfq-iosched.c      |   70 ++++++++++++++++++++++++++++++++++++++++++++++
> >  block/elevator.c         |    8 +++++
> >  include/linux/blkdev.h   |    1 +
> >  include/linux/elevator.h |    3 ++
> >  5 files changed, 88 insertions(+), 0 deletions(-)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 9fe174d..3e4e98c 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -323,6 +323,12 @@ void blk_unplug(struct request_queue *q)
> >  }
> >  EXPORT_SYMBOL(blk_unplug);
> >  
> > +void blk_yield(struct request_queue *q)
> > +{
> > +	elv_yield(q);
> > +}
> > +EXPORT_SYMBOL(blk_yield);
> > +
> >  /**
> >   * blk_start_queue - restart a previously stopped queue
> >   * @q:    The &struct request_queue in question
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index ef59ab3..8a300ab 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -292,6 +292,7 @@ struct cfq_data {
> >  };
> >  
> >  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> > +static void cfq_yield_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq);
> >  
> >  static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
> >  					    enum wl_prio_t prio,
> > @@ -320,6 +321,7 @@ enum cfqq_state_flags {
> >  	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
> >  	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
> >  	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
> > +	CFQ_CFQQ_FLAG_yield,		/* Allow another cfqq to run */
> >  };
> >  
> >  #define CFQ_CFQQ_FNS(name)						\
> > @@ -349,6 +351,7 @@ CFQ_CFQQ_FNS(coop);
> >  CFQ_CFQQ_FNS(split_coop);
> >  CFQ_CFQQ_FNS(deep);
> >  CFQ_CFQQ_FNS(wait_busy);
> > +CFQ_CFQQ_FNS(yield);
> >  #undef CFQ_CFQQ_FNS
> >  
> >  #ifdef CONFIG_DEBUG_CFQ_IOSCHED
> > @@ -1566,6 +1569,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >  
> >  	cfq_clear_cfqq_wait_request(cfqq);
> >  	cfq_clear_cfqq_wait_busy(cfqq);
> > +	cfq_clear_cfqq_yield(cfqq);
> >  
> >  	/*
> >  	 * If this cfqq is shared between multiple processes, check to
> > @@ -1887,6 +1891,9 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
> >  
> >  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
> >  	cfqq->nr_sectors += blk_rq_sectors(rq);
> > +
> > +	if (cfq_cfqq_yield(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
> > +		cfq_yield_cfqq(cfqd, cfqq);
> 
> Jeff,
> 
> I am wondering if cfq_select_queue() will be a better place for yielding
> the queue.
> 
> 	if (cfq_cfqq_yield(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
> 			goto expire;
> 
> We can avoid one unnecessary __blk_run_queue().

Agree, doing it on insert is not the right place.

-- 
Jens Axboe

