From: zwu.kernel@gmail.com
Subject: [RFC v2 06/10] vfs: enable hot data tracking
Date: Sun, 23 Sep 2012 20:56:31 +0800
Message-ID: <1348404995-14372-7-git-send-email-zwu.kernel@gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
	marco.stornelli@gmail.com, david@fromorbit.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Miscellaneous features that implement hot data tracking
and generally make the hot data functions a bit more friendly.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/direct-io.c               |   10 ++++++++++
 include/linux/hot_tracking.h |   11 +++++++++++
 mm/filemap.c                 |    8 ++++++++
 mm/page-writeback.c          |   21 +++++++++++++++++++++
 mm/readahead.c               |    9 +++++++++
 5 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index f86c720..3773f44 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -37,6 +37,7 @@
 #include <linux/uio.h>
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
+#include "hot_tracking.h"
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
@@ -1297,6 +1298,15 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
+	/* Hot data tracking */
+	if (TRACK_THIS_INODE(iocb->ki_filp->f_mapping->host)
+			&& iov_length(iov, nr_segs) > 0) {
+		hot_rb_update_freqs(iocb->ki_filp->f_mapping->host,
+				(u64)offset,
+				(u64)iov_length(iov, nr_segs),
+				rw & WRITE);
+	}
+
 	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
 				     nr_segs, get_block, end_io,
 				     submit_io, flags);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 635ffb6..bc41f94 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -28,6 +28,14 @@
  */
 #define HOT_MOUNT_HOT_TRACK		(1 << 0)
 
+/* Hot data tracking -- guard macros */
+#define TRACKING_HOT_TRACK(root) \
+		(root->s_hotinfo.mount_opt & HOT_MOUNT_HOT_TRACK)
+
+#define TRACK_THIS_INODE(inode) \
+		((TRACKING_HOT_TRACK(inode->i_sb)) && \
+		!(inode->i_flags & S_NOHOTDATATRACK))
+
 /* A tree that sits on the hot_info */
 struct hot_inode_tree {
 	struct rb_root map;
@@ -135,4 +143,7 @@ struct hot_info {
 	struct hot_hash_head heat_range_hl[HEAT_HASH_SIZE];
 };
 
+extern void hot_rb_update_freqs(struct inode *inode,
+				u64 start, u64 len, int rw);
+
 #endif  /* _LINUX_HOTTRACK_H */
diff --git a/mm/filemap.c b/mm/filemap.c
index 3843445..8b1ecff 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
+#include <linux/hot_tracking.h>
 #include "internal.h"
 
 /*
@@ -1224,6 +1225,13 @@ readpage:
 		 * PG_error will be set again if readpage fails.
 		 */
 		ClearPageError(page);
+
+		/* Hot data tracking */
+		if (TRACK_THIS_INODE(filp->f_mapping->host))
+			hot_rb_update_freqs(filp->f_mapping->host,
+				(u64)page->index << PAGE_CACHE_SHIFT,
+				PAGE_CACHE_SIZE, 0);
+
 		/* Start the actual read. The read will unlock the page. */
 		error = mapping->a_ops->readpage(filp, page);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5ad5ce2..552c861 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h> /* __set_page_dirty_buffers */
 #include <linux/pagevec.h>
 #include <linux/timer.h>
+#include <linux/hot_tracking.h>
 #include <trace/events/writeback.h>
 
 /*
@@ -1895,13 +1896,33 @@ EXPORT_SYMBOL(generic_writepages);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
+	pgoff_t start = 0;
+	u64 prev_count = 0, count = 0;
 
 	if (wbc->nr_to_write <= 0)
 		return 0;
+
+	/* Hot data tracking */
+	if (TRACK_THIS_INODE(mapping->host)
+		&& wbc->range_cyclic) {
+		start = mapping->writeback_index << PAGE_CACHE_SHIFT;
+		prev_count = (u64)wbc->nr_to_write;
+	}
+
 	if (mapping->a_ops->writepages)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
+
+	/* Hot data tracking */
+	if (TRACK_THIS_INODE(mapping->host)
+		&& wbc->range_cyclic) {
+		count = prev_count - (u64)wbc->nr_to_write;
+		if (count)
+			hot_rb_update_freqs(mapping->host, (u64)start,
+					count * PAGE_CACHE_SIZE, 1);
+	}
+
 	return ret;
 }
 
diff --git a/mm/readahead.c b/mm/readahead.c
index ea8f8fa..7010fc4 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
+#include <linux/hot_tracking.h>
 
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
@@ -138,6 +139,14 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 out:
 	blk_finish_plug(&plug);
 
+	/* Hot data tracking */
+	if (TRACK_THIS_INODE(mapping->host) && nr_pages > 0) {
+		u64 start = (u64)(list_entry(pages->prev,
+				struct page, lru)->index) << PAGE_CACHE_SHIFT;
+		hot_rb_update_freqs(mapping->host, start,
+				(u64)nr_pages * PAGE_CACHE_SIZE, 0);
+	}
+
 	return ret;
 }
 
-- 
1.7.6.5
