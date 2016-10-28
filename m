From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] mutex: add mutex_lock_io()
Date: Fri, 28 Oct 2016 12:58:11 -0400
Message-ID: <1477673892-28940-4-git-send-email-tj@kernel.org>
References: <1477673892-28940-1-git-send-email-tj@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, mingbo@fb.com,
        Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, axboe@kernel.dk,
        tytso@mit.edu, jack@suse.com, adilger.kernel@dilger.ca
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1477673892-28940-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We sometimes end up propagating IO blocking through mutexes; however,
because there currently is no way of annotating mutex sleeps as
iowait, there are cases where iowait and /proc/stat:procs_blocked
report misleading numbers obscuring the actual state of the system.

This patch adds mutex_lock_io() so that mutex sleeps can be marked as
iowait in those cases.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 include/linux/mutex.h  |  4 ++++
 kernel/locking/mutex.c | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 2cb7531..5d77ddd 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -142,10 +142,12 @@ extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
 					unsigned int subclass);
+extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass);
 
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
+#define mutex_lock_io(lock) mutex_lock_io_nested(lock, 0)
 
 #define mutex_lock_nest_lock(lock, nest_lock)				\
 do {									\
@@ -157,11 +159,13 @@ do {									\
 extern void mutex_lock(struct mutex *lock);
 extern int __must_check mutex_lock_interruptible(struct mutex *lock);
 extern int __must_check mutex_lock_killable(struct mutex *lock);
+extern void mutex_lock_io(struct mutex *lock);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
 # define mutex_lock_nest_lock(lock, nest_lock) mutex_lock(lock)
+# define mutex_lock_nest_io(lock, nest_lock) mutex_io(lock)
 #endif
 
 /*
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index a70b90d..a37709c 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -653,6 +653,20 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
 
+void __sched
+mutex_lock_io_nested(struct mutex *lock, unsigned int subclass)
+{
+	int token;
+
+	might_sleep();
+
+	token = io_schedule_prepare();
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    subclass, NULL, _RET_IP_, NULL, 0);
+	io_schedule_finish(token);
+}
+EXPORT_SYMBOL_GPL(mutex_lock_io_nested);
+
 static inline int
 ww_mutex_deadlock_injection(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 {
@@ -816,6 +830,16 @@ int __sched mutex_lock_killable(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
+void __sched mutex_lock_io(struct mutex *lock)
+{
+	int token;
+
+	token = io_schedule_prepare();
+	mutex_lock(lock);
+	io_schedule_finish(token);
+}
+EXPORT_SYMBOL_GPL(mutex_lock_io);
+
 __visible void __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
-- 
2.7.4

