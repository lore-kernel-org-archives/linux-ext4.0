From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] sched: move IO scheduling accounting from io_schedule_timeout() to __schedule()
Date: Fri, 28 Oct 2016 12:58:09 -0400
Message-ID: <1477673892-28940-2-git-send-email-tj@kernel.org>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, mingbo@fb.com,
        Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, axboe@kernel.dk,
        tytso@mit.edu, jack@suse.com, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477673892-28940-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For an interface to support blocking for IOs, it must call
io_schedule() instead of schedule().  This makes it tedious to add IO
blocking to existing interfaces as the switching between schedule()
and io_schedule() is often buried deep.

As we already have a way to mark the task as IO scheduling, this can
be made easier by separating out io_schedule() into multiple steps so
that IO schedule preparation can be performed before invoking a
blocking interface and the actual accounting happens inside
schedule().

io_schedule_timeout() does the following three things prior to calling
schedule_timeout().

 1. Mark the task as scheduling for IO.
 2. Flush out plugged IOs.
 3. Account the IO scheduling.

#1 and #2 can be performed in the prepartaion step while #3 must be
done close to the actual scheduling.  This patch moves #3 into
__schedule() so that later patches can separate out preparation and
finish steps from io_schedule().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 kernel/sched/core.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 94732d1..f6baa38 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3336,11 +3336,17 @@ static void __sched notrace __schedule(bool preempt)
 	unsigned long *switch_count;
 	struct pin_cookie cookie;
 	struct rq *rq;
-	int cpu;
+	int cpu, in_iowait;
 
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	prev = rq->curr;
+	in_iowait = prev->in_iowait;
+
+	if (in_iowait) {
+		delayacct_blkio_start();
+		atomic_inc(&rq->nr_iowait);
+	}
 
 	schedule_debug(prev);
 
@@ -3406,6 +3412,11 @@ static void __sched notrace __schedule(bool preempt)
 	}
 
 	balance_callback(rq);
+
+	if (in_iowait) {
+		atomic_dec(&rq->nr_iowait);
+		delayacct_blkio_end();
+	}
 }
 
 void __noreturn do_task_dead(void)
@@ -5063,19 +5074,13 @@ EXPORT_SYMBOL_GPL(yield_to);
 long __sched io_schedule_timeout(long timeout)
 {
 	int old_iowait = current->in_iowait;
-	struct rq *rq;
 	long ret;
 
 	current->in_iowait = 1;
 	blk_schedule_flush_plug(current);
 
-	delayacct_blkio_start();
-	rq = raw_rq();
-	atomic_inc(&rq->nr_iowait);
 	ret = schedule_timeout(timeout);
 	current->in_iowait = old_iowait;
-	atomic_dec(&rq->nr_iowait);
-	delayacct_blkio_end();
 
 	return ret;
 }
-- 
2.7.4
