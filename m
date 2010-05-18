From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/4] block: Implement a blk_yield function to
	voluntarily give up the I/O scheduler.
Date: Tue, 18 May 2010 17:07:52 -0400
Message-ID: <20100518210752.GE12330@redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com> <1274206820-17071-3-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jens.axboe@oracle.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1274206820-17071-3-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 18, 2010 at 02:20:18PM -0400, Jeff Moyer wrote:
> This patch implements a blk_yield to allow a process to voluntarily
> give up its I/O scheduler time slice.  This is desirable for those processes
> which know that they will be blocked on I/O from another process, such as
> the file system journal thread.  Following patches will put calls to blk_yield
> into jbd and jbd2.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  block/blk-core.c         |   13 +++++
>  block/blk-settings.c     |    6 +++
>  block/cfq-iosched.c      |  112 +++++++++++++++++++++++++++++++++++++++++++++-
>  block/elevator.c         |    8 +++
>  include/linux/blkdev.h   |    4 ++
>  include/linux/elevator.h |    3 +
>  6 files changed, 144 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9fe174d..b8be6c8 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -323,6 +323,18 @@ void blk_unplug(struct request_queue *q)
>  }
>  EXPORT_SYMBOL(blk_unplug);
>  
> +void generic_yield_iosched(struct request_queue *q, struct task_struct *tsk)
> +{
> +	elv_yield(q, tsk);
> +}
> +
> +void blk_yield(struct request_queue *q, struct task_struct *tsk)
> +{
> +	if (q->yield_fn)
> +		q->yield_fn(q, tsk);
> +}
> +EXPORT_SYMBOL(blk_yield);
> +
>  /**
>   * blk_start_queue - restart a previously stopped queue
>   * @q:    The &struct request_queue in question
> @@ -580,6 +592,7 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
>  	q->request_fn		= rfn;
>  	q->prep_rq_fn		= NULL;
>  	q->unplug_fn		= generic_unplug_device;
> +	q->yield_fn		= generic_yield_iosched;
>  	q->queue_flags		= QUEUE_FLAG_DEFAULT;
>  	q->queue_lock		= lock;
>  
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index f5ed5a1..fe548c9 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -171,6 +171,12 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
>  }
>  EXPORT_SYMBOL(blk_queue_make_request);
>  
> +void blk_queue_yield(struct request_queue *q, yield_fn *yield)
> +{
> +	q->yield_fn = yield;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_yield);
> +
>  /**
>   * blk_queue_bounce_limit - set bounce buffer limit for queue
>   * @q: the request queue for the device
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 46a7fe5..9aab701 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -148,6 +148,7 @@ struct cfq_queue {
>  	struct cfq_queue *new_cfqq;
>  	struct cfq_group *cfqg;
>  	struct cfq_group *orig_cfqg;
> +	struct cfq_io_context *yield_to;
>  	/* Sectors dispatched in current dispatch round */
>  	unsigned long nr_sectors;
>  };
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
> @@ -2068,7 +2072,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  		slice = max(slice, 2 * cfqd->cfq_slice_idle);
>  
>  	slice = max_t(unsigned, slice, CFQ_MIN_TT);
> -	cfq_log(cfqd, "workload slice:%d", slice);
> +	cfq_log(cfqd, "workload:%d slice:%d", cfqd->serving_type, slice);
>  	cfqd->workload_expires = jiffies + slice;
>  	cfqd->noidle_tree_requires_idle = false;
>  }
> @@ -2138,7 +2142,8 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>  		 * ok to wait for this request to complete.
>  		 */
>  		if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
> -		    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
> +		    && cfqq->dispatched && !cfq_cfqq_yield(cfqq) &&
> +		    cfq_should_idle(cfqd, cfqq)) {
>  			cfqq = NULL;

I think if we just place cfq_cfqq_yield(cfqq), check above it, we don't
need above code modification?

This might result in some group losing fairness in certain scenarios, but
I guess we will tackle it once we face it. For the time being if fsync
thread is giving up cpu, journald commits will come in root group and
there might not be a point in wasting time idling on this group.

Vivek
