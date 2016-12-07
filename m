From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/4] sched: move IO scheduling accounting from
 io_schedule_timeout() to __schedule()
Date: Wed, 7 Dec 2016 10:35:10 +0100
Message-ID: <20161207093510.GE3107@twins.programming.kicks-ass.net>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
 <1477673892-28940-2-git-send-email-tj@kernel.org>
 <20161206212935.GB26314@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, axboe@kernel.dk, tytso@mit.edu, jack@suse.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, mingbo@fb.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161206212935.GB26314@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 06, 2016 at 04:29:35PM -0500, Tejun Heo wrote:

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3335,12 +3335,18 @@ static void __sched notrace __schedule(b
>  	struct task_struct *prev, *next;
>  	unsigned long *switch_count;
>  	struct pin_cookie cookie;
> -	struct rq *rq;
> -	int cpu;
> +	struct rq *rq, *prev_rq;
> +	int cpu, in_iowait;
>  
>  	cpu = smp_processor_id();
> -	rq = cpu_rq(cpu);
> +	rq = prev_rq = cpu_rq(cpu);
>  	prev = rq->curr;
> +	in_iowait = prev->in_iowait;
> +
> +	if (in_iowait) {
> +		delayacct_blkio_start();
> +		atomic_inc(&rq->nr_iowait);
> +	}
>  
>  	schedule_debug(prev);
>  
> @@ -3406,6 +3412,11 @@ static void __sched notrace __schedule(b
>  	}
>  
>  	balance_callback(rq);
> +
> +	if (in_iowait) {
> +		atomic_dec(&prev_rq->nr_iowait);
> +		delayacct_blkio_end();
> +	}
>  }
>  
>  void __noreturn do_task_dead(void)

So I really dislike this, it mucks with the fast paths for something of
dubious utility.

At the very least move this to the actual blocking paths such that
regular context switches don't see this overhead (also delayacct is
horrific crap).

A little something like so... completely untested.

---
 kernel/sched/core.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8b08fb257856..935bcd91f4a4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2085,11 +2085,24 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
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
@@ -2139,8 +2152,13 @@ static void try_to_wake_up_local(struct task_struct *p, struct pin_cookie cookie
 
 	trace_sched_waking(p);
 
-	if (!task_on_rq_queued(p))
+	if (!task_on_rq_queued(p)) {
+		if (p->in_iowait) {
+			delayacct_blkio_end();
+			atomic_dec(&task_rq(p)->nr_iowait);
+		}
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+	}
 
 	ttwu_do_wakeup(rq, p, 0, cookie);
 	ttwu_stat(p, smp_processor_id(), 0);
@@ -2948,6 +2966,36 @@ unsigned long long nr_context_switches(void)
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
@@ -3369,6 +3424,11 @@ static void __sched notrace __schedule(bool preempt)
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
