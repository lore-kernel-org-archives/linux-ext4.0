From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/4] block: Implement a blk_yield function to
	voluntarily give up the I/O scheduler.
Date: Wed, 14 Apr 2010 17:46:54 -0400
Message-ID: <20100414214654.GD3167@redhat.com>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com> <1271279826-30294-3-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000Ab0DNVq7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 17:46:59 -0400
Content-Disposition: inline
In-Reply-To: <1271279826-30294-3-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 14, 2010 at 05:17:04PM -0400, Jeff Moyer wrote:
> This patch implements a blk_yield to allow a process to voluntarily
> give up its I/O scheduler time slice.  This is desirable for those processes
> which know that they will be blocked on I/O from another process, such as
> the file system journal thread.  Following patches will put calls to blk_yield
> into jbd and jbd2.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  block/blk-core.c         |    6 ++++
>  block/cfq-iosched.c      |   70 ++++++++++++++++++++++++++++++++++++++++++++++
>  block/elevator.c         |    8 +++++
>  include/linux/blkdev.h   |    1 +
>  include/linux/elevator.h |    3 ++
>  5 files changed, 88 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9fe174d..3e4e98c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -323,6 +323,12 @@ void blk_unplug(struct request_queue *q)
>  }
>  EXPORT_SYMBOL(blk_unplug);
>  
> +void blk_yield(struct request_queue *q)
> +{
> +	elv_yield(q);
> +}
> +EXPORT_SYMBOL(blk_yield);
> +
>  /**
>   * blk_start_queue - restart a previously stopped queue
>   * @q:    The &struct request_queue in question
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index ef59ab3..8a300ab 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -292,6 +292,7 @@ struct cfq_data {
>  };
>  
>  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> +static void cfq_yield_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq);
>  
>  static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
>  					    enum wl_prio_t prio,
> @@ -320,6 +321,7 @@ enum cfqq_state_flags {
>  	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
>  	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
>  	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
> +	CFQ_CFQQ_FLAG_yield,		/* Allow another cfqq to run */
>  };
>  
>  #define CFQ_CFQQ_FNS(name)						\
> @@ -349,6 +351,7 @@ CFQ_CFQQ_FNS(coop);
>  CFQ_CFQQ_FNS(split_coop);
>  CFQ_CFQQ_FNS(deep);
>  CFQ_CFQQ_FNS(wait_busy);
> +CFQ_CFQQ_FNS(yield);
>  #undef CFQ_CFQQ_FNS
>  
>  #ifdef CONFIG_DEBUG_CFQ_IOSCHED
> @@ -1566,6 +1569,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  
>  	cfq_clear_cfqq_wait_request(cfqq);
>  	cfq_clear_cfqq_wait_busy(cfqq);
> +	cfq_clear_cfqq_yield(cfqq);
>  
>  	/*
>  	 * If this cfqq is shared between multiple processes, check to
> @@ -1887,6 +1891,9 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
>  
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
>  	cfqq->nr_sectors += blk_rq_sectors(rq);
> +
> +	if (cfq_cfqq_yield(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
> +		cfq_yield_cfqq(cfqd, cfqq);

Jeff,

I am wondering if cfq_select_queue() will be a better place for yielding
the queue.

	if (cfq_cfqq_yield(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
			goto expire;

We can avoid one unnecessary __blk_run_queue().

Apart from above minor nit, it looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

>  }
>  
>  /*
> @@ -2191,6 +2198,68 @@ keep_queue:
>  	return cfqq;
>  }
>  
> +static void cfq_yield_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> +{
> +	__cfq_slice_expired(cfqd, cfqq, 1);
> +	__blk_run_queue(cfqd->queue);
> +}
> +
> +static void cfq_yield(struct request_queue *q)
> +{
> +	struct cfq_data *cfqd = q->elevator->elevator_data;
> +	struct cfq_io_context *cic;
> +	struct cfq_queue *cfqq;
> +
> +	cic = cfq_cic_lookup(cfqd, current->io_context);
> +	if (!cic)
> +		return;
> +
> +	spin_lock_irq(q->queue_lock);
> +
> +	/*
> +	 * This is primarily called to ensure that the long synchronous
> +	 * time slice does not prevent other I/O happenning (like journal
> +	 * commits) while we idle waiting for it.  Thus, check to see if the
> +	 * current cfqq is the sync cfqq for this process.
> +	 */
> +	cfqq = cic_to_cfqq(cic, 1);
> +	if (!cfqq)
> +		goto out_unlock;
> +
> +	if (cfqd->active_queue != cfqq)
> +		goto out_unlock;
> +
> +	/*
> +	 * If we are currently servicing the SYNC_NOIDLE_WORKLOAD, and we
> +	 * are idling on the last queue in that workload, *and* the average
> +	 * think time is larger thank the remaining slice time, go ahead
> +	 * and yield the queue.  Otherwise, don't yield so that fsync-heavy
> +	 * workloads don't starve out the sync-noidle workload.
> +	 */
> +	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
> +	    (!sample_valid(cfqq->service_tree->ttime_samples) ||
> +	     cfqq->slice_end - jiffies > cfqq->service_tree->ttime_mean))
> +		goto out_unlock;
> +
> +
> +	cfq_log_cfqq(cfqd, cfqq, "yielding queue");
> +
> +	/*
> +	 * If there are other requests pending, just mark the queue as
> +	 * yielding and give up our slice after the last request is
> +	 * dispatched.
> +	 */
> +	if (!RB_EMPTY_ROOT(&cfqq->sort_list)) {
> +		cfq_mark_cfqq_yield(cfqq);
> +		goto out_unlock;
> +	}
> +
> +	cfq_yield_cfqq(cfqd, cfqq);
> +
> +out_unlock:
> +	spin_unlock_irq(q->queue_lock);
> +}
> +
>  static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
>  {
>  	int dispatched = 0;
> @@ -3911,6 +3980,7 @@ static struct elevator_type iosched_cfq = {
>  		.elevator_deactivate_req_fn =	cfq_deactivate_request,
>  		.elevator_queue_empty_fn =	cfq_queue_empty,
>  		.elevator_completed_req_fn =	cfq_completed_request,
> +		.elevator_yield_fn =		cfq_yield,
>  		.elevator_former_req_fn =	elv_rb_former_request,
>  		.elevator_latter_req_fn =	elv_rb_latter_request,
>  		.elevator_set_req_fn =		cfq_set_request,
> diff --git a/block/elevator.c b/block/elevator.c
> index 76e3702..6b16421 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -855,6 +855,14 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
>  	}
>  }
>  
> +void elv_yield(struct request_queue *q)
> +{
> +	struct elevator_queue *e = q->elevator;
> +
> +	if (e && e->ops->elevator_yield_fn)
> +		e->ops->elevator_yield_fn(q);
> +}
> +
>  #define to_elv(atr) container_of((atr), struct elv_fs_entry, attr)
>  
>  static ssize_t
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 6690e8b..0e749e2 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -833,6 +833,7 @@ extern int blk_execute_rq(struct request_queue *, struct gendisk *,
>  extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
>  				  struct request *, int, rq_end_io_fn *);
>  extern void blk_unplug(struct request_queue *q);
> +extern void blk_yield(struct request_queue *q);
>  
>  static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>  {
> diff --git a/include/linux/elevator.h b/include/linux/elevator.h
> index 1cb3372..9b4e2e9 100644
> --- a/include/linux/elevator.h
> +++ b/include/linux/elevator.h
> @@ -20,6 +20,7 @@ typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
>  typedef int (elevator_queue_empty_fn) (struct request_queue *);
>  typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
>  typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
> +typedef void (elevator_yield_fn) (struct request_queue *);
>  typedef int (elevator_may_queue_fn) (struct request_queue *, int);
>  
>  typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
> @@ -44,6 +45,7 @@ struct elevator_ops
>  
>  	elevator_queue_empty_fn *elevator_queue_empty_fn;
>  	elevator_completed_req_fn *elevator_completed_req_fn;
> +	elevator_yield_fn *elevator_yield_fn;
>  
>  	elevator_request_list_fn *elevator_former_req_fn;
>  	elevator_request_list_fn *elevator_latter_req_fn;
> @@ -105,6 +107,7 @@ extern void elv_merge_requests(struct request_queue *, struct request *,
>  extern void elv_merged_request(struct request_queue *, struct request *, int);
>  extern void elv_requeue_request(struct request_queue *, struct request *);
>  extern int elv_queue_empty(struct request_queue *);
> +extern void elv_yield(struct request_queue *);
>  extern struct request *elv_former_request(struct request_queue *, struct request *);
>  extern struct request *elv_latter_request(struct request_queue *, struct request *);
>  extern int elv_register_queue(struct request_queue *q);
> -- 
> 1.6.2.5
