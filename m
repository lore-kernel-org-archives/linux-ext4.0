From: akpm@linux-foundation.org
Subject: - add-buffer-head-related-helper-functions.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:36 -0800
Message-ID: <200802012230.m11MUaib001921@imap1.linux-foundation.org>
To: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbYBAWl3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2008 17:41:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     Add buffer head related helper functions
has been removed from the -mm tree.  Its filename was
     add-buffer-head-related-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add buffer head related helper functions
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Add buffer head related helper function bh_uptodate_or_lock() and
bh_submit_read() which can be used by file systems.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   41 ++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    2 +
 2 files changed, 43 insertions(+)

diff -puN fs/buffer.c~add-buffer-head-related-helper-functions fs/buffer.c
--- a/fs/buffer.c~add-buffer-head-related-helper-functions
+++ a/fs/buffer.c
@@ -3204,6 +3204,47 @@ init_buffer_head(struct kmem_cache *cach
 	INIT_LIST_HEAD(&bh->b_assoc_buffers);
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
diff -puN include/linux/buffer_head.h~add-buffer-head-related-helper-functions include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~add-buffer-head-related-helper-functions
+++ a/include/linux/buffer_head.h
@@ -192,6 +192,8 @@ int sync_dirty_buffer(struct buffer_head
 int submit_bh(int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
+int bh_uptodate_or_lock(struct buffer_head *bh);
+int bh_submit_read(struct buffer_head *bh);
 
 extern int buffer_heads_over_limit;
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
ext2-return-after-ext2_error-in-case-of-failures.patch
ext2-change-the-default-behaviour-on-error.patch
ext2-add-block-bitmap-validation.patch
ext3-add-block-bitmap-validation.patch
ext3-return-after-ext3_error-in-case-of-failures.patch
ext3-change-the-default-behaviour-on-error.patch
