From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Fri, 16 Sep 2011 12:28:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109161222130.27520-100000@netrider.rowland.org>
References: <BAY151-W3498E8491E671BDAE90421A1070@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, <linux-ext4@vger.kernel.org>
To: Rocko Requin <rockorequin@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:50428 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750755Ab1IPQ2E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 12:28:04 -0400
In-Reply-To: <BAY151-W3498E8491E671BDAE90421A1070@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 15 Sep 2011, Rocko Requin wrote:

> Unfortunately the lockup is complete - I can't switch away from the X
> server and sysrq-t/p doesn't work if I'm in a tty console when it
> happens. The stack traces are like the ones I posted earlier in the
> bug, and they didn't contain any useful information.

Try applying the patch below.  It will print out some extra debugging
information during normal operation and especially when the USB drive
is mounted and unmounted.  Oh yes -- and be certain to run the test 
from a tty console so that the messages don't get lost.  Maybe you can 
capture the log messages using a network console.

This may not give any useful information in the end, because it 
concentrates on the BDI interface which Ted's patch should have fixed.  
If something else is causing your crashes, you might not see anything.  
But it's worth a try.

Alan Stern



Index: usb-3.1/kernel/timer.c
===================================================================
--- usb-3.1.orig/kernel/timer.c
+++ usb-3.1/kernel/timer.c
@@ -111,6 +111,143 @@ timer_set_base(struct timer_list *timer,
 				      tbase_get_deferrable(timer->base));
 }
 
