From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v3 1/4] sched: move IO scheduling accounting from
 io_schedule_timeout() into scheduler
Date: Wed, 7 Dec 2016 15:48:41 -0500
Message-ID: <20161207204841.GA22296@htj.duckdns.org>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
 <1477673892-28940-2-git-send-email-tj@kernel.org>
 <20161206212935.GB26314@mtj.duckdns.org>
 <20161207093510.GE3107@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, axboe@kernel.dk, tytso@mit.edu, jack@suse.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, mingbo@fb.com
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161207093510.GE3107@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

Yeah, that works.  Here's v3 based on your patch.  The other patches
still apply correctly.

Thanks.

------ 8< ------
For an interface to support blocking for IOs, it must call
io_schedule() instead of schedule().  This makes it tedious to add IO
blocking to existing interfaces as the switching between schedule()
and io_schedule() is often buried deep.

As we already have a way to mark the task as IO scheduling, this can
be made easier by separating out io_schedule() into multiple steps so
that IO schedule preparation can be performed before invoking a
blocking interface and the actual accounting happens inside the
scheduler.

io_schedule_timeout() does the following three things prior to calling
schedule_timeout().

 1. Mark the task as scheduling for IO.
 2. Flush out plugged IOs.
 3. Account the IO scheduling.

#1 and #2 can be performed in the prepartaion step while #3 must be
done close to the actual scheduling.  This patch moves #3 into the
scheduler so that later patches can separate out preparation and
finish steps from io_schedule().

v3: Replaced with PeterZ's implementation which performs nr_iowait
    accounting in the sleep and wake up path to avoid unnecessarily
    burdening non sleeping paths in __schedule().

v2: Remember the rq in @prev_rq and use it for decrementing nr_iowait
    to avoid misattributing the count after the task gets migrated to
    another CPU.  Noticed by Pavan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Patch-originally-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavan Kondeti <pkondeti@codeaurora.org>
---
 kernel/sched/core.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 7 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2085,11 +2085,24 @@ try_to_wake_up(struct task_struct *p, un
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
 
+	if (p->in_iowait) {
+		delayacct_blkio_end();
+		atomic_dec(&task_rq(p)->nr_iowait);
+	}
+
 	cpu = select_task_rq(p, p->wake_cpu, SD_BALANCE_WAKE, wake_flags);
 	if (task_cpu(p) != cpu) {
 		wake_flags |= WF_MIGRATED;
 		set_task_cpu(p, cpu);
 	}
+
+#else /* CONFIG_SMP */
+
+	if (p->in_iowait) {
+		delayacct_blkio_end();
+		atomic_dec(&task_rq(p)->nr_iowait);
+	}
+
 #endif /* CONFIG_SMP */
 
 	ttwu_queue(p, cpu, wake_flags);
@@ -2139,8 +2152,13 @@ static void try_to_wake_up_local(struct
 
 	trace_sched_waking(p);
 
-	if (!task_on_rq_queued(p))
+	if (!task_on_rq_queued(p)) {
+		if (p->in_iowait) {
+			delayacct_blkio_end();
+			atomic_dec(&rq->nr_iowait);
+		}
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+	}
 
 	ttwu_do_wakeup(rq, p, 0, cookie);
 	ttwu_stat(p, smp_processor_id(), 0);
@@ -2948,6 +2966,36 @@ unsigned long long nr_context_switches(v
 	return sum;
 }
 
+/*
+ * IO-wait accounting, and how its mostly bollocks (on SMP).
+ *
+ * The idea behind IO-wait account is to account the idle time that we could
+ * have spend running if it were not for IO. That is, if we were to improve the
+ * storage performance, we'd have a proportional reduction in IO-wait time.
+ *
+ * This all works nicely on UP, where, when a task blocks on IO, we account
+ * idle time as IO-wait, because if the storage were faster, it could've been
+ * running and we'd not be idle.
+ *
+ * This has been extended to SMP, by doing the same for each CPU. This however
+ * is broken.
+ *
+ * Imagine for instance the case where two tasks block on one CPU, only the one
+ * CPU will have IO-wait accounted, while the other has regular idle. Even
+ * though, if the storage were faster, both could've ran at the same time,
+ * utilising both CPUs.
+ *
+ * This means, that when looking globally, the current IO-wait accounting on
+ * SMP is a lower bound, by reason of under accounting.
+ *
+ * Worse, since the numbers are provided per CPU, they are sometimes
+ * interpreted per CPU, and that is nonsensical. A blocked task isn't strictly
+ * associated with any one particular CPU, it can wake to another CPU than it
+ * blocked on. This means the per CPU IO-wait number is meaningless.
+ *
+ * Task CPU affinities can make all that even more 'interesting'.
+ */
+
 unsigned long nr_iowait(void)
 {
 	unsigned long i, sum = 0;
@@ -2958,6 +3006,13 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
+/*
+ * Consumers of these two interfaces, like for example the cpufreq menu
+ * governor are using nonsensical data. Boosting frequency for a CPU that has
+ * IO-wait which might not even end up running the task when it does become
+ * runnable.
+ */
+
 unsigned long nr_iowait_cpu(int cpu)
 {
 	struct rq *this = cpu_rq(cpu);
@@ -3369,6 +3424,11 @@ static void __sched notrace __schedule(b
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
 
+			if (prev->in_iowait) {
+				atomic_inc(&rq->nr_iowait);
+				delayacct_blkio_start();
+			}
+
 			/*
 			 * If a worker went to sleep, notify and ask workqueue
 			 * whether it wants to wake up a task to maintain
@@ -5063,19 +5123,13 @@ EXPORT_SYMBOL_GPL(yield_to);
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
