From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 1/2] block: skip elevator data initialization for flush
 requests
Date: Wed, 2 Feb 2011 17:55:49 -0500
Message-ID: <20110202225549.GA28109@redhat.com>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com, vgoyal@redhat.com
To: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1296600373-6906-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Set REQ_SORTED, in the @rw_flags passed to the request allocator, for
any request that may be put on IO scheduler.  Skip elevator data
initialization during request allocation if REQ_SORTED is not set.

REQ_SORTED is not set for flush requests because they are never put on
the IO scheduler.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

v3: edits to patch header and __make_request() comment

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -764,7 +764,7 @@ static struct request *get_request(struc
 	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
-	int may_queue, priv;
+	int may_queue, priv = 0;
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -808,9 +808,14 @@ static struct request *get_request(struc
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
@@ -1197,6 +1202,7 @@ static int __make_request(struct request
 	const unsigned short prio = bio_prio(bio);
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	const bool unplug = !!(bio->bi_rw & REQ_UNPLUG);
+	const bool flush = !!(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	const unsigned long ff = bio->bi_rw & REQ_FAILFAST_MASK;
 	int where = ELEVATOR_INSERT_SORT;
 	int rw_flags;
@@ -1210,7 +1216,7 @@ static int __make_request(struct request
 
 	spin_lock_irq(q->queue_lock);
 
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+	if (flush) {
 		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;
 	}
@@ -1293,6 +1299,16 @@ get_rq:
 		rw_flags |= REQ_SYNC;
 
 	/*
+	 * Set REQ_SORTED for all requests that may be put on IO scheduler.
+	 * The request allocator's IO scheduler initialization will be skipped
+	 * if REQ_SORTED is not set -- elv_set_request() is avoided so that
+	 * that the allocated request's elevator_private pointers are not
+	 * initialized and that space can be used by flush request data.
+	 */
+	if (!flush)
+		rw_flags |= REQ_SORTED;
+
+	/*
 	 * Grab a free request. This is might sleep but can not fail.
 	 * Returns with the queue unlocked.
 	 */