+static void check_timer_list(struct list_head *start, char *name)
+{
+	struct timer_list *t, *tnext, *tprev, *nt;
+	struct list_head *h = start;
+
+	nt = NULL;
+	do {
+		if (!h->next || !h->prev) {
+			nt = list_entry(h, struct timer_list, entry);
+			break;
+		}
+		h = h->next;
+	} while (h != start);
+	if (!nt)
+		return;
+	pr_err("%s: Found bad timer at %p\n", name, nt);
+
+	tnext = tprev = list_entry(start, struct timer_list, entry);
+	list_for_each_entry(t, start, entry) {
+		if (!t)
+			break;
+		pr_info(" Entry %p cb %pS list %p\n", t, t->function,
+				t->entry.prev);
+		if (t == nt)
+			break;
+		tprev = t;
+	}
+	pr_info(" -----\n");
+
+	tnext = list_entry(start, struct timer_list, entry);
+	list_for_each_entry_reverse(t, start, entry) {
+		if (!t) {
+			pr_info(" Broken link\n");
+			break;
+		}
+		if (t == nt)
+			break;
+		pr_info(" Entry %p cb %pS list %p\n", t, t->function,
+				t->entry.next);
+		tnext = t;
+	}
+	pr_info(" ----- Fixing\n");
+	nt->entry.prev = &tprev->entry;
+	tprev->entry.next = &nt->entry;
+	nt->entry.next = &tnext->entry;
+	tnext->entry.prev = &nt->entry;
+}
+
+struct timer_list *alantimer;
+int alanok;
+
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
+
+struct perf_event * __percpu *alanhbp;
+unsigned long alanunused;
+int alanhbp_enabled;
+struct list_head **alanptr;
+
+extern void *last_bdi_unreg;
+
+static void check_alan(char *type)
+{
+	if (!alanok)
+		return;
+	if (!alantimer->entry.next || !alantimer->entry.prev) {
+		pr_err("ERROR %s: Bad alantimer %p\n", type, alantimer);
+		alanok = 0;
+	}
+}
+
+static void alanhbp_handler(struct perf_event *bp,
+			       struct perf_sample_data *data,
+			       struct pt_regs *regs)
+{
+	pr_info("*alanptr written: %p\n", *alanptr);
+	if (!alanok || !alanhbp_enabled)
+		return;
+	if (alantimer->entry.next)
+		return;
+	dump_stack();
+}
+
+static void set_alan(struct timer_list *timer)
+{
+	if (alantimer)
+		return;
+	alantimer = timer;
+	alanok = 1;
+
+	if (alanhbp)
+		alanhbp_enabled = (alanptr == &alantimer->entry.next);
+}
+
+static void clear_alan(struct timer_list *timer)
+{
+	if (alantimer != timer)
+		return;
+	alanok = 0;
+	alantimer = NULL;
+	alanhbp_enabled = 0;
+}
+
+void init_alan(unsigned long addr)
+{
+	struct perf_event_attr attr;
+
+	if (alanhbp) {
+		unregister_wide_hw_breakpoint(alanhbp);
+		alanhbp = NULL;
+		alanhbp_enabled = 0;
+	}
+
+	if (addr) {
+		hw_breakpoint_init(&attr);
+		attr.bp_addr = addr;
+		attr.bp_len = HW_BREAKPOINT_LEN_4;
+		attr.bp_type = HW_BREAKPOINT_W;
+		alanhbp = register_wide_hw_breakpoint(&attr, alanhbp_handler,
+				NULL);
+		if (IS_ERR((void __force *) alanhbp)) {
+			pr_info("Breakpoint reg failed %ld\n",
+					PTR_ERR((void __force *) alanhbp));
+			alanhbp = NULL;
+		} else if (!alanhbp) {
+			pr_info("alanhbp was not created\n");
+		} else {
+			pr_info("alanhbp created\n");
+		}
+
+		alanptr = (struct list_head **) addr;
+		alanhbp_enabled = (alanok && alanptr == &alantimer->entry.next);
+		pr_info("alanhbp set for %p\n", alanptr);
+	}
+}
+EXPORT_SYMBOL(init_alan);
+
 static unsigned long round_jiffies_common(unsigned long j, int cpu,
 		bool force_up)
 {
@@ -330,6 +467,9 @@ void set_timer_slack(struct timer_list *
 }
 EXPORT_SYMBOL_GPL(set_timer_slack);
 
+extern void wakeup_timer_fn(unsigned long data);
+#include <linux/backing-dev.h>
+
 static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
 	unsigned long expires = timer->expires;
@@ -369,7 +509,17 @@ static void internal_add_timer(struct tv
 	/*
 	 * Timers are FIFO:
 	 */
+check_timer_list(vec, "internal_add_1");
+if (timer->function == wakeup_timer_fn) {
+	struct backing_dev_info *bdi = (struct backing_dev_info *) timer->data;
+
+	pr_info("Adding wakeup %p: bdi %p name %s\n", timer, bdi, bdi->name);
+}
 	list_add_tail(&timer->entry, vec);
+if (timer->function == wakeup_timer_fn)
+	set_alan(timer);
+check_timer_list(vec, "internal_add_2");
+check_alan("add");
 }
 
 #ifdef CONFIG_TIMER_STATS
@@ -608,17 +758,24 @@ void init_timer_deferrable_key(struct ti
 }
 EXPORT_SYMBOL(init_timer_deferrable_key);
 
-static inline void detach_timer(struct timer_list *timer,
+static void detach_timer(struct timer_list *timer,
 				int clear_pending)
 {
 	struct list_head *entry = &timer->entry;
 
+check_alan("detach 1");
+if (timer->function == wakeup_timer_fn) {
+	pr_info("Detaching wakeup %p\n", timer);
+	clear_alan(timer);
+}
+
 	debug_deactivate(timer);
 
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
 		entry->next = NULL;
 	entry->prev = LIST_POISON2;
+check_alan("detach 2");
 }
 
 /*
@@ -1026,6 +1183,7 @@ static int cascade(struct tvec_base *bas
 	struct list_head tv_list;
 
 	list_replace_init(tv->vec + index, &tv_list);
+check_alan("cascade 1");
 
 	/*
 	 * We are removing _all_ timers from the list, so we
@@ -1033,7 +1191,10 @@ static int cascade(struct tvec_base *bas
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
 		BUG_ON(tbase_get_base(timer->base) != base);
+if (timer->function == wakeup_timer_fn)
+	pr_info("Cascading wakeup_timer %p\n", timer);
 		internal_add_timer(base, timer);
+check_alan("cascade 2");
 	}
 
 	return index;
@@ -1109,6 +1270,7 @@ static inline void __run_timers(struct t
 			cascade(base, &base->tv5, INDEX(3));
 		++base->timer_jiffies;
 		list_replace_init(base->tv1.vec + index, &work_list);
+check_alan("run 1");
 		while (!list_empty(head)) {
 			void (*fn)(unsigned long);
 			unsigned long data;
@@ -1148,6 +1310,7 @@ static unsigned long __next_timer_interr
 	/* Look for timer events in tv1. */
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
+check_timer_list(base->tv1.vec + slot, "next_timer_1");
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
 			if (tbase_get_deferrable(nte->base))
 				continue;
@@ -1179,6 +1342,7 @@ cascade:
 
 		index = slot = timer_jiffies & TVN_MASK;
 		do {
+check_timer_list(varp->vec + slot, "next_timer_2");
 			list_for_each_entry(nte, varp->vec + slot, entry) {
 				if (tbase_get_deferrable(nte->base))
 					continue;
Index: usb-3.1/mm/backing-dev.c
===================================================================
--- usb-3.1.orig/mm/backing-dev.c
+++ usb-3.1/mm/backing-dev.c
@@ -308,7 +308,7 @@ static void sync_supers_timer_fn(unsigne
 	bdi_arm_supers_timer();
 }
 
-static void wakeup_timer_fn(unsigned long data)
+void wakeup_timer_fn(unsigned long data)
 {
 	struct backing_dev_info *bdi = (struct backing_dev_info *)data;
 
@@ -328,6 +328,8 @@ static void wakeup_timer_fn(unsigned lon
 	spin_unlock_bh(&bdi->wb_lock);
 }
 
+void *last_bdi_unreg;
+
 /*
  * This function is used when the first inode for this bdi is marked dirty. It
  * wakes-up the corresponding bdi thread which should then take care of the
@@ -345,6 +347,8 @@ void bdi_wakeup_thread_delayed(struct ba
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
 	mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
+if (bdi == last_bdi_unreg)
+	dump_stack();
 }
 
 /*
@@ -547,6 +551,7 @@ int bdi_register(struct backing_dev_info
 			return PTR_ERR(wb->task);
 	}
 
+pr_info("bdi register %s %p\n", dev_name(dev), bdi);
 	bdi_debug_register(bdi, dev_name(dev));
 	set_bit(BDI_registered, &bdi->state);
 
@@ -617,6 +622,8 @@ void bdi_unregister(struct backing_dev_i
 		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
+pr_info("bdi_unreg: wb %p bdi %p\n", &bdi->wb, bdi);
+last_bdi_unreg = bdi;
 		del_timer_sync(&bdi->wb.wakeup_timer);
 
 		if (!bdi_cap_flush_forker(bdi))
@@ -632,6 +639,8 @@ static void bdi_wb_init(struct bdi_write
 {
 	memset(wb, 0, sizeof(*wb));
 
+pr_info("bdi_wb_init: wb %p bdi %p\n", wb, bdi);
+last_bdi_unreg = NULL;
 	wb->bdi = bdi;
 	wb->last_old_flush = jiffies;
 	INIT_LIST_HEAD(&wb->b_dirty);
Index: usb-3.1/drivers/usb/core/usb.c
===================================================================
--- usb-3.1.orig/drivers/usb/core/usb.c
+++ usb-3.1/drivers/usb/core/usb.c
@@ -974,6 +974,29 @@ struct dentry *usb_debug_root;
 EXPORT_SYMBOL_GPL(usb_debug_root);
 
 static struct dentry *usb_debug_devices;
+static struct dentry *alan_dentry;
+
+static ssize_t alan_write(struct file *fd, const char __user *buf,
+		size_t len, loff_t *ptr)
+{
+	unsigned long addr;
+	char buf2[16];
+	void init_alan(unsigned long);
+
+	if (len >= 16)
+		return -EINVAL;
+	buf2[len] = 0;
+	if (copy_from_user(buf2, buf, len))
+		return -EFAULT;
+
+	addr = simple_strtoul(buf2, NULL, 16);
+	init_alan(addr);
+	return len;
+}
+
+static const struct file_operations alan_fops = {
+	.write = alan_write,
+};
 
 static int usb_debugfs_init(void)
 {
@@ -990,11 +1013,17 @@ static int usb_debugfs_init(void)
 		return -ENOENT;
 	}
 
+	alan_dentry = debugfs_create_file("alan", 0200,
+				usb_debug_root, NULL, &alan_fops);
+	if (!alan_dentry)
+		pr_err("Unable to register alan\n");
+
 	return 0;
 }
 
 static void usb_debugfs_cleanup(void)
 {
+	debugfs_remove(alan_dentry);
 	debugfs_remove(usb_debug_devices);
 	debugfs_remove(usb_debug_root);
 }

