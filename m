From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] iomap: mark newly allocated buffer
	heads as new
Date: Thu, 14 Jun 2018 14:04:54 +0200
Message-ID: <20180614120457.28285-4-hch@lst.de>
References: <20180614120457.28285-1-hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
	Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180614120457.28285-1-hch@lst.de>
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

In iomap_to_bh, not only mark buffer heads in IOMAP_UNWRITTEN maps as
new, but also buffer heads in IOMAP_MAPPED maps with the IOMAP_F_NEW
flag set.  This will be used by filesystems like gfs2, which allocate
blocks in iomap->begin.

Minor corrections to the comment for IOMAP_UNWRITTEN maps.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/buffer.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index aba2a948b235..c8c2b7d8b8d6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1900,15 +1900,16 @@ iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
 		break;
 	case IOMAP_UNWRITTEN:
 		/*
-		 * For unwritten regions, we always need to ensure that
-		 * sub-block writes cause the regions in the block we are not
-		 * writing to are zeroed. Set the buffer as new to ensure this.
+		 * For unwritten regions, we always need to ensure that regions
+		 * in the block we are not writing to are zeroed. Mark the
+		 * buffer as new to ensure this.
 		 */
 		set_buffer_new(bh);
 		set_buffer_unwritten(bh);
 		/* FALLTHRU */
 	case IOMAP_MAPPED:
-		if (offset >= i_size_read(inode))
+		if ((iomap->flags & IOMAP_F_NEW) ||
+		    offset >= i_size_read(inode))
 			set_buffer_new(bh);
 		bh->b_blocknr = (iomap->addr + offset - iomap->offset) >>
 				inode->i_blkbits;
-- 
2.17.1
