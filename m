From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 1/2] block: skip elevator data initialization for flush
 requests
Date: Fri, 4 Feb 2011 11:58:39 -0500
Message-ID: <20110204165839.GA2630@redhat.com>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202225549.GA28109@redhat.com>
 <4D4AAC9A.4050407@fusionio.com>
 <20110203133820.GF2570@htj.dyndns.org>
 <20110204150456.GD32190@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"djwong@us.ibm.com" <djwong@us.ibm.com>,
	"shli@kernel.org" <shli@kernel.org>,
	"neilb@suse.de" <neilb@suse.de>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"jack@suse.cz" <jack@suse.cz>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kmannth@us.ibm.com" <kmannth@us.ibm.com>,
	"cmm@us.ibm.com" <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>,
	"hch@lst.de" <hch@lst.de>, "josef@redhat.com" <josef@redhat.com>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110204150456.GD32190@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Skip elevator initialization for flush requests by passing priv=0 to
blk_alloc_request() in get_request().  As such elv_set_request() is
never called for flush requests.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

v5: introduces blk_rq_should_init_elevator() to abstract the elevator
    initialization decision to promote future reuse and clarity.

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -753,6 +753,25 @@ static void freed_request(struct request
 }
 
 /*
+ * Determine if elevator data should be initialized when allocating the
+ * request associated with @bio.
+ */
+static bool blk_rq_should_init_elevator(struct bio *bio)
+{
+	if (!bio)
+		return true;
+
+	/*
+	 * Flush requests do not use the elevator so skip initialization.
+	 * This allows a request to share the flush and elevator data.
+	 */
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA))
+		return false;
+
+	return true;
+}
+
+/*
  * Get a free request, queue_lock must be held.
  * Returns NULL on failure, with queue_lock held.
  * Returns !NULL on success, with queue_lock *not held*.
@@ -764,7 +783,7 @@ static struct request *get_request(struc
 	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
-	int may_queue, priv;
+	int may_queue, priv = 0;
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -808,9 +827,11 @@ static struct request *get_request(struc
 	rl->count[is_sync]++;
 	rl->starved[is_sync] = 0;
 
-	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
-	if (priv)
-		rl->elvpriv++;
+	if (blk_rq_should_init_elevator(bio)) {
+		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+		if (priv)
+			rl->elvpriv++;
+	}
 
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
