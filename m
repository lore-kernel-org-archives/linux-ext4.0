From: Anton Blanchard <anton@samba.org>
Subject: [PATCH 1/2] ext4: EXT4_FREEBLOCKS_WATERMARK is overly pessimistic
Date: Fri, 26 Aug 2011 07:26:22 +1000
Message-ID: <20110826072622.406d3395@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca, eric.dumazet@gmail.com,
	tj@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1HYV0Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Aug 2011 17:26:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


When testing on a 1024 thread ppc64 box I noticed a large amount of
CPU time in ext4 code.

ext4_has_free_blocks has a fast path to avoid summing every free and
dirty block per cpu counter, but only if the global count shows more
free blocks than the maximum amount that could be stored in all the
per cpu counters.

While we are summing 2 per cpu counters we set the breakpoint at 4
times the maximum amount in the per cpu counter portion. Reduce that
to 2.

Since we fold the per cpu count of CPUs going offline into the global
count, we can use num_online_cpus() instead of nr_cpu_ids here too.

Both these changes match percpu_counter_compare() which is used to
optimise a comparison against one per cpu counter.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-work/fs/ext4/ext4.h
===================================================================
--- linux-2.6-work.orig/fs/ext4/ext4.h	2011-08-25 11:44:02.978785464 +1000
+++ linux-2.6-work/fs/ext4/ext4.h	2011-08-25 14:17:37.461904013 +1000
@@ -2051,10 +2051,11 @@ do {								\
 
 #ifdef CONFIG_SMP
 /* Each CPU can accumulate percpu_counter_batch blocks in their local
- * counters. So we need to make sure we have free blocks more
- * than percpu_counter_batch  * nr_cpu_ids. Also add a window of 4 times.
+ * counters. Since we sum two percpu counters (s_freeblocks_counter and
+ * s_dirtyblocks_counter), as a worst case we need to check for 2x this.
  */
-#define EXT4_FREEBLOCKS_WATERMARK (4 * (percpu_counter_batch * nr_cpu_ids))
+#define EXT4_FREEBLOCKS_WATERMARK \
+			(2 * (percpu_counter_batch * num_online_cpus()))
 #else
 #define EXT4_FREEBLOCKS_WATERMARK 0
 #endif
