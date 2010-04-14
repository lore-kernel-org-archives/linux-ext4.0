From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/4] cfq-iosched: Keep track of average think time for
	the sync-noidle workload.
Date: Wed, 14 Apr 2010 17:37:45 -0400
Message-ID: <20100414213745.GC3167@redhat.com>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com> <1271279826-30294-2-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab0DNVhu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 17:37:50 -0400
Content-Disposition: inline
In-Reply-To: <1271279826-30294-2-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 14, 2010 at 05:17:03PM -0400, Jeff Moyer wrote:
> This patch uses an average think time for the entirety of the sync-noidle
> workload to determine whether or not to idle on said workload.  This brings
> it more in line with the policy for the sync queues in the sync workload.
> 
> Testing shows that this provided an overall increase in throughput for
> a mixed workload on my hardware RAID array.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  block/cfq-iosched.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 838834b..ef59ab3 100644
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
> +	     cfqq->slice_end - jiffies < service_tree->ttime_mean)))
>  		return 1;
>  	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
>  			service_tree->count);
> @@ -2988,6 +2998,18 @@ err:
>  }
>  
>  static void
> +cfq_update_st_thinktime(struct cfq_data *cfqd, struct cfq_rb_root *service_tree)
> +{
> +	unsigned long elapsed = jiffies - service_tree->last_end_request;
> +	unsigned long ttime = min(elapsed, 2UL * cfqd->cfq_slice_idle);
> +
> +	service_tree->ttime_samples = (7*service_tree->ttime_samples + 256) / 8;
> +	service_tree->ttime_total = (7*service_tree->ttime_total + 256*ttime)/8;
> +	service_tree->ttime_mean = (service_tree->ttime_total + 128) /
> +						service_tree->ttime_samples;
> +}
> +
> +static void
>  cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_io_context *cic)
>  {
>  	unsigned long elapsed = jiffies - cic->last_end_request;
> @@ -3166,6 +3188,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  		cfqq->meta_pending++;
>  
>  	cfq_update_io_thinktime(cfqd, cic);
> +	cfq_update_st_thinktime(cfqd, cfqq->service_tree);
>  	cfq_update_io_seektime(cfqd, cfqq, rq);
>  	cfq_update_idle_window(cfqd, cfqq, cic);
>  
> @@ -3304,7 +3327,16 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
>  
>  	if (sync) {
> +		struct cfq_rb_root *st;
> +
>  		RQ_CIC(rq)->last_end_request = now;
> +		/*
> +		 * cfqq->service_tree is only filled in while on the rb tree,
> +		 * so we need to lookup the service tree here.
> +		 */
> +		st = service_tree_for(cfqq->cfqg,
> +				      cfqq_prio(cfqq), cfqq_type(cfqq));
> +		st->last_end_request = now;
>  		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
>  			cfqd->last_delayed_sync = now;
>  	}
> @@ -3678,11 +3710,14 @@ static void *cfq_init_queue(struct request_queue *q)
>  
>  	/* Init root service tree */
>  	cfqd->grp_service_tree = CFQ_RB_ROOT;
> +	cfqd->grp_service_tree.last_end_request = jiffies;
>  

This assignment is not required as we never update think time analsys of
service tree where all the groups are hanging.  So for grp_service_tree,
last_end_request can be zero and there will be no harm.

Otherwise patch looks good to me. Can you please run some simple blkio
cgroup tests to make sure that functionality is not broken.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

>  	/* Init root group */
>  	cfqg = &cfqd->root_group;
> -	for_each_cfqg_st(cfqg, i, j, st)
> +	for_each_cfqg_st(cfqg, i, j, st) {
>  		*st = CFQ_RB_ROOT;
> +		st->last_end_request = jiffies;
> +	}
>  	RB_CLEAR_NODE(&cfqg->rb_node);
>  
>  	/* Give preference to root group over other groups */
> -- 
> 1.6.2.5
