From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/4] cfq-iosched: Keep track of average think time for
	the sync-noidle workload.
Date: Tue, 18 May 2010 16:52:27 -0400
Message-ID: <20100518205227.GC12330@redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com> <1274206820-17071-2-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jens.axboe@oracle.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab0ERUwb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 May 2010 16:52:31 -0400
Content-Disposition: inline
In-Reply-To: <1274206820-17071-2-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 18, 2010 at 02:20:17PM -0400, Jeff Moyer wrote:
> This patch uses an average think time for the entirety of the sync-noidle
> workload to determine whether or not to idle on said workload.  This brings
> it more in line with the policy for the sync queues in the sync workload.
> 
> Testing shows that this provided an overall increase in throughput for
> a mixed workload on my hardware RAID array.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  block/cfq-iosched.c |   44 +++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 838834b..46a7fe5 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -83,9 +83,14 @@ struct cfq_rb_root {
>  	unsigned total_weight;
>  	u64 min_vdisktime;
>  	struct rb_node *active;
> +	unsigned long last_end_request;
> +	unsigned long ttime_total;
> +	unsigned long ttime_samples;
> +	unsigned long ttime_mean;
>  };
>  #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
> -			.count = 0, .min_vdisktime = 0, }
> +			.count = 0, .min_vdisktime = 0, .last_end_request = 0, \
> +			.ttime_total = 0, .ttime_samples = 0, .ttime_mean = 0 }
>  
>  /*
>   * Per process-grouping structure
> @@ -962,8 +967,10 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  		goto done;
>  
>  	cfqg->weight = blkcg->weight;
> -	for_each_cfqg_st(cfqg, i, j, st)
> +	for_each_cfqg_st(cfqg, i, j, st) {
>  		*st = CFQ_RB_ROOT;
> +		st->last_end_request = jiffies;
> +	}
>  	RB_CLEAR_NODE(&cfqg->rb_node);
>  
>  	/*
> @@ -1795,9 +1802,12 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  
>  	/*
>  	 * Otherwise, we do only if they are the last ones
> -	 * in their service tree.
> +	 * in their service tree and the average think time is
> +	 * less than the slice length.
>  	 */
> -	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
> +	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq) &&
> +	    (!sample_valid(service_tree->ttime_samples || 
						     ^^^
Jeff, 

Are we closing sample_valid() bracket at right place here?

I am wondering where it is helping you. If it is to bring in line with
with sync tree (old implementation), then we should have also compared
the think time with slice_idle?

But comparing that here might not be the best thing as cfq_should_idle()
is used in many contexts.
 
Vivek
