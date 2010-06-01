From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/4] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
Date: Tue, 01 Jun 2010 16:01:12 -0400
Message-ID: <x49typmldyv.fsf@segfault.boston.devel.redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
	<1274206820-17071-3-git-send-email-jmoyer@redhat.com>
	<20100518214437.GF12330@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	axboe@kernel.dk
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab0FAUBR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 16:01:17 -0400
In-Reply-To: <20100518214437.GF12330@redhat.com> (Vivek Goyal's message of
	"Tue, 18 May 2010 17:44:37 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, May 18, 2010 at 02:20:18PM -0400, Jeff Moyer wrote:
>> This patch implements a blk_yield to allow a process to voluntarily
>> give up its I/O scheduler time slice.  This is desirable for those processes
>> which know that they will be blocked on I/O from another process, such as
>> the file system journal thread.  Following patches will put calls to blk_yield
>> into jbd and jbd2.
>> 
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>> ---
>>  block/blk-core.c         |   13 +++++
>>  block/blk-settings.c     |    6 +++
>>  block/cfq-iosched.c      |  112 +++++++++++++++++++++++++++++++++++++++++++++-
>>  block/elevator.c         |    8 +++
>>  include/linux/blkdev.h   |    4 ++
>>  include/linux/elevator.h |    3 +
>>  6 files changed, 144 insertions(+), 2 deletions(-)
>> 

[...]

> @@ -2138,7 +2142,8 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>  		 * ok to wait for this request to complete.
>  		 */
>  		if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
> -		    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
> +		    && cfqq->dispatched && !cfq_cfqq_yield(cfqq) &&
> +		    cfq_should_idle(cfqd, cfqq)) {
>  			cfqq = NULL;

> I think if we just place cfq_cfqq_yield(cfqq), check above it, we don't
> need above code modification?

Yep.

> This might result in some group losing fairness in certain scenarios, but
> I guess we will tackle it once we face it. For the time being if fsync
> thread is giving up cpu, journald commits will come in root group and
> there might not be a point in wasting time idling on this group.

ok.

[...]

>> @@ -2191,6 +2199,98 @@ keep_queue:
>>  	return cfqq;
>>  }
>>  
>> +static void cfq_yield(struct request_queue *q, struct task_struct *tsk)
>> +{
>> +	struct cfq_data *cfqd = q->elevator->elevator_data;
>> +	struct cfq_io_context *cic, *new_cic;
>> +	struct cfq_queue *cfqq, *sync_cfqq, *async_cfqq, *new_cfqq;
>> +
>> +	cic = cfq_cic_lookup(cfqd, current->io_context);
>> +	if (!cic)
>> +		return;
>> +
>> +	task_lock(tsk);
>> +	new_cic = cfq_cic_lookup(cfqd, tsk->io_context);
>> +	atomic_long_inc(&tsk->io_context->refcount);
>> +	task_unlock(tsk);
>> +	if (!new_cic)
>> +		goto out_dec;
>> +
>> +	spin_lock_irq(q->queue_lock);
>> +
>> +	/*
>> +	 * This is primarily called to ensure that the long synchronous
>> +	 * time slice does not prevent other I/O happenning (like journal
>> +	 * commits) while we idle waiting for it.  Thus, check to see if the
>> +	 * current cfqq is the sync cfqq for this process.
>> +	 */
>> +	cfqq = cic_to_cfqq(cic, 1);
>> +	if (!cfqq)
>> +		goto out_unlock;
>> +
>> +	if (cfqd->active_queue != cfqq)
>> +		goto out_unlock;
>
> Why does yielding queue has to be active queue? Could it be possible that
> a queue submitted a bunch of IO and did yield. It is possible that
> yielding queue is not active queue. Even in that case we will like to mark
> cfqq yielding and expire queue after dispatch of pending requests?

You're absolutely right, this should not be a limitation in the code.

>> +
>> +	sync_cfqq = cic_to_cfqq(new_cic, 1);
>> +	async_cfqq = cic_to_cfqq(new_cic, 0);
>> +	if (!sync_cfqq && !async_cfqq)
>> +		goto out_unlock;
>> +	if (!RB_EMPTY_ROOT(&sync_cfqq->sort_list))
>> +		new_cfqq = sync_cfqq;
>> +	else
>> +		new_cfqq = async_cfqq;
>> +
>
> Why is it mandatory that target context has already the queue setup. If
> there is no queue setup, can't we just yield the slice and let somebody
> else run?

The only callers of the yield method are yielding to a kernel thread
that is always going to exist.  I didn't see a need to add any
complexity here for a case that doesn't yet exist.

> Oh, I guess you want to keep the slice and idle till target queue
> dispatches some requests and sets up context and a queue? But even that
> will not help as you have anyway missed the yield event?

No, see above.

>> +	/*
>> +	 * If we are currently servicing the SYNC_NOIDLE_WORKLOAD, and we
>> +	 * are idling on the last queue in that workload, *and* the average
>> +	 * think time is larger thank the remaining slice time, go ahead
>> +	 * and yield the queue.  Otherwise, don't yield so that fsync-heavy
>> +	 * workloads don't starve out the sync-noidle workload.
>> +	 */
>> +	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
>> +	    (!sample_valid(cfqq->service_tree->ttime_samples) ||
>> +	     cfqq->slice_end - jiffies > cfqq->service_tree->ttime_mean)) {
>> +		/*
>
> This is confusing. The yielding queue's stats are already part of service
> tree's think time. So if yielding queue has done bunch of IO, then service
> tree's mean think time will be low and we will not yield? I guess that's
> the reason you are trying to check average number of queues in following
> code.  

Sorry for confusing you.  Your deduction is correct.  Is there a way I
can write this that would be less confusing to you?

>> +		 * If there's only a single sync-noidle queue on average,
>> +		 * there's no point in idling in order to not starve the
>> +		 * non-existent other queues.
>> +		 */
>> +		if (cfq_group_busy_queues_wl(SYNC_NOIDLE_WORKLOAD, cfqd,
>> +					     cfqq->cfqg) > 1)
>
> Does cfq_group_busy_queues_wl() give average number of queues. Were you
> looking for cfqg->busy_queues_avg?

Yes, thanks again.

>
>> +			goto out_unlock;
>> +	}
>> +
>> +	cfq_log_cfqq(cfqd, cfqq, "yielding queue");
>> +
>> +	/*
>> +	 * If there are other requests pending, just mark the queue as
>> +	 * yielding and give up our slice after the last request is
>> +	 * dispatched.  Or, if there are no requests currently pending
>> +	 * on the selected queue, keep our time slice until such a time
>> +	 * as the new queue has something to do.  It will then preempt
>> +	 * this queue (see cfq_should_preempt).
>> +	 */
>> +	if (!RB_EMPTY_ROOT(&cfqq->sort_list) ||
>> +	    RB_EMPTY_ROOT(&new_cfqq->sort_list)) {
>> +		cfqq->yield_to = new_cic;
>
> Where are you clearing yield_to flag? Can't seem to find it.

yield_to is not a flag.  ;-)  It is not cleared as it is only valid if
the cfq_cfqq_yield flag is set.  If you would find it more sensible, I
can certainly add code to clear it.

>> +		cfq_mark_cfqq_yield(cfqq);
>> +		goto out_unlock;
>> +	}
>> +
>> +	/*
>> +	 * At this point, we know that the target queue has requests pending.
>> +	 * Yield the io scheduler.
>> +	 */
>> +	__cfq_slice_expired(cfqd, cfqq, 1);
>> +	__cfq_set_active_queue(cfqd, new_cfqq);
>
> What happens to cfq_group considerations? So we can yield slices across
> groups. That does not seem right. If existing group has requests on other
> service trees, these should be processed first.
>
> Can we handle all this logic in select_queue(). I think it might turn out
> to be simpler. I mean in this function if we just mark the existing queue
> as yielding and also setup who to yield the queue to and let
> select_queue() take the decision whether to idle or choose new queue etc.
> I guess it should be possible and code might turn out to be simpler to
> read.

I'll give that a shot, thanks for the suggestion.  My concern is that,
when employing cgroups, you may never actually yield the queue depending
on where the file system's journal thread ends up.

Cheers,
Jeff
