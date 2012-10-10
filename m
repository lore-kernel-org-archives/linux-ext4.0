From: zwu.kernel@gmail.com
Subject: [RFC v3 06/13] vfs: add hooks to enable hot data tracking
Date: Wed, 10 Oct 2012 18:07:28 +0800
Message-ID: <1349863655-29320-7-git-send-email-zwu.kernel@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:42841 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2JJKIv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2012 06:08:51 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Wed, 10 Oct 2012 04:08:50 -0600
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Miscellaneous features that implement hot data tracking
and generally make the hot data functions a bit more friendly.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/direct-io.c      |    8 ++++++++
 fs/hot_tracking.h   |    5 +++++
 mm/filemap.c        |    7 +++++++
 mm/page-writeback.c |   13 +++++++++++++
 mm/readahead.c      |    7 +++++++
 5 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index f86c720..8960024 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -37,6 +37,7 @@
 #include <linux/uio.h>
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
+#include "hot_tracking.h"
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
@@ -1297,6 +1298,13 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
+	/* Hot data tracking */
+	hot_update_freqs(global_hot_tracking_info,
+			iocb->ki_filp->f_mapping->host,
+			(u64)offset,
+			(u64)iov_length(iov, nr_segs),
+			rw & WRITE);
+
 	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
 				     nr_segs, get_block, end_io,
 				     submit_io, flags);
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 37f69ee..42e0273 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -16,6 +16,11 @@
 #include <linux/workqueue.h>
 #include <linux/hot_tracking.h>
 
+/* Hot data tracking -- guard macros */
+#define TRACK_THIS_INODE(inode) \
+                ((inode->i_sb->hot_flags & MS_HOT_TRACKING) && \
+                !(inode->i_flags & S_NOHOTDATATRACK))
+
 /* values for hot_freq_data flags */
 #define FREQ_DATA_TYPE_INODE (1 << 0)
 #define FREQ_DATA_TYPE_RANGE (1 << 1)
diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..6b63b77 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
+#include <linux/hot_tracking.h>
 #include "internal.h"
 
 /*
@@ -1224,6 +1225,12 @@ readpage:
 		 * PG_error will be set again if readpage fails.
 		 */
 		ClearPageError(page);
+
+		/* Hot data tracking */
+		hot_update_freqs(global_hot_tracking_info, inode,
+				(u64)page->index << PAGE_CACHE_SHIFT,
+				PAGE_CACHE_SIZE, 0);
+
 		/* Start the actual read. The read will unlock the page. */
 		error = mapping->a_ops->readpage(filp, page);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5ad5ce2..cf5a1c8 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h> /* __set_page_dirty_buffers */
 #include <linux/pagevec.h>
 #include <linux/timer.h>
+#include <linux/hot_tracking.h>
 #include <trace/events/writeback.h>
 
 /*
@@ -1895,13 +1896,25 @@ EXPORT_SYMBOL(generic_writepages);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
+	pgoff_t start = 0;
+	u64 count = 0;
 
 	if (wbc->nr_to_write <= 0)
 		return 0;
+
+	start = mapping->writeback_index << PAGE_CACHE_SHIFT;
+	count = (u64)wbc->nr_to_write;
+
 	if (mapping->a_ops->writepages)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
+
+	/* Hot data tracking */
+	hot_update_freqs(global_hot_tracking_info,
+			mapping->host, (u64)start,
+			(count - (u64)wbc->nr_to_write) * PAGE_CACHE_SIZE, 1);
+
 	return ret;
 }
 
diff --git a/mm/readahead.c b/mm/readahead.c
index 7963f23..b62f1bb 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
+#include <linux/hot_tracking.h>
 
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
@@ -138,6 +139,12 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 out:
 	blk_finish_plug(&plug);
 
+	/* Hot data tracking */
+	hot_update_freqs(global_hot_tracking_info,
+			mapping->host, (u64)(list_entry(pages->prev,\
+				struct page, lru)->index) << PAGE_CACHE_SHIFT,
+			(u64)nr_pages * PAGE_CACHE_SIZE, 0);
+
 	return ret;
 }
 
-- 
1.7.6.5

