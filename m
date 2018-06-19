From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] iomap: add a page_done callback
Date: Tue, 19 Jun 2018 18:41:35 +0200
Message-ID: <20180619164137.13720-6-hch@lst.de>
References: <20180619164137.13720-1-hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
	Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180619164137.13720-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

This will be used by gfs2 to attach data to transactions for the journaled
data mode.  But the concept is generic enough that we might be able to
use it for other purposes like encryption/integrity post-processing in the
future.

Based on a patch from Andreas Gruenbacher.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            | 3 +++
 include/linux/iomap.h | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 4aecd7c5dbd8..a1f71e64ea49 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -201,6 +201,9 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
 				copied, page, NULL);
 	}
 
+	if (iomap->page_done)
+		iomap->page_done(inode, pos, copied, page, iomap);
+
 	if (ret < len)
 		iomap_write_failed(inode, pos, len);
 	return ret;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 10d6cff7f69a..45f43865b0f0 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -9,6 +9,7 @@ struct fiemap_extent_info;
 struct inode;
 struct iov_iter;
 struct kiocb;
+struct page;
 struct vm_area_struct;
 struct vm_fault;
 
@@ -56,6 +57,14 @@ struct iomap {
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
+
+	/*
+	 * Called when finished processing a page in the mapping returned in
+	 * this iomap.  At least for now this is only supported in the buffered
+	 * write path.
+	 */
+	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
+			struct page *page, struct iomap *iomap);
 };
 
 /*
-- 
2.17.1
