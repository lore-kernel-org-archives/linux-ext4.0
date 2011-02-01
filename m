From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/2] block: skip elevator initialization for flush requests
Date: Tue,  1 Feb 2011 17:46:12 -0500
Message-ID: <1296600373-6906-1-git-send-email-snitzer@redhat.com>
References: <20110201185225.GT14211@htj.dyndns.org>
Cc: tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com, vgoyal@redhat.com,
	snitzer@redhat.com
To: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110201185225.GT14211@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Skip elevator initialization during request allocation if REQ_SORTED
is not set in the @rw_flags passed to the request allocator.

Set REQ_SORTED for all requests that may be put on IO scheduler.  Flush
requests are not put on IO scheduler so REQ_SORTED is not set for
them.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 72dd23b..f6fcc64 100644
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
+	 * Only initialize elevator data if REQ_SORTED is set.
+	 */
+	if (rw_flags & REQ_SORTED) {
+		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+		if (priv)
+			rl->elvpriv++;
+	}
 
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
@@ -1197,6 +1202,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const unsigned short prio = bio_prio(bio);
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	const bool unplug = !!(bio->bi_rw & REQ_UNPLUG);
+	const bool flush = !!(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	const unsigned long ff = bio->bi_rw & REQ_FAILFAST_MASK;
 	int where = ELEVATOR_INSERT_SORT;
 	int rw_flags;
@@ -1210,7 +1216,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 	spin_lock_irq(q->queue_lock);
 
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+	if (flush) {
 		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;
 	}
@@ -1293,6 +1299,14 @@ get_rq:
 		rw_flags |= REQ_SYNC;
 
 	/*
+	 * Set REQ_SORTED for all requests that may be put on IO scheduler.
+	 * The request allocator's IO scheduler initialization will be skipped
+	 * if REQ_SORTED is not set.
+	 */
+	if (!flush)
+		rw_flags |= REQ_SORTED;
+
+	/*
 	 * Grab a free request. This is might sleep but can not fail.
 	 * Returns with the queue unlocked.
 	 */
-- 
1.7.3.4
