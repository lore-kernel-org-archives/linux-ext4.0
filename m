From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] block: Implement a blk_yield function to
 voluntarily give up the I/O scheduler.
Date: Tue, 22 Jun 2010 22:04:06 -0700
Message-ID: <20100622220406.690bb0c8.akpm@linux-foundation.org>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<1277242502-9047-2-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab0FWFEU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jun 2010 01:04:20 -0400
In-Reply-To: <1277242502-9047-2-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Jun 2010 17:35:00 -0400 Jeff Moyer <jmoyer@redhat.com> wrote:

> This patch implements a blk_yield to allow a process to voluntarily
> give up its I/O scheduler time slice.  This is desirable for those processes
> which know that they will be blocked on I/O from another process, such as
> the file system journal thread.  Following patches will put calls to blk_yield
> into jbd and jbd2.
> 

I'm looking through this patch series trying to find the
analysis/description of the cause for this (bad) performance problem. 
But all I'm seeing is implementation stuff :(  It's hard to review code
with your eyes shut.


> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -324,6 +324,18 @@ void blk_unplug(struct request_queue *q)
>  }
>  EXPORT_SYMBOL(blk_unplug);
>  
> +void generic_yield_iosched(struct request_queue *q, struct task_struct *tsk)
> +{
> +	elv_yield(q, tsk);
> +}

static?

>
> ...
>
> +void blk_queue_yield(struct request_queue *q, yield_fn *yield)
> +{
> +	q->yield_fn = yield;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_yield);

There's a tradition in the block layer of using truly awful identifiers
for functions-which-set-things.  But there's no good reason for
retaining that tradition.  blk_queue_yield_set(), perhaps.

(what name would you give an accessor which _reads_ q->yield_fn?  yup,
"blk_queue_yield()".  doh).

>  /**
>   * blk_queue_bounce_limit - set bounce buffer limit for queue
>   * @q: the request queue for the device
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index dab836e..a9922b9 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -87,9 +87,12 @@ struct cfq_rb_root {
>  	unsigned total_weight;
>  	u64 min_vdisktime;
>  	struct rb_node *active;
> +	unsigned long last_expiry;
> +	pid_t last_pid;

These fields are pretty fundamental to understanding the
implementation.  Some nice descriptions would be nice.

>  };
>  #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
> -			.count = 0, .min_vdisktime = 0, }
> +			.count = 0, .min_vdisktime = 0, .last_expiry = 0UL, \
> +			.last_pid = (pid_t)-1, }

May as well leave the 0 and NULL fields unmentioned (ie: don't do
crappy stuff because the old code did crappy stuff!)

>  /*
>   * Per process-grouping structure
> @@ -147,6 +150,7 @@ struct cfq_queue {
>  	struct cfq_queue *new_cfqq;
>  	struct cfq_group *cfqg;
>  	struct cfq_group *orig_cfqg;
> +	struct cfq_io_context *yield_to;
>  };
>  
>  /*
>
> ...
>
> +static int cfq_should_yield_now(struct cfq_queue *cfqq,
> +				struct cfq_queue **yield_to)

The bool-returning function could return a bool type.

> +{
> +	struct cfq_queue *new_cfqq;
> +
> +	new_cfqq = cic_to_cfqq(cfqq->yield_to, 1);
> +
> +	/*
> +	 * If the queue we're yielding to is in a different cgroup,
> +	 * just expire our own time slice.
> +	 */
> +	if (new_cfqq->cfqg != cfqq->cfqg) {
> +		*yield_to = NULL;
> +		return 1;
> +	}
> +
> +	/*
> +	 * If the new queue has pending I/O, then switch to it
> +	 * immediately.  Otherwise, see if we can idle until it is
> +	 * ready to preempt us.
> +	 */
> +	if (!RB_EMPTY_ROOT(&new_cfqq->sort_list)) {
> +		*yield_to = new_cfqq;
> +		return 1;
> +	}
> +
> +	*yield_to = NULL;
> +	return 0;
> +}
> +
>  /*
>   * Select a queue for service. If we have a current active queue,
>   * check whether to continue servicing it, or retrieve and set a new one.
>
> ...
>
> +static inline int expiry_data_valid(struct cfq_rb_root *service_tree)
> +{
> +	return (service_tree->last_pid != (pid_t)-1 &&
> +		service_tree->last_expiry != 0UL);
> +}

The compiler will inline this.

> +static void cfq_yield(struct request_queue *q, struct task_struct *tsk)

-ENODESCRIPTION

> +{
> +	struct cfq_data *cfqd = q->elevator->elevator_data;
> +	struct cfq_io_context *cic, *new_cic;
> +	struct cfq_queue *cfqq;
> +
> +	cic = cfq_cic_lookup(cfqd, current->io_context);
> +	if (!cic)
> +		return;
> +
> +	task_lock(tsk);
> +	new_cic = cfq_cic_lookup(cfqd, tsk->io_context);
> +	atomic_long_inc(&tsk->io_context->refcount);

How do we know tsk has an io_context?  Use get_io_context() and check
its result?

> +	task_unlock(tsk);
> +	if (!new_cic)
> +		goto out_dec;
> +
> +	spin_lock_irq(q->queue_lock);
> +
> +	cfqq = cic_to_cfqq(cic, 1);
> +	if (!cfqq)
> +		goto out_unlock;
> +
> +	/*
> +	 * If we are currently servicing the SYNC_NOIDLE_WORKLOAD, and we
> +	 * are idling on the last queue in that workload, *and* there are no
> +	 * potential dependent readers running currently, then go ahead and
> +	 * yield the queue.
> +	 */

Comment explains the code, but doesn't explain the *reason* for the code.

> +	if (cfqd->active_queue == cfqq &&
> +	    cfqd->serving_type == SYNC_NOIDLE_WORKLOAD) {
> +		/*
> +		 * If there's been no I/O from another process in the idle
> +		 * slice time, then there is by definition no dependent
> +		 * read going on for this service tree.
> +		 */
> +		if (expiry_data_valid(cfqq->service_tree) &&
> +		    time_before(cfqq->service_tree->last_expiry +
> +				cfq_slice_idle, jiffies) &&
> +		    cfqq->service_tree->last_pid != cfqq->pid)
> +			goto out_unlock;
> +	}
> +
> +	cfq_log_cfqq(cfqd, cfqq, "yielding queue to %d", tsk->pid);
> +	cfqq->yield_to = new_cic;
> +	cfq_mark_cfqq_yield(cfqq);
> +
> +out_unlock:
> +	spin_unlock_irq(q->queue_lock);
> +out_dec:
> +	put_io_context(tsk->io_context);
> +}
> +
>  static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
>  {
>  	int dispatched = 0;
>
> ...
>
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -866,6 +866,14 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
>  	}
>  }
>  
> +void elv_yield(struct request_queue *q, struct task_struct *tsk)
> +{
> +	struct elevator_queue *e = q->elevator;
> +
> +	if (e && e->ops->elevator_yield_fn)
> +		e->ops->elevator_yield_fn(q, tsk);
> +}

Again, no documentation.  How are other programmers to know when, why
and how they should use this?

>
> ...
>

