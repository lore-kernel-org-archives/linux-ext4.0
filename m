From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 3/6] dax: Avoid page invalidation races and unnecessary radix
 tree traversals
Date: Thu, 24 Nov 2016 10:46:33 +0100
Message-ID: <1479980796-26161-4-git-send-email-jack@suse.cz>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1479980796-26161-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

Currently each filesystem (possibly through generic_file_direct_write()
or iomap_dax_rw()) takes care of invalidating page tables and evicting
hole pages from the radix tree when write(2) to the file happens. This
invalidation is only necessary when there is some block allocation
resulting from write(2). Furthermore in current place the invalidation
is racy wrt page fault instantiating a hole page just after we have
invalidated it.

So perform the page invalidation inside dax_do_io() where we can do it
only when really necessary and after blocks have been allocated so
nobody will be instantiating new hole pages anymore.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4534f0e232e9..ddf77ef2ca18 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -984,6 +984,17 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
 		return -EIO;
 
+	/*
+	 * Write can allocate block for an area which has a hole page mapped
+	 * into page tables. We have to tear down these mappings so that data
+	 * written by write(2) is visible in mmap.
+	 */
+	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
+		invalidate_inode_pages2_range(inode->i_mapping,
+					      pos >> PAGE_SHIFT,
+					      (end - 1) >> PAGE_SHIFT);
+	}
+
 	while (pos < end) {
 		unsigned offset = pos & (PAGE_SIZE - 1);
 		struct blk_dax_ctl dax = { 0 };
@@ -1042,23 +1053,6 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == WRITE)
 		flags |= IOMAP_WRITE;
 
-	/*
-	 * Yes, even DAX files can have page cache attached to them:  A zeroed
-	 * page is inserted into the pagecache when we have to serve a write
-	 * fault on a hole.  It should never be dirtied and can simply be
-	 * dropped from the pagecache once we get real data for the page.
-	 *
-	 * XXX: This is racy against mmap, and there's nothing we can do about
-	 * it. We'll eventually need to shift this down even further so that
-	 * we can check if we allocated blocks over a hole first.
-	 */
-	if (mapping->nrpages) {
-		ret = invalidate_inode_pages2_range(mapping,
-				pos >> PAGE_SHIFT,
-				(pos + iov_iter_count(iter) - 1) >> PAGE_SHIFT);
-		WARN_ON_ONCE(ret);
-	}
-
 	while (iov_iter_count(iter)) {
 		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
 				iter, dax_iomap_actor);
-- 
2.6.6
