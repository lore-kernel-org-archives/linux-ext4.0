From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/2] vfs: tracepoints for buffer flag updates
Date: Thu, 12 Nov 2009 00:00:59 +0530
Message-ID: <1257964260-14020-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56959 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbZKKSbE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Nov 2009 13:31:04 -0500
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp04.au.ibm.com (8.14.3/8.13.1) with ESMTP id nABIRx7R009120
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:27:59 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nABIRr8M1466532
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:27:53 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nABIV64Q020685
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2009 05:31:06 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We collect the device details so that we can filter with device value

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/buffer.c                        |    2 +
 include/linux/buffer_head.h        |   11 +++-
 include/trace/events/buffer_head.h |   95 ++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/buffer_head.h

diff --git a/fs/buffer.c b/fs/buffer.c
index 6fa5302..6f441aa 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -41,6 +41,8 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/buffer_head.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 16ed028..1780701 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/wait.h>
 #include <asm/atomic.h>
+#include <trace/events/buffer_head.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -84,10 +85,12 @@ struct buffer_head {
 static inline void set_buffer_##name(struct buffer_head *bh)		\
 {									\
 	set_bit(BH_##bit, &(bh)->b_state);				\
+	trace_set_buffer_##name(bh);					\
 }									\
 static inline void clear_buffer_##name(struct buffer_head *bh)		\
 {									\
 	clear_bit(BH_##bit, &(bh)->b_state);				\
+	trace_clear_buffer_##name(bh);					\
 }									\
 static inline int buffer_##name(const struct buffer_head *bh)		\
 {									\
@@ -100,11 +103,15 @@ static inline int buffer_##name(const struct buffer_head *bh)		\
 #define TAS_BUFFER_FNS(bit, name)					\
 static inline int test_set_buffer_##name(struct buffer_head *bh)	\
 {									\
-	return test_and_set_bit(BH_##bit, &(bh)->b_state);		\
+	int ret = test_and_set_bit(BH_##bit, &(bh)->b_state);		\
+	trace_set_buffer_##name(bh);					\
+	return ret;							\
 }									\
 static inline int test_clear_buffer_##name(struct buffer_head *bh)	\
 {									\
-	return test_and_clear_bit(BH_##bit, &(bh)->b_state);		\
+	int ret = test_and_clear_bit(BH_##bit, &(bh)->b_state);		\
+	trace_clear_buffer_##name(bh);					\
+	return ret;							\
 }									\
 
 /*
diff --git a/include/trace/events/buffer_head.h b/include/trace/events/buffer_head.h
new file mode 100644
index 0000000..07605b5
--- /dev/null
+++ b/include/trace/events/buffer_head.h
@@ -0,0 +1,95 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM buffer_head
+
+#if !defined(_TRACE_BUFFER_HEAD_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BUFFER_HEAD_H
+
+#include <linux/tracepoint.h>
+struct buffer_head;
+extern const char *jbd2_dev_to_name(dev_t device);
+
+
+#define BUFFER_HEAD_TRACE_EVENT(name)						\
+TRACE_EVENT(set_buffer_##name,							\
+	TP_PROTO(struct buffer_head *bh),					\
+										\
+	TP_ARGS(bh),								\
+										\
+	TP_STRUCT__entry(							\
+		__field(	void *,   buffer		)		\
+		__field(	sector_t, block			)		\
+		__field(	unsigned long,	state		)		\
+		__field(	dev_t,    dev			)		\
+	),									\
+										\
+	TP_fast_assign(								\
+		__entry->buffer = bh;						\
+		__entry->block	= bh->b_blocknr;				\
+		__entry->state	= bh->b_state;					\
+		if (bh->b_bdev)							\
+			__entry->dev	= disk_devt(bh->b_bdev->bd_disk);	\
+		else								\
+			__entry->dev	= 0;					\
+	),									\
+										\
+	TP_printk("bh = %p device = %s block = %llu new state = 0x%lx",		\
+			__entry->buffer, jbd2_dev_to_name(__entry->dev),	\
+			(unsigned long long) __entry->block,			\
+			  __entry->state)					\
+);										\
+										\
+TRACE_EVENT(clear_buffer_##name,						\
+	TP_PROTO(struct buffer_head *bh),					\
+										\
+	TP_ARGS(bh),								\
+										\
+	TP_STRUCT__entry(							\
+		__field(	void *,   buffer		)		\
+		__field(	sector_t, block			)		\
+		__field(	unsigned long,	  state		)		\
+		__field(	dev_t,    dev			)		\
+	),									\
+										\
+	TP_fast_assign(								\
+		__entry->buffer = bh;						\
+		__entry->block	= bh->b_blocknr;				\
+		__entry->state	= bh->b_state;					\
+		if (bh->b_bdev)							\
+			__entry->dev	= disk_devt(bh->b_bdev->bd_disk);	\
+		else								\
+			__entry->dev	= 0;					\
+	),									\
+										\
+	TP_printk("bh = %p device = %s block = %llu new state = 0x%lx",		\
+			__entry->buffer, jbd2_dev_to_name(__entry->dev),	\
+			(unsigned long long) __entry->block,			\
+			  __entry->state)					\
+)
+
+BUFFER_HEAD_TRACE_EVENT(uptodate);
+BUFFER_HEAD_TRACE_EVENT(dirty);
+BUFFER_HEAD_TRACE_EVENT(locked);
+BUFFER_HEAD_TRACE_EVENT(req);
+BUFFER_HEAD_TRACE_EVENT(mapped);
+BUFFER_HEAD_TRACE_EVENT(new);
+BUFFER_HEAD_TRACE_EVENT(async_read);
+BUFFER_HEAD_TRACE_EVENT(async_write);
+BUFFER_HEAD_TRACE_EVENT(delay);
+BUFFER_HEAD_TRACE_EVENT(boundary);
+BUFFER_HEAD_TRACE_EVENT(write_io_error);
+BUFFER_HEAD_TRACE_EVENT(ordered);
+BUFFER_HEAD_TRACE_EVENT(eopnotsupp);
+BUFFER_HEAD_TRACE_EVENT(unwritten);
+
+/* jbd */
+BUFFER_HEAD_TRACE_EVENT(jbd);
+BUFFER_HEAD_TRACE_EVENT(jwrite);
+BUFFER_HEAD_TRACE_EVENT(jbddirty);
+BUFFER_HEAD_TRACE_EVENT(revoked);
+BUFFER_HEAD_TRACE_EVENT(revokevalid);
+BUFFER_HEAD_TRACE_EVENT(freed);
+
+#endif /* _TRACE_BUFFER_HEAD_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.6.5.2.74.g610f9

