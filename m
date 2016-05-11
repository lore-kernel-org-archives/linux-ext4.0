From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/7] dax: Remove zeroing from dax_io()
Date: Wed, 11 May 2016 11:58:51 +0200
Message-ID: <1462960733-29634-6-git-send-email-jack@suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-nvdimm@lists.01.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbcEKJ7Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2016 05:59:24 -0400
In-Reply-To: <1462960733-29634-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All the filesystems are now zeroing blocks themselves for DAX IO to avoid
races between dax_io() and dax_fault(). Remove the zeroing code from
dax_io() and add warning to catch the case when somebody unexpectedly
returns new or unwritten buffer.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ccb8bc399d78..7c0036dd1570 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -119,18 +119,6 @@ int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size)
 }
 EXPORT_SYMBOL_GPL(dax_clear_sectors);
 
-/* the clear_pmem() calls are ordered by a wmb_pmem() in the caller */
-static void dax_new_buf(void __pmem *addr, unsigned size, unsigned first,
-		loff_t pos, loff_t end)
-{
-	loff_t final = end - pos + first; /* The final byte of the buffer */
-
-	if (first > 0)
-		clear_pmem(addr, first);
-	if (final < size)
-		clear_pmem(addr + final, size - final);
-}
-
 static bool buffer_written(struct buffer_head *bh)
 {
 	return buffer_mapped(bh) && !buffer_unwritten(bh);
@@ -169,6 +157,9 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 	struct blk_dax_ctl dax = {
 		.addr = (void __pmem *) ERR_PTR(-EIO),
 	};
+	unsigned blkbits = inode->i_blkbits;
+	sector_t file_blks = (i_size_read(inode) + (1 << blkbits) - 1)
+								>> blkbits;
 
 	if (rw == READ)
 		end = min(end, i_size_read(inode));
@@ -176,7 +167,6 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 	while (pos < end) {
 		size_t len;
 		if (pos == max) {
-			unsigned blkbits = inode->i_blkbits;
 			long page = pos >> PAGE_SHIFT;
 			sector_t block = page << (PAGE_SHIFT - blkbits);
 			unsigned first = pos - (block << blkbits);
@@ -192,6 +182,13 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 					bh->b_size = 1 << blkbits;
 				bh_max = pos - first + bh->b_size;
 				bdev = bh->b_bdev;
+				/*
+				 * We allow uninitialized buffers for writes
+				 * beyond EOF as those cannot race with faults
+				 */
+				WARN_ON_ONCE(
+					(buffer_new(bh) && block < file_blks) ||
+					(rw == WRITE && buffer_unwritten(bh)));
 			} else {
 				unsigned done = bh->b_size -
 						(bh_max - (pos - first));
@@ -211,11 +208,6 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 					rc = map_len;
 					break;
 				}
-				if (buffer_unwritten(bh) || buffer_new(bh)) {
-					dax_new_buf(dax.addr, map_len, first,
-							pos, end);
-					need_wmb = true;
-				}
 				dax.addr += first;
 				size = map_len - first;
 			}
-- 
2.6.6

