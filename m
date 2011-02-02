From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 2/2] block: share request flush fields with
 elevator_private
Date: Wed, 2 Feb 2011 16:52:55 -0500
Message-ID: <20110202215254.GD12559@redhat.com>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
	tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1BBVxJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Feb 2011 16:53:09 -0500
Content-Disposition: inline
In-Reply-To: <1296600373-6906-2-git-send-email-snitzer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 01, 2011 at 05:46:13PM -0500, Mike Snitzer wrote:
> Flush requests are never put on the IO scheduler.  Convert request
> structure's elevator_private* into an array and have the flush fields
> share a union with it.
> 
> Reclaim the space lost in 'struct request' by moving 'completion_data'
> back in the union with 'rb_node'.
> 

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/cfq-iosched.c    |   18 +++++++++---------
>  block/elevator.c       |    2 +-
>  include/linux/blkdev.h |   23 ++++++++++++-----------
>  3 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 501ffdf..8692958 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -54,9 +54,9 @@ static const int cfq_hist_divisor = 4;
>  #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
>  
>  #define RQ_CIC(rq)		\
> -	((struct cfq_io_context *) (rq)->elevator_private)
> -#define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private2)
> -#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator_private3)
> +	((struct cfq_io_context *) (rq)->elevator_private[0])
> +#define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private[1])
> +#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator_private[2])
>  
>  static struct kmem_cache *cfq_pool;
>  static struct kmem_cache *cfq_ioc_pool;
> @@ -3609,12 +3609,12 @@ static void cfq_put_request(struct request *rq)
>  
>  		put_io_context(RQ_CIC(rq)->ioc);
>  
> -		rq->elevator_private = NULL;
> -		rq->elevator_private2 = NULL;
> +		rq->elevator_private[0] = NULL;
> +		rq->elevator_private[1] = NULL;
>  
>  		/* Put down rq reference on cfqg */
>  		cfq_put_cfqg(RQ_CFQG(rq));
> -		rq->elevator_private3 = NULL;
> +		rq->elevator_private[2] = NULL;
>  
>  		cfq_put_queue(cfqq);
>  	}
> @@ -3702,9 +3702,9 @@ new_queue:
>  
>  	cfqq->allocated[rw]++;
>  	cfqq->ref++;
> -	rq->elevator_private = cic;
> -	rq->elevator_private2 = cfqq;
> -	rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
> +	rq->elevator_private[0] = cic;
> +	rq->elevator_private[1] = cfqq;
> +	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
>  
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  
> diff --git a/block/elevator.c b/block/elevator.c
> index 270e097..f98e92e 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -764,7 +764,7 @@ int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
>  	if (e->ops->elevator_set_req_fn)
>  		return e->ops->elevator_set_req_fn(q, rq, gfp_mask);
>  
> -	rq->elevator_private = NULL;
> +	rq->elevator_private[0] = NULL;
>  	return 0;
>  }
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 8a082a5..e3ee74f 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -99,25 +99,26 @@ struct request {
>  	/*
>  	 * The rb_node is only used inside the io scheduler, requests
>  	 * are pruned when moved to the dispatch queue. So let the
> -	 * flush fields share space with the rb_node.
> +	 * completion_data share space with the rb_node.
>  	 */
>  	union {
>  		struct rb_node rb_node;	/* sort/lookup */
> -		struct {
> -			unsigned int			seq;
> -			struct list_head		list;
> -		} flush;
> +		void *completion_data;
>  	};
>  
> -	void *completion_data;
> -
>  	/*
>  	 * Three pointers are available for the IO schedulers, if they need
> -	 * more they have to dynamically allocate it.
> +	 * more they have to dynamically allocate it.  Flush requests are
> +	 * never put on the IO scheduler. So let the flush fields share
> +	 * space with the three elevator_private pointers.
>  	 */
> -	void *elevator_private;
> -	void *elevator_private2;
> -	void *elevator_private3;
> +	union {
> +		void *elevator_private[3];
> +		struct {
> +			unsigned int		seq;
> +			struct list_head	list;
> +		} flush;
> +	};
>  
>  	struct gendisk *rq_disk;
>  	struct hd_struct *part;
> -- 
> 1.7.3.4
