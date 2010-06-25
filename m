From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/3] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
Date: Fri, 25 Jun 2010 12:51:58 -0400
Message-ID: <x49bpaznjgx.fsf@segfault.boston.devel.redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<1277242502-9047-2-git-send-email-jmoyer@redhat.com>
	<20100624004622.GA3297@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab0FYQwG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jun 2010 12:52:06 -0400
In-Reply-To: <20100624004622.GA3297@redhat.com> (Vivek Goyal's message of
	"Wed, 23 Jun 2010 20:46:22 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Jun 22, 2010 at 05:35:00PM -0400, Jeff Moyer wrote:
>
> [..]
>> @@ -1614,6 +1620,15 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>>  	cfq_clear_cfqq_wait_request(cfqq);
>>  	cfq_clear_cfqq_wait_busy(cfqq);
>>  
>> +	if (!cfq_cfqq_yield(cfqq)) {
>> +		struct cfq_rb_root *st;
>> +		st = service_tree_for(cfqq->cfqg,
>> +				      cfqq_prio(cfqq), cfqq_type(cfqq));
>> +		st->last_expiry = jiffies;
>> +		st->last_pid = cfqq->pid;
>> +	}
>> +	cfq_clear_cfqq_yield(cfqq);
>
> Jeff, I think cfqq is still on service tree at this point of time. If yes,
> then we can simply use cfqq->service_tree, instead of calling
> service_tree_for().

Yup.

> No clearing of cfqq->yield_to field?

Nope.  Again, it's not required, but if you really want me to, I'll add
it.

> [..]
>>  /*
>>   * Select a queue for service. If we have a current active queue,
>>   * check whether to continue servicing it, or retrieve and set a new one.
>> @@ -2187,6 +2232,10 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>>  		 * have been idling all along on this queue and it should be
>>  		 * ok to wait for this request to complete.
>>  		 */
>> +		if (cfq_cfqq_yield(cfqq) &&
>> +		    cfq_should_yield_now(cfqq, &new_cfqq))
>> +			goto expire;
>> +
>
> I think we can get rid of this condition here and move the yield check
> above outside above if condition. This if condition waits for request to
> complete from this queue and waits for queue to get busy before slice
> expiry. If we have decided to yield the queue, there is no point in
> waiting for next request for queue to get busy.

Yeah, this is a vestige of the older code layout.  Thanks, this cleans
things up nicely.

>> +	cfq_log_cfqq(cfqd, cfqq, "yielding queue to %d", tsk->pid);
>> +	cfqq->yield_to = new_cic;
>
> We are stashing away a pointer to cic without taking reference?

There is no reference counting on the cic.

>> @@ -3123,6 +3234,13 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>>  	if (!cfqq)
>>  		return false;
>>  
>> +	/*
>> +	 * If the active queue yielded its timeslice to this queue, let
>> +	 * it preempt.
>> +	 */
>> +	if (cfq_cfqq_yield(cfqq) && RQ_CIC(rq) == cfqq->yield_to)
>> +		return true;
>> +
>
> I think we need to again if if we are sync-noidle workload then allow
> preemption only if no dependent read is currently on, otherwise
> sync-noidle service tree loses share.

I think you mean don't yield if there is a dependent reader.  Yeah,
makes sense.

> This version looks much simpler than previous one and is much easier
> to understand. I will do some testing on friday and provide you feedback.

Great, thanks again for the review!

Cheers,
Jeff
