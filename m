From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] sched: separate out io_schedule_prepare() and io_schedule_finish()
Date: Fri, 28 Oct 2016 12:58:10 -0400
Message-ID: <1477673892-28940-3-git-send-email-tj@kernel.org>
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

Now that IO schedule accounting is done inside __schedule(),
io_schedule() can be split into three steps - prep, schedule, and
finish - where the schedule part doesn't need any special annotation.
This allows marking a sleep as iowait by simply wrapping an existing
blocking function with io_schedule_prepare() and io_schedule_finish().

Because task_struct->in_iowait is single bit, the caller of
io_schedule_prepare() needs to record and the pass its state to
io_schedule_finish() to be safe regarding nesting.  While this isn't
the prettiest, these functions are mostly gonna be used by core
functions and we don't want to use more space for ->in_iowait.

While at it, as it's simple to do now, reimplement io_schedule()
without unnecessarily going through io_schedule_timeout().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 include/linux/sched.h |  8 +++-----
 kernel/sched/core.c   | 33 ++++++++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 348f51b..c025f77 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -441,12 +441,10 @@ extern signed long schedule_timeout_idle(signed long timeout);
 asmlinkage void schedule(void);
 extern void schedule_preempt_disabled(void);
 
+extern int __must_check io_schedule_prepare(void);
+extern void io_schedule_finish(int token);
 extern long io_schedule_timeout(long timeout);
-
-static inline void io_schedule(void)
-{
-	io_schedule_timeout(MAX_SCHEDULE_TIMEOUT);
-}
+extern void io_schedule(void);
 
 void __noreturn do_task_dead(void);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f6baa38..30d3185 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5067,25 +5067,48 @@ int __sched yield_to(struct task_struct *p, bool preempt)
 }
 EXPORT_SYMBOL_GPL(yield_to);
 
+int io_schedule_prepare(void)
+{
+	int old_iowait = current->in_iowait;
+
+	current->in_iowait = 1;
+	blk_schedule_flush_plug(current);
+
+	return old_iowait;
+}
+
+void io_schedule_finish(int token)
+{
+	current->in_iowait = token;
+}
+
 /*
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
  */
 long __sched io_schedule_timeout(long timeout)
 {
-	int old_iowait = current->in_iowait;
+	int token;
 	long ret;
 
-	current->in_iowait = 1;
-	blk_schedule_flush_plug(current);
-
+	token = io_schedule_prepare();
 	ret = schedule_timeout(timeout);
-	current->in_iowait = old_iowait;
+	io_schedule_finish(token);
 
 	return ret;
 }
 EXPORT_SYMBOL(io_schedule_timeout);
 
+void io_schedule(void)
+{
+	int token;
+
+	token = io_schedule_prepare();
+	schedule();
+	io_schedule_finish(token);
+}
+EXPORT_SYMBOL(io_schedule);
+
 /**
  * sys_sched_get_priority_max - return maximum RT priority.
  * @policy: scheduling class.
-- 
2.7.4
