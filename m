From: akpm@linux-foundation.org
Subject: + add-buffer-head-related-helper-functions.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:19:57 -0800
Message-ID: <200711200719.lAK7JvUD020931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     Add buffer head related helper functions
has been added to the -mm tree.  Its filename is
     add-buffer-head-related-helper-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ext2-return-after-ext2_error-in-case-of-failures.patch
ext2-change-the-default-behaviour-on-error.patch
add-buffer-head-related-helper-functions.patch
ext2-add-block-bitmap-validation.patch
ext3-add-block-bitmap-validation.patch
ext4-add-block-bitmap-validation.patch
ext3-return-after-ext3_error-in-case-of-failures.patch
ext3-change-the-default-behaviour-on-error.patch
