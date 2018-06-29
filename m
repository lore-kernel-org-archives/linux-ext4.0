From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] iomap: Add inline data support to
	iomap_readpage_actor
Date: Fri, 29 Jun 2018 16:44:44 +0200
Message-ID: <20180629144444.28826-1-agruenba@redhat.com>
References: <20180615130209.1970-2-hch@lst.de>
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180615130209.1970-2-hch@lst.de>
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

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 4f10c6b..d393bb0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -155,6 +155,12 @@ struct iomap_readpage_ctx {
 	bool is_contig = false;
 	sector_t sector;
 
+	if (iomap->type == IOMAP_INLINE) {
+		iomap_read_inline_data(inode, page, iomap);
+		plen = PAGE_SIZE - poff;
+		goto done;
+	}
+
 	/* we don't support blocksize < PAGE_SIZE quite yet. */
 	WARN_ON_ONCE(pos != page_offset(page));
 	WARN_ON_ONCE(plen != PAGE_SIZE);
-- 
1.8.3.1
