From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/4] Add buffer head related helper functions
Date: Thu, 15 Nov 2007 17:40:43 +0530
Message-ID: <1195128646-15143-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1195128646-15143-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: cmm@us.ibm.com, torvalds@linux-foundation.org,
	a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
	adilger@clusterfs.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:39060 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbXKOMLc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2007 07:11:32 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id lAFCBSub010318
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 23:11:28 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAFCBUxN2498696
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 23:11:30 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAFBAZfa004930
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2007 22:10:36 +1100
In-Reply-To: <1195128646-15143-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add buffer head related helper function
bh_uptodate_or_lock and bh_submit_read
which can be used by file system

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/buffer_head.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index da0d83f..82cc9ef 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -327,6 +327,35 @@ static inline void lock_buffer(struct buffer_head *bh)
 
 extern int __set_page_dirty_buffers(struct page *page);
 
+/* Return true if the buffer is up-to-date.
+ * Return false, with the buffer locked, if not.
+ */
+static inline int bh_uptodate_or_lock(struct buffer_head *bh)
+{
+	if (!buffer_uptodate(bh)) {
+		lock_buffer(bh);
+		if (!buffer_uptodate(bh))
+			return 0;
+		unlock_buffer(bh);
+	}
+	return 1;
+}
+/*
+ * Submit a locked buffer for reading,
+ * return a negative error and release
+ * the buffer if failed.
+ */
+static inline int bh_submit_read(struct buffer_head *bh)
+{
+	get_bh(bh);
+	bh->b_end_io = end_buffer_read_sync;
+	submit_bh(READ, bh);
+	wait_on_buffer(bh);
+	if (buffer_uptodate(bh))
+		return 0;
+	brelse(bh);
+	return -EIO;
+}
 #else /* CONFIG_BLOCK */
 
 static inline void buffer_init(void) {}
-- 
1.5.3.5.652.gf192c-dirty
