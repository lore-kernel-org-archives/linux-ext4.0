From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 1/2] add hrtimer_sleep_ns helper function
Date: Wed, 6 Aug 2008 15:08:19 -0400
Message-ID: <20080806190819.GH27394@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rwheeler@redhat.com, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbYHFTJA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 15:09:00 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This patch adds a function so that things within the kernel can sleep for
nanoseconds.  This is needed for the next patch in the series.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -345,6 +345,7 @@ extern long hrtimer_nanosleep_restart(st
 
 extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 				 struct task_struct *tsk);
+extern int hrtimer_sleep_ns(u64 ns, int interruptible);
 
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1459,12 +1459,14 @@ void hrtimer_init_sleeper(struct hrtimer
 #endif
 }
 
-static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
+static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode,
+				int interruptible)
 {
 	hrtimer_init_sleeper(t, current);
 
 	do {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(interruptible ? TASK_INTERRUPTIBLE :
+				  TASK_UNINTERRUPTIBLE);
 		hrtimer_start(&t->timer, t->timer.expires, mode);
 		if (!hrtimer_active(&t->timer))
 			t->task = NULL;
@@ -1482,6 +1484,22 @@ static int __sched do_nanosleep(struct h
 	return t->task == NULL;
 }
 
+int hrtimer_sleep_ns(u64 ns, int interruptible)
+{
+	struct hrtimer_sleeper t;
+	int ret = 0;
+
+	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	t.timer.expires = ktime_add_ns(ktime_get(), ns);
+
+	ret = do_nanosleep(&t, HRTIMER_MODE_ABS, interruptible);
+
+	destroy_hrtimer_on_stack(&t.timer);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hrtimer_sleep_ns);
+
 static int update_rmtp(struct hrtimer *timer, struct timespec __user *rmtp)
 {
 	struct timespec rmt;
@@ -1508,7 +1526,7 @@ long __sched hrtimer_nanosleep_restart(s
 				HRTIMER_MODE_ABS);
 	t.timer.expires.tv64 = restart->nanosleep.expires;
 
-	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
+	if (do_nanosleep(&t, HRTIMER_MODE_ABS, 1))
 		goto out;
 
 	rmtp = restart->nanosleep.rmtp;
@@ -1534,7 +1552,7 @@ long hrtimer_nanosleep(struct timespec *
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	t.timer.expires = timespec_to_ktime(*rqtp);
-	if (do_nanosleep(&t, mode))
+	if (do_nanosleep(&t, mode, 1))
 		goto out;
 
 	/* Absolute timers do not update the rmtp value and restart: */
