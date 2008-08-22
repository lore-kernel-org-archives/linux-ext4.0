From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] percpu_counters: Add new function percpu_counter_sum_and_sub
Date: Fri, 22 Aug 2008 19:04:33 +0530
Message-ID: <1219412074-30584-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219412074-30584-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:58868 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYHVNep (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2008 09:34:45 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7MDZ2ec009783
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 23:35:02 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7MDYhni4018236
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 23:34:43 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7MDYgsI031293
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 23:34:43 +1000
In-Reply-To: <1219412074-30584-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

percpu_counter_sum_and_sub(struct percpu_counter *fbc, s64 amount)

This will be later used by ext4 code. It adds up the local
per cpu counter values to global count and subtract amount
from the gloabl count if gloabl count is > amount. This is
used during block resrevation to check within a lock we
have sufficient free blocks if so also claim the blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/percpu_counter.h |   17 +++++++++++++++++
 lib/percpu_counter.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index af485b1..978db67 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -36,6 +36,7 @@ void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
+s64 __percpu_counter_sum_and_sub(struct percpu_counter *fbc, s64 amount);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -53,6 +54,12 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 	return __percpu_counter_sum(fbc);
 }
 
+static inline int percpu_counter_sum_and_sub(struct percpu_counter *fbc,
+						s64 amount)
+{
+	return __percpu_counter_sum_and_sub(fbc, amount);
+}
+
 #if BITS_PER_LONG == 64
 static inline s64 fbc_count(struct percpu_counter *fbc)
 {
@@ -146,6 +153,16 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 	return percpu_counter_read(fbc);
 }
 
+static inline int percpu_counter_sum_and_sub(struct percpu_counter *fbc,
+						s64 amount)
+{
+	if (fbc->count >= amount) {
+		percpu_counter_sub(fbc, amount);
+		return 0;
+	}
+	return -E2BIG;
+}
+
 #endif	/* CONFIG_SMP */
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..0336062 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -71,6 +71,33 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
+ /*
+  * Add up all the per-cpu counts. If the result is greater than
+  * amount subtract amount from result and return 0. Otherwise return
+  * -E2BIG
+  */
+s64 __percpu_counter_sum_and_sub(struct percpu_counter *fbc, s64 amount)
+{
+	s64 ret;
+	int cpu;
+
+	spin_lock(&fbc->lock);
+	ret = fbc->count;
+	for_each_online_cpu(cpu) {
+		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		ret += *pcount;
+		*pcount = 0;
+	}
+	if (ret >= amount) {
+		fbc->count = ret - amount;
+		spin_unlock(&fbc->lock);
+		return 0;
+	}
+	spin_unlock(&fbc->lock);
+	return -E2BIG;
+}
+EXPORT_SYMBOL(__percpu_counter_sum_and_sub);
+
 static struct lock_class_key percpu_counter_irqsafe;
 
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
-- 
1.6.0.2.g2ebc0

