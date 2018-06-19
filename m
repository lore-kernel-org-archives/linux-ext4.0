From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] iomap: add private pointer to struct
	iomap
Date: Tue, 19 Jun 2018 18:41:36 +0200
Message-ID: <20180619164137.13720-7-hch@lst.de>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

Add a private pointer to struct iomap to allow filesystems to pass data
from iomap_begin to iomap_end.  Will be used by gfs2 for passing on the
on-disk inode buffer head.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/iomap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 45f43865b0f0..1f36523d448a 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -57,6 +57,7 @@ struct iomap {
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
+	void			*private; /* filesystem private */
 
 	/*
 	 * Called when finished processing a page in the mapping returned in
-- 
2.17.1
