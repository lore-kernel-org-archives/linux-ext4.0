From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 4/3] block: skip elevator initialization for flush
 requests
Date: Tue, 1 Feb 2011 12:38:46 -0500
Message-ID: <20110201173846.GA25252@redhat.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110125204158.GA3013@redhat.com>
 <20110126100322.GC12520@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1BASLm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Feb 2011 13:11:42 -0500
Content-Disposition: inline
In-Reply-To: <20110126100322.GC12520@htj.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 26 2011 at  5:03am -0500,
Tejun Heo <tj@kernel.org> wrote:

> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 72dd23b..f507888 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -764,7 +764,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
> >  	struct request_list *rl = &q->rq;
> >  	struct io_context *ioc = NULL;
> >  	const bool is_sync = rw_is_sync(rw_flags) != 0;
> > -	int may_queue, priv;
> > +	int may_queue, priv = 0;
> >  
> >  	may_queue = elv_may_queue(q, rw_flags);
> >  	if (may_queue == ELV_MQUEUE_NO)
> > @@ -808,9 +808,14 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
> >  	rl->count[is_sync]++;
> >  	rl->starved[is_sync] = 0;
> >  
> > -	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
> > -	if (priv)
> > -		rl->elvpriv++;
> > +	/*
> > +	 * Skip elevator initialization for flush requests
> > +	 */
> > +	if (!(bio && (bio->bi_rw & (REQ_FLUSH | REQ_FUA)))) {
> > +		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
> > +		if (priv)
> > +			rl->elvpriv++;
> > +	}
> 
> I thought about doing it this way but I think we're burying the
> REQ_FLUSH|REQ_FUA test logic too deep.  get_request() shouldn't
> "magically" know not to allocate elevator data.

There is already a considerable amount of REQ_FLUSH|REQ_FUA special
casing magic sprinkled though-out the block layer.  Why is this
get_request() change the case that goes too far?

> The decision should
> be made higher in the stack and passed down to get_request().  e.g. if
> REQ_SORTED is set in @rw, elevator data is allocated; otherwise, not.

Considering REQ_SORTED is set in elv_insert(), well after get_request() 
is called, I'm not seeing what you're suggesting.

Anyway, I agree that ideally we'd have a mechanism to explicitly
short-circuit elevator initialization.  But doing so in a meaningful way
would likely require a fair amount of refactoring of get_request* and
its callers.  I'll come back to this and have another look but my gut is
this interface churn wouldn't _really_ help -- all things considered.

> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 8a082a5..0c569ec 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -99,25 +99,29 @@ struct request {
> >  	/*
> >  	 * The rb_node is only used inside the io scheduler, requests
> >  	 * are pruned when moved to the dispatch queue. So let the
> > -	 * flush fields share space with the rb_node.
> > +	 * completion_data share space with the rb_node.
> >  	 */
> >  	union {
> >  		struct rb_node rb_node;	/* sort/lookup */
> > -		struct {
> > -			unsigned int			seq;
> > -			struct list_head		list;
> > -		} flush;
> > +		void *completion_data;
> >  	};
> >  
> > -	void *completion_data;
> > -
> >  	/*
> >  	 * Three pointers are available for the IO schedulers, if they need
> > -	 * more they have to dynamically allocate it.
> > +	 * more they have to dynamically allocate it.  Let the flush fields
> > +	 * share space with these three pointers.
> >  	 */
> > -	void *elevator_private;
> > -	void *elevator_private2;
> > -	void *elevator_private3;
> > +	union {
> > +		struct {
> > +			void *private;
> > +			void *private2;
> > +			void *private3;
> > +		} elevator;
> > +		struct {
> > +			unsigned int			seq;
> > +			struct list_head		list;
> > +		} flush;
> > +	};
> 
> Another thing is, can we please make private* an array?  The number
> postfixes are irksome.  It's even one based instead of zero!

Sure, I can sort that out.

> > Also, it would be great to better describe the lifetime difference
> > between the first and the second unions and why it has be organized
> > this way (rb_node and completion_data can live together but rb_node
> > and flush can't).
>
> Oops, what can't live together are elevator_private* and
> completion_data.

I'll better describe the 2nd union's sharing in the next revision.

Mike
