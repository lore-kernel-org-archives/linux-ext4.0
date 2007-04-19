From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
Date: Thu, 19 Apr 2007 14:41:55 +0200
Message-ID: <20070419124155.GC11780@kernel.dk>
References: <462622F8.10107@bull.net> <20070419090346.GE20928@kernel.dk> <462736FC.3090902@bull.net> <20070419115840.GA11780@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:6175 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031233AbXDSMoY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2007 08:44:24 -0400
Content-Disposition: inline
In-Reply-To: <20070419115840.GA11780@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 19 2007, Jens Axboe wrote:
> On Thu, Apr 19 2007, Valerie Clement wrote:
> > Jens Axboe wrote:
> > >Please tell me how you are running ffsb, and also please include a
> > >dmessg from a booted system.
> > >
> > Hi,
> > our mails crossed! please see my response to Andrew.
> > You could reproduce the problem with dd command as suggested, it's more 
> > easy.
> > I'm sending you the dmesg info. For my tests I used the scsci sdc device.
> 
> Thanks, it does. Can you try one thing for me? If you run the test on
> sdc, try doing:
> 
> # echo 64 > /sys/block/sdc/queue/iosched/quantum
> 
> and repeat the test.

And, then try this one as well (and don't tweak quantum for that
kernel):

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b6491c0..9e37971 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -986,9 +986,9 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	 * expire an async queue immediately if it has used up its slice. idle
 	 * queue always expire after 1 dispatch round.
 	 */
-	if ((!cfq_cfqq_sync(cfqq) &&
+	if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) &&
 	    cfqd->dispatch_slice >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
-	    cfq_class_idle(cfqq)) {
+	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
 		cfq_slice_expired(cfqd, 0, 0);
 	}
@@ -1051,19 +1051,21 @@ cfq_dispatch_requests(request_queue_t *q, int force)
 	while ((cfqq = cfq_select_queue(cfqd)) != NULL) {
 		int max_dispatch;
 
-		/*
-		 * Don't repeat dispatch from the previous queue.
-		 */
-		if (prev_cfqq == cfqq)
-			break;
+		if (cfqd->busy_queues > 1) {
+			/*
+			 * Don't repeat dispatch from the previous queue.
+			 */
+			if (prev_cfqq == cfqq)
+				break;
 
-		/*
-		 * So we have dispatched before in this round, if the
-		 * next queue has idling enabled (must be sync), don't
-		 * allow it service until the previous have continued.
-		 */
-		if (cfqd->rq_in_driver && cfq_cfqq_idle_window(cfqq))
-			break;
+			/*
+			 * So we have dispatched before in this round, if the
+			 * next queue has idling enabled (must be sync), don't
+			 * allow it service until the previous have continued.
+			 */
+			if (cfqd->rq_in_driver && cfq_cfqq_idle_window(cfqq))
+				break;
+		}
 
 		cfq_clear_cfqq_must_dispatch(cfqq);
 		cfq_clear_cfqq_wait_request(cfqq);
@@ -1370,7 +1372,9 @@ retry:
 		atomic_set(&cfqq->ref, 0);
 		cfqq->cfqd = cfqd;
 
-		cfq_mark_cfqq_idle_window(cfqq);
+		if (key != CFQ_KEY_ASYNC)
+			cfq_mark_cfqq_idle_window(cfqq);
+
 		cfq_mark_cfqq_prio_changed(cfqq);
 		cfq_mark_cfqq_queue_new(cfqq);
 		cfq_init_prio_data(cfqq);

-- 
Jens Axboe
