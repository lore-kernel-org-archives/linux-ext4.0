From: Mike Snitzer <snitzer@redhat.com>
Subject: [KNOWN BUGGY RFC PATCH 4/3] block: skip elevator initialization for
 flush requests
Date: Tue, 25 Jan 2011 15:41:58 -0500
Message-ID: <20110125204158.GA3013@redhat.com>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1AYUnL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jan 2011 15:43:11 -0500
Content-Disposition: inline
In-Reply-To: <1295625598-15203-4-git-send-email-tj@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tejun,

On Fri, Jan 21 2011 at 10:59am -0500,
Tejun Heo <tj@kernel.org> wrote:
> 
> * As flush requests are never put on the IO scheduler, request fields
>   used for flush share space with rq->rb_node.  rq->completion_data is
>   moved out of the union.  This increases the request size by one
>   pointer.
> 
>   As rq->elevator_private* are used only by the iosched too, it is
>   possible to reduce the request size further.  However, to do that,
>   we need to modify request allocation path such that iosched data is
>   not allocated for flush requests.

I decided to take a crack at using rq->elevator_private* and came up
with the following patch.

Unfortunately, in testing I found that flush requests that have data do
in fact eventually get added to the queue as normal requests, via:
1) "data but flush is not necessary" case in blk_insert_flush
2) REQ_FSEQ_DATA case in blk_flush_complete_seq

I know this because in my following get_request() change to _not_ call
elv_set_request() for flush requests hit cfq_put_request()'s
BUG_ON(!cfqq->allocated[rw]).  cfqq->allocated[rw] gets set via
elv_set_request()'s call to cfq_set_request().

So this seems to call in to question the running theory that flush
requests can share 'struct request' space with elevator-specific members
(via union) -- be it rq->rb_node or rq->elevator_private*.

Please advise, thanks!
Mike



From: Mike Snitzer <snitzer@redhat.com>

Skip elevator initialization for flush requests by passing priv=0 to
blk_alloc_request() in get_request().  As such elv_set_request() is
never called for flush requests.

Move elevator_private* into 'struct elevator' and have the flush fields
share a union with it.

Reclaim the space lost in 'struct request' by moving 'completion_data'
back in to the union with 'rb_node'.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       |   13 +++++++++----
 block/cfq-iosched.c    |   18 +++++++++---------
 block/elevator.c       |    2 +-
 include/linux/blkdev.h |   26 +++++++++++++++-----------
 4 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 72dd23b..f507888 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -764,7 +764,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
-	int may_queue, priv;
+	int may_queue, priv = 0;
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -808,9 +808,14 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	rl->count[is_sync]++;
 	rl->starved[is_sync] = 0;
 
-	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
-	if (priv)
-		rl->elvpriv++;
+	/*
+	 * Skip elevator initialization for flush requests
+	 */
+	if (!(bio && (bio->bi_rw & (REQ_FLUSH | REQ_FUA)))) {
+		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+		if (priv)
+			rl->elvpriv++;
+	}
 
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 501ffdf..580ae0a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -54,9 +54,9 @@ static const int cfq_hist_divisor = 4;
 #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
 
 #define RQ_CIC(rq)		\
-	((struct cfq_io_context *) (rq)->elevator_private)
-#define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private2)
-#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator_private3)
+	((struct cfq_io_context *) (rq)->elevator.private)
+#define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator.private2)
+#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator.private3)
 
 static struct kmem_cache *cfq_pool;
 static struct kmem_cache *cfq_ioc_pool;
@@ -3609,12 +3609,12 @@ static void cfq_put_request(struct request *rq)
 
 		put_io_context(RQ_CIC(rq)->ioc);
 
-		rq->elevator_private = NULL;
-		rq->elevator_private2 = NULL;
+		rq->elevator.private = NULL;
+		rq->elevator.private2 = NULL;
 
 		/* Put down rq reference on cfqg */
 		cfq_put_cfqg(RQ_CFQG(rq));
-		rq->elevator_private3 = NULL;
+		rq->elevator.private3 = NULL;
 
 		cfq_put_queue(cfqq);
 	}
@@ -3702,9 +3702,9 @@ new_queue:
 
 	cfqq->allocated[rw]++;
 	cfqq->ref++;
-	rq->elevator_private = cic;
-	rq->elevator_private2 = cfqq;
-	rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
+	rq->elevator.private = cic;
+	rq->elevator.private2 = cfqq;
+	rq->elevator.private3 = cfq_ref_get_cfqg(cfqq->cfqg);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
diff --git a/block/elevator.c b/block/elevator.c
index 270e097..02b66be 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -764,7 +764,7 @@ int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	if (e->ops->elevator_set_req_fn)
 		return e->ops->elevator_set_req_fn(q, rq, gfp_mask);
 
-	rq->elevator_private = NULL;
+	rq->elevator.private = NULL;
 	return 0;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8a082a5..0c569ec 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -99,25 +99,29 @@ struct request {
 	/*
 	 * The rb_node is only used inside the io scheduler, requests
 	 * are pruned when moved to the dispatch queue. So let the
-	 * flush fields share space with the rb_node.
+	 * completion_data share space with the rb_node.
 	 */
 	union {
 		struct rb_node rb_node;	/* sort/lookup */
-		struct {
-			unsigned int			seq;
-			struct list_head		list;
-		} flush;
+		void *completion_data;
 	};
 
-	void *completion_data;
