From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/3] block: Implement a blk_yield function to voluntarily
 give up the I/O scheduler.
Date: Wed, 23 Jun 2010 20:46:22 -0400
Message-ID: <20100624004622.GA3297@redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
 <1277242502-9047-2-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab0FXAq0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jun 2010 20:46:26 -0400
Content-Disposition: inline
In-Reply-To: <1277242502-9047-2-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 22, 2010 at 05:35:00PM -0400, Jeff Moyer wrote:

[..]
> @@ -1614,6 +1620,15 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	cfq_clear_cfqq_wait_request(cfqq);
>  	cfq_clear_cfqq_wait_busy(cfqq);
>  
> +	if (!cfq_cfqq_yield(cfqq)) {
> +		struct cfq_rb_root *st;
> +		st = service_tree_for(cfqq->cfqg,
> +				      cfqq_prio(cfqq), cfqq_type(cfqq));
> +		st->last_expiry = jiffies;
> +		st->last_pid = cfqq->pid;
> +	}
> +	cfq_clear_cfqq_yield(cfqq);

Jeff, I think cfqq is still on service tree at this point of time. If yes,
then we can simply use cfqq->service_tree, instead of calling
service_tree_for().

No clearing of cfqq->yield_to field?

[..]
>  /*
>   * Select a queue for service. If we have a current active queue,
>   * check whether to continue servicing it, or retrieve and set a new one.
> @@ -2187,6 +2232,10 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>  		 * have been idling all along on this queue and it should be
>  		 * ok to wait for this request to complete.
>  		 */
> +		if (cfq_cfqq_yield(cfqq) &&
> +		    cfq_should_yield_now(cfqq, &new_cfqq))
> +			goto expire;
> +

I think we can get rid of this condition here and move the yield check
above outside above if condition. This if condition waits for request to
complete from this queue and waits for queue to get busy before slice
expiry. If we have decided to yield the queue, there is no point in
waiting for next request for queue to get busy.

>  		if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
>  		    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
>  			cfqq = NULL;
> @@ -2215,6 +2264,9 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>  		goto expire;
>  	}
>  
> +	if (cfq_cfqq_yield(cfqq) && cfq_should_yield_now(cfqq, &new_cfqq))
> +		goto expire;
> +

We can move this check up.
 
[..]
> +static void cfq_yield(struct request_queue *q, struct task_struct *tsk)
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

We are stashing away a pointer to cic without taking reference?

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
> @@ -3123,6 +3234,13 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>  	if (!cfqq)
>  		return false;
>  
> +	/*
> +	 * If the active queue yielded its timeslice to this queue, let
> +	 * it preempt.
> +	 */
> +	if (cfq_cfqq_yield(cfqq) && RQ_CIC(rq) == cfqq->yield_to)
> +		return true;
> +

I think we need to again if if we are sync-noidle workload then allow
preemption only if no dependent read is currently on, otherwise
sync-noidle service tree loses share.

This version looks much simpler than previous one and is much easier
to understand. I will do some testing on friday and provide you feedback.

Thanks
Vivek
