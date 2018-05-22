From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Tue, 22 May 2018 20:20:06 +0900
Message-ID: <201805222020.FEJ82897.OFtJMFHOVLQOSF@I-love.SAKURA.ne.jp>
References: <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
        <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
        <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
        <6db16aa3a7c56b6dcca2d10b4e100a780c740081.camel@wdc.com>
        <201805220652.BFH82351.SMQFFOJOtFOVLH@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        jthumshirn@suse.de, alan.christopher.jenkins@gmail.com,
        syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com,
        martin.petersen@oracle.com, axboe@kernel.dk,
        dan.j.williams@intel.com, hch@lst.de, oleksandr@natalenko.name,
        ming.lei@redhat.com, martin@lichtvoll.de, hare@suse.com,
        syzkaller-bugs@googlegroups.com, ross.zwisler@linux.intel.com,
        keith.busch@intel.com, linux-ext4@vger.kernel.org
To: Bart.VanAssche@wdc.com, dvyukov@google.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201805220652.BFH82351.SMQFFOJOtFOVLH@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I checked counter values using debug printk() patch shown below, and
found that q->q_usage_counter.count == 1 when this deadlock occurs.

Since sum of percpu_count did not change after percpu_ref_kill(), this is
not a race condition while folding percpu counter values into atomic counter
value. That is, for some reason, someone who is responsible for calling
percpu_ref_put(&q->q_usage_counter) (presumably via blk_queue_exit()) is
unable to call percpu_ref_put().

diff --git a/block/blk-core.c b/block/blk-core.c
index 85909b4..6933020 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -908,6 +908,12 @@ struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
+static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
+{
+	return (unsigned long __percpu *)
+		(ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC_DEAD);
+}
+
 /**
  * blk_queue_enter() - try to increase q->q_usage_counter
  * @q: request queue pointer
@@ -950,10 +956,22 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 		 */
 		smp_rmb();
 
-		wait_event(q->mq_freeze_wq,
-			   (atomic_read(&q->mq_freeze_depth) == 0 &&
-			    (preempt || !blk_queue_preempt_only(q))) ||
-			   blk_queue_dying(q));
+		while (wait_event_timeout(q->mq_freeze_wq,
+					  (atomic_read(&q->mq_freeze_depth) == 0 &&
+					   (preempt || !blk_queue_preempt_only(q))) ||
+					  blk_queue_dying(q), 3 * HZ) == 0) {
+			struct percpu_ref *ref = &q->q_usage_counter;
+			unsigned long __percpu *percpu_count = percpu_count_ptr(ref);
+			unsigned long count = 0;
+			int cpu;
+
+			for_each_possible_cpu(cpu)
+				count += *per_cpu_ptr(percpu_count, cpu);
+
+			printk("%s(%d): %px %ld %ld\n", current->comm, current->pid,
+			       ref, atomic_long_read(&ref->count), count);
+		}
+
 		if (blk_queue_dying(q))
 			return -ENODEV;
 	}
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 9f96fa7..72773ce 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -133,8 +133,8 @@ static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
 	for_each_possible_cpu(cpu)
 		count += *per_cpu_ptr(percpu_count, cpu);
 
-	pr_debug("global %ld percpu %ld",
-		 atomic_long_read(&ref->count), (long)count);
+	printk("%px global %ld percpu %ld\n", ref,
+	       atomic_long_read(&ref->count), (long)count);
 
 	/*
 	 * It's crucial that we sum the percpu counters _before_ adding the sum
@@ -150,6 +150,8 @@ static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
 	 */
 	atomic_long_add((long)count - PERCPU_COUNT_BIAS, &ref->count);
 
+	printk("%px global %ld\n", ref, atomic_long_read(&ref->count));
+
 	WARN_ONCE(atomic_long_read(&ref->count) <= 0,
 		  "percpu ref (%pf) <= 0 (%ld) after switching to atomic",
 		  ref->release, atomic_long_read(&ref->count));

If I change blk_queue_enter() not to wait at wait_event() if
q->mq_freeze_depth != 0, this deadlock problem does not occur.

Also, I found that if blk_freeze_queue_start() tries to wait for
counters to become 1 before calling percpu_ref_kill() (like shown
below), this deadlock problem does not occur.

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9ce9cac..4bff534 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -134,12 +134,36 @@ void blk_mq_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight_rw, &mi);
 }
 
+#define PERCPU_COUNT_BIAS       (1LU << (BITS_PER_LONG - 1))
+
+static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
+{
+	return (unsigned long __percpu *)
+		(ref->percpu_count_ptr & ~__PERCPU_REF_ATOMIC_DEAD);
+}
+
 void blk_freeze_queue_start(struct request_queue *q)
 {
 	int freeze_depth;
 
 	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
 	if (freeze_depth == 1) {
+		int i;
+		for (i = 0; i < 10; i++) {
+			struct percpu_ref *ref = &q->q_usage_counter;
+			unsigned long __percpu *percpu_count = percpu_count_ptr(ref);
+			unsigned long count = 0;
+			int cpu;
+
+			for_each_possible_cpu(cpu)
+				count += *per_cpu_ptr(percpu_count, cpu);
+
+			if (atomic_long_read(&ref->count) + count - PERCPU_COUNT_BIAS == 1)
+				break;
+			printk("%s(%d):! %px %ld %ld\n", current->comm, current->pid,
+			       ref, atomic_long_read(&ref->count), count);
+			schedule_timeout_uninterruptible(HZ / 10);
+		}
 		percpu_ref_kill(&q->q_usage_counter);
 		if (q->mq_ops)
 			blk_mq_run_hw_queues(q, false);

But I don't know how to find someone who is failing to call percpu_ref_put()...
