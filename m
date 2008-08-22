From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] percpu_counters: make fbc->count read atomic on 32 bit architecture
Date: Fri, 22 Aug 2008 19:04:32 +0530
Message-ID: <1219412074-30584-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:58846 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYHVNeo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2008 09:34:44 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7MDZ1PP009713
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 23:35:01 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7MDYfbw3670146
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 23:34:41 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7MDYeNw031262
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 23:34:41 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fbc->count is of type s64. The change was introduced by
0216bfcffe424a5473daa4da47440881b36c1f4 which changed the type
from long to s64. Moving to s64 also means on 32 bit architectures
we can get wrong values on fbc->count.

percpu_counter_read is used within interrupt context also. So
use the irq safe version of spinlock while reading

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 9007ccd..af485b1 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -53,10 +53,29 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 	return __percpu_counter_sum(fbc);
 }
 
-static inline s64 percpu_counter_read(struct percpu_counter *fbc)
+#if BITS_PER_LONG == 64
+static inline s64 fbc_count(struct percpu_counter *fbc)
 {
 	return fbc->count;
 }
+#else
+/* doesn't have atomic 64 bit operation */
+static inline s64 fbc_count(struct percpu_counter *fbc)
+{
+	s64 ret;
+	unsigned long flags;
+	spin_lock_irqsave(&fbc->lock, flags);
+	ret = fbc->count;
+	spin_unlock_irqrestore(&fbc->lock, flags);
+	return ret;
+
+}
+#endif
+
+static inline s64 percpu_counter_read(struct percpu_counter *fbc)
+{
+	return fbc_count(fbc);
+}
 
 /*
  * It is possible for the percpu_counter_read() to return a small negative
@@ -65,7 +84,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = fbc_count(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
-- 
1.6.0.2.g2ebc0

