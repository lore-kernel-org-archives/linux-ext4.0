From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 15/17] fs: add a write_one_page_since
Date: Wed, 31 May 2017 08:45:38 -0400
Message-ID: <20170531124540.8782-16-jlayton@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531124540.8782-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Allow filesystems to pass in an errseq_t for a since value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/mm.h  |  2 ++
 mm/page-writeback.c | 53 +++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ca9c8b27cecb..c901d7313374 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -23,6 +23,7 @@
 #include <linux/page_ext.h>
 #include <linux/err.h>
 #include <linux/page_ref.h>
+#include <linux/errseq.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -2200,6 +2201,7 @@ extern int filemap_page_mkwrite(struct vm_fault *vmf);
 
 /* mm/page-writeback.c */
 int __must_check write_one_page(struct page *page);
+int __must_check write_one_page_since(struct page *page, errseq_t since);
 void task_dirty_inc(struct task_struct *tsk);
 
 /* readahead.c */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e369e8ea2a29..63058e35c60d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2365,19 +2365,10 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	return ret;
 }
 
-/**
- * write_one_page - write out a single page and wait on I/O
- * @page: the page to write
- *
- * The page must be locked by the caller and will be unlocked upon return.
- *
- * Note that the mapping's AS_EIO/AS_ENOSPC flags will be cleared when this
- * function returns.
- */
-int write_one_page(struct page *page)
+static int __write_one_page(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	int ret = 0, ret2;
+	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL,
 		.nr_to_write = 1,
@@ -2394,16 +2385,54 @@ int write_one_page(struct page *page)
 			wait_on_page_writeback(page);
 		put_page(page);
 	} else {
+		ret = 0;
 		unlock_page(page);
 	}
+	return ret;
+}
 
+/**
+ * write_one_page - write out a single page and wait on I/O
+ * @page: the page to write
+ *
+ * The page must be locked by the caller and will be unlocked upon return.
+ *
+ * Note that the mapping's AS_EIO/AS_ENOSPC flags will be cleared when this
+ * function returns.
+ */
+int write_one_page(struct page *page)
+{
+	int ret;
+
+	ret = __write_one_page(page);
 	if (!ret)
-		ret = filemap_check_errors(mapping);
+		ret = filemap_check_errors(page->mapping);
 	return ret;
 }
 EXPORT_SYMBOL(write_one_page);
 
 /*
+ * write_one_page_since - write out a single page and wait on I/O
+ * @page: the page to write
+ * @since: previously sampled errseq_t
+ *
+ * The page must be locked by the caller and will be unlocked upon return.
+ *
+ * The caller should pass in a previously-sampled errseq_t. The mapping will
+ * be checked for errors since that point.
+ */
+int write_one_page_since(struct page *page, errseq_t since)
+{
+	int ret;
+
+	ret = __write_one_page(page);
+	if (!ret)
+		ret = filemap_check_wb_err(page->mapping, since);
+	return ret;
+}
+EXPORT_SYMBOL(write_one_page_since);
+
+/*
  * For address_spaces which do not use buffers nor write back.
  */
 int __set_page_dirty_no_writeback(struct page *page)
-- 
2.9.4
