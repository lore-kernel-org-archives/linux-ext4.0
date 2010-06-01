From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/4] cfq-iosched: Keep track of average think time for the sync-noidle workload.
Date: Tue, 01 Jun 2010 15:31:03 -0400
Message-ID: <x49y6eylfd4.fsf@segfault.boston.devel.redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
	<1274206820-17071-2-git-send-email-jmoyer@redhat.com>
	<20100518210226.GD12330@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	axboe@kernel.dk
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0FATbJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 15:31:09 -0400
In-Reply-To: <20100518210226.GD12330@redhat.com> (Vivek Goyal's message of
	"Tue, 18 May 2010 17:02:26 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, May 18, 2010 at 02:20:17PM -0400, Jeff Moyer wrote:
>> This patch uses an average think time for the entirety of the sync-noidle
>> workload to determine whether or not to idle on said workload.  This brings
>> it more in line with the policy for the sync queues in the sync workload.
>> 
>> Testing shows that this provided an overall increase in throughput for
>> a mixed workload on my hardware RAID array.
>> 
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>> ---
>>  block/cfq-iosched.c |   44 +++++++++++++++++++++++++++++++++++++++-----
>>  1 files changed, 39 insertions(+), 5 deletions(-)
>> 
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 838834b..46a7fe5 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -83,9 +83,14 @@ struct cfq_rb_root {
>>  	unsigned total_weight;
>>  	u64 min_vdisktime;
>>  	struct rb_node *active;
>> +	unsigned long last_end_request;
>> +	unsigned long ttime_total;
>> +	unsigned long ttime_samples;
>> +	unsigned long ttime_mean;
>>  };
>>  #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
>> -			.count = 0, .min_vdisktime = 0, }
>> +			.count = 0, .min_vdisktime = 0, .last_end_request = 0, \
>> +			.ttime_total = 0, .ttime_samples = 0, .ttime_mean = 0 }
>>  
>>  /*
>>   * Per process-grouping structure
>> @@ -962,8 +967,10 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>>  		goto done;
>>  
>>  	cfqg->weight = blkcg->weight;
>> -	for_each_cfqg_st(cfqg, i, j, st)
>> +	for_each_cfqg_st(cfqg, i, j, st) {
>>  		*st = CFQ_RB_ROOT;
>> +		st->last_end_request = jiffies;
>> +	}
>>  	RB_CLEAR_NODE(&cfqg->rb_node);
>>  
>>  	/*
>> @@ -1795,9 +1802,12 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  
>>  	/*
>>  	 * Otherwise, we do only if they are the last ones
>> -	 * in their service tree.
>> +	 * in their service tree and the average think time is
>> +	 * less than the slice length.
>>  	 */
>> -	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
>> +	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq) &&
>> +	    (!sample_valid(service_tree->ttime_samples || 

> Jeff, 
> 
> Are we closing sample_valid() bracket at right place here?

I think you know the answer to that.  ;-)  Thanks for catching this.

> I am wondering where it is helping you.

The idea behind the patch is to optimize the idling such that we don't
wait needlessly for more sync-noidle I/O when it likely isn't coming.
As mentioned in the patch description, it aims to bring the sync-noidle
workload, which is treated like a single cfqq, more in-line with the
handling of a single cfqq.

> If it is to bring in line with with sync tree (old implementation),
> then we should have also compared the think time with slice_idle?

I'm not sure I follow 100%.  Are you saying we should disable idling for
the sync-noidle workload if the think time is too long?  That sounds
reasonable.

> But comparing that here might not be the best thing as cfq_should_idle()
> is used in many contexts.

Again, looking for clarification on this point.

>> +	     cfqq->slice_end - jiffies < service_tree->ttime_mean)))
>>  		return 1;
>
> This comparision will also might break some logic in select_queue() where
> we wait for a queue/group to get busy even if queue's time slice has
> expired.
>
> ********************************************************************
> if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq)) {
>                 /*
>                  * If slice had not expired at the completion of last
>                  * request
>                  * we might not have turned on wait_busy flag. Don't
>                  * expire
>                  * the queue yet. Allow the group to get backlogged.
>                  *
>                  * The very fact that we have used the slice, that means
>                  * we
>                  * have been idling all along on this queue and it should
>                  * be
>                  * ok to wait for this request to complete.
>                  */
>                 if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
>                     && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
>                         cfqq = NULL;
>                         goto keep_queue;
> 		}
>
> *************************************************************************
>
> With this change, now above condition will never be true as
> cfq_should_idle() will always return false as slice has already expired.
> And that will affect group loosing its fair share.
>
> So I guess we can define new functions to check more conditions instead of
> putting it in cfq_should_idle()

Right, thanks for pointing this out.  Do we have a test case that
exposes this issue?  We really need to start a regression test suite for
CFQ.  Also, I had promised to run some numbers for you with cgroups
enabled and I didn't.  I'll get that data before the next posting.

Thanks for the review, Vivek!

-Jeff
