From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] Add buffer head related helper functions
Date: Mon, 19 Nov 2007 20:25:58 +0530
Message-ID: <1195484161-14472-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1195484161-14472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: cmm@us.ibm.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:49246 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbXKSPc1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2007 10:32:27 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id lAJEuPiC026784
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 01:56:25 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAJF034C243384
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 02:00:03 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAJEuAoS006726
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 01:56:10 +1100
In-Reply-To: <1195484161-14472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add buffer head related helper function
bh_uptodate_or_lock and bh_submit_read
which can be used by file system

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/buffer.c                 |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    2 ++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..7593ff3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3213,6 +3213,47 @@ static int buffer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
+/**
+ * bh_uptodate_or_lock: Test whether the buffer is uptodate
+ * @bh: struct buffer_head
+ *
+ * Return true if the buffer is up-to-date and false,
+ * with the buffer locked, if not.
+ */
+int bh_uptodate_or_lock(struct buffer_head *bh)
+{
+	if (!buffer_uptodate(bh)) {
+		lock_buffer(bh);
+		if (!buffer_uptodate(bh))
+			return 0;
+		unlock_buffer(bh);
+	}
+	return 1;
+}
+EXPORT_SYMBOL(bh_uptodate_or_lock);
+/**
+ * bh_submit_read: Submit a locked buffer for reading
+ * @bh: struct buffer_head
+ *
+ * Returns a negative error
+ */
+int bh_submit_read(struct buffer_head *bh)
+{
+	if (!buffer_locked(bh))
+		lock_buffer(bh);
+
+	if (buffer_uptodate(bh))
+		return 0;
+
+	get_bh(bh);
+	bh->b_end_io = end_buffer_read_sync;
+	submit_bh(READ, bh);
+	wait_on_buffer(bh);
+	if (buffer_uptodate(bh))
+		return 0;
+	return -EIO;
+}
+EXPORT_SYMBOL(bh_submit_read);
 void __init buffer_init(void)
 {
 	int nrpages;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index da0d83f..e98801f 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -192,6 +192,8 @@ int sync_dirty_buffer(struct buffer_head *bh);
 int submit_bh(int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
+int bh_uptodate_or_lock(struct buffer_head *bh);
+int bh_submit_read(struct buffer_head *bh);
 
 extern int buffer_heads_over_limit;
 
-- 
1.5.3.5.652.gf192c-dirty
