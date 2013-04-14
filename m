From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] blkdev: add flush generation counter
Date: Sun, 14 Apr 2013 23:34:27 +0400
Message-ID: <1365968068-11766-1-git-send-email-dmonakhov@openvz.org>
References: <87wqs4kiyi.fsf@openvz.org>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, axboe@kernel.dk,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:24923 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3DNTfk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Apr 2013 15:35:40 -0400
In-Reply-To: <87wqs4kiyi.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Callers may use this counter to optimize flushes

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-core.c       |    1 +
 block/blk-flush.c      |    3 ++-
 include/linux/blkdev.h |    1 +
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 074b758..afb5a4b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -537,6 +537,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	spin_unlock_irq(lock);
 	mutex_unlock(&q->sysfs_lock);
 
+	atomic_set(&q->flush_tag, 0);
 	/*
 	 * Drain all requests queued before DYING marking. Set DEAD flag to
 	 * prevent that q->request_fn() gets invoked after draining finished.
diff --git a/block/blk-flush.c b/block/blk-flush.c
index cc2b827..b1adc75 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -203,7 +203,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 	/* account completion of the flush request */
 	q->flush_running_idx ^= 1;
 	elv_completed_request(q, flush_rq);
-
+	atomic_inc(&q->flush_tag);
 	/* and push the waiting requests to the next stage */
 	list_for_each_entry_safe(rq, n, running, flush.list) {
 		unsigned int seq = blk_flush_cur_seq(rq);
@@ -268,6 +268,7 @@ static bool blk_kick_flush(struct request_queue *q)
 	q->flush_rq.end_io = flush_end_io;
 
 	q->flush_pending_idx ^= 1;
+	atomic_inc(&q->flush_tag);
 	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
 	return true;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 78feda9..e079fbd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -416,6 +416,7 @@ struct request_queue {
 	unsigned int		flush_queue_delayed:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
+	atomic_t		flush_tag;
 	unsigned long		flush_pending_since;
 	struct list_head	flush_queue[2];
 	struct list_head	flush_data_in_flight;
-- 
1.7.1

