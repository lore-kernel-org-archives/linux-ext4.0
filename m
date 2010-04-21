From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] block: Add a trace point whenever a barrier IO request is
	sent
Date: Wed, 21 Apr 2010 13:56:26 -0700
Message-ID: <20100421205626.GA15607@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34065 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab0DUU4r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 16:56:47 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Simple debugging patch used to watch for barrier requests.  I've been using
this to watch ext4's barrier=1 behavior.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 block/blk-core.c             |    4 ++++
 include/trace/events/block.h |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)


diff --git a/block/blk-core.c b/block/blk-core.c
index 9fe174d..fe02ea7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -36,6 +36,7 @@
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_barrier);
 
 static int __make_request(struct request_queue *q, struct bio *bio);
 
@@ -1135,6 +1136,9 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	if (bio_rw_flagged(bio, BIO_RW_NOIDLE))
 		req->cmd_flags |= REQ_NOIDLE;
 
+	if (req->cmd_flags & (REQ_HARDBARRIER | REQ_SOFTBARRIER))
+		trace_block_barrier(req, bio);
+
 	req->errors = 0;
 	req->__sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index d870a91..ccf96c3 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -198,6 +198,41 @@ TRACE_EVENT(block_bio_bounce,
 );
 
 /**
+ * block_barrier - barrier operation requested
+ * @r: request that asked for the barrier
+ * @bio: block operation
+ *
+ * This tracepoint indicates that a barrier operation has been
+ * requested and a flush will be sent to the underlying block
+ * device.
+ */
+TRACE_EVENT(block_barrier,
+
+	TP_PROTO(struct request *r, struct bio *bio),
+
+	TP_ARGS(r, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev		)
+		__field( sector_t,	sector		)
+		__field( unsigned,	nr_sector	)
+		__field( unsigned,	cmd_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->cmd_flags	= r->cmd_flags;
+	),
+
+	TP_printk("%d:%d %llu + %u [0x%x]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->cmd_flags)
+);
+
+/**
  * block_bio_complete - completed all work on the block operation
  * @q: queue holding the block operation
  * @bio: block operation completed
