From: Anton Blanchard <anton@samba.org>
Subject: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
Date: Fri, 26 Aug 2011 07:29:27 +1000
Message-ID: <20110826072927.5b4781f9@kryten>
References: <20110826072622.406d3395@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca, eric.dumazet@gmail.com,
	tj@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:34975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1HYV3a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Aug 2011 17:29:30 -0400
In-Reply-To: <20110826072622.406d3395@kryten>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


When testing on a 1024 thread ppc64 box I noticed a large amount of
CPU time in ext4 code.

ext4_has_free_blocks has a fast path to avoid summing every free and
dirty block per cpu counter, but only if the global count shows more
free blocks than the maximum amount that could be stored in all the
per cpu counters.

Since percpu_counter_batch scales with num_online_cpus() and the maximum
amount in all per cpu counters is percpu_counter_batch * num_online_cpus(),
this breakpoint grows at O(n^2).

This issue will also hit with users of percpu_counter_compare which
does a similar thing for one percpu counter.

I chose to cap percpu_counter_batch at 1024 as a conservative first
step, but we may want to reduce it further based on further benchmarking.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-work/lib/percpu_counter.c
===================================================================
--- linux-2.6-work.orig/lib/percpu_counter.c	2011-07-31 20:37:12.580765739 +1000
+++ linux-2.6-work/lib/percpu_counter.c	2011-08-25 11:43:57.828695957 +1000
@@ -149,11 +149,15 @@ EXPORT_SYMBOL(percpu_counter_destroy);
 int percpu_counter_batch __read_mostly = 32;
 EXPORT_SYMBOL(percpu_counter_batch);
 
+/*
+ * We set the batch at 2 * num_online_cpus(), with a minimum of 32 and
+ * a maximum of 1024.
+ */
 static void compute_batch_value(void)
 {
 	int nr = num_online_cpus();
 
-	percpu_counter_batch = max(32, nr*2);
+	percpu_counter_batch = min(1024, max(32, nr*2));
 }
 
 static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
