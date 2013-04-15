From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] blkdev: add flush generation counter
Date: Mon, 15 Apr 2013 16:14:39 +0200
Message-ID: <20130415141439.GH2299@quack.suse.cz>
References: <87wqs4kiyi.fsf@openvz.org>
 <1365968068-11766-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, axboe@kernel.dk
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1365968068-11766-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 14-04-13 23:34:27, Dmitry Monakhov wrote:
> Callers may use this counter to optimize flushes
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  block/blk-core.c       |    1 +
>  block/blk-flush.c      |    3 ++-
>  include/linux/blkdev.h |    1 +
>  3 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 074b758..afb5a4b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -537,6 +537,7 @@ void blk_cleanup_queue(struct request_queue *q)
>  	spin_unlock_irq(lock);
>  	mutex_unlock(&q->sysfs_lock);
>  
> +	atomic_set(&q->flush_tag, 0);
>  	/*
>  	 * Drain all requests queued before DYING marking. Set DEAD flag to
>  	 * prevent that q->request_fn() gets invoked after draining finished.
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index cc2b827..b1adc75 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -203,7 +203,7 @@ static void flush_end_io(struct request *flush_rq, int error)
>  	/* account completion of the flush request */
>  	q->flush_running_idx ^= 1;
>  	elv_completed_request(q, flush_rq);
> -
> +	atomic_inc(&q->flush_tag);
>  	/* and push the waiting requests to the next stage */
>  	list_for_each_entry_safe(rq, n, running, flush.list) {
>  		unsigned int seq = blk_flush_cur_seq(rq);
> @@ -268,6 +268,7 @@ static bool blk_kick_flush(struct request_queue *q)
>  	q->flush_rq.end_io = flush_end_io;
>  
>  	q->flush_pending_idx ^= 1;
> +	atomic_inc(&q->flush_tag);
>  	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
>  	return true;
>  }
  But this doesn't quite work, does it? When fs reads flush_tag counter,
CACHE_FLUSH command can be already issued so you are not sure how the IO
you are issuing relates to the cache flush in flight. If you want to make
this work, you really need two counters - one for flush submissions and one
for flush completions. Fs would need to read the submission counter before
issuing the IO and the completion counter when it wants to make sure date is
on the stable storage. But it all gets somewhat complex and I'm not sure
it's worth it given the block layer tries to merge flush requests by
itself. But you can try for correct implementation and measure the
performance impact of course...

								Honza
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 78feda9..e079fbd 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -416,6 +416,7 @@ struct request_queue {
>  	unsigned int		flush_queue_delayed:1;
>  	unsigned int		flush_pending_idx:1;
>  	unsigned int		flush_running_idx:1;
> +	atomic_t		flush_tag;
>  	unsigned long		flush_pending_since;
>  	struct list_head	flush_queue[2];
>  	struct list_head	flush_data_in_flight;
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
