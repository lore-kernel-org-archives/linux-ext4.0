From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC] Use WRITE_SYNC in __block_write_full_page() if WBC_SYNC_ALL
Date: Sun, 04 Jan 2009 16:52:46 -0500
Message-ID: <E1LJatq-00061O-0e@closure.thunk.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@osdl.org>, linux-mm@vger.kernel.org,
	linux-ext4@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57185 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZADVwu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Jan 2009 16:52:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


If wbc.sync_mode is WBC_SYNC_ALL, then in the page writeback paths we
will be waiting for the write to complete.  So the I/O should be
submitted via submit_bh() with WRITE_SYNC so the block layer should
properly prioritize the I/O.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-mm@vger.kernel.org
---

Following up with an e-mail thread started by Arjan two months ago,
(subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority), I have
a patch, just sent to linux-ext4@vger.kernel.org, which fixes the jbd2
layer to submit journal writes via submit_bh() with WRITE_SYNC.
Hopefully this might be enough of a priority boost so we don't have to
force a higher I/O priority level via a buffer_head flag.  However,
while looking through the code paths, in ordered data mode, we end up
flushing data pages via the page writeback paths on a per-inode basis,
and I noticed that even though we are passing in
wbc.sync_mode=WBC_SYNC_ALL, __block_write_full_page() is using
submit_bh(WRITE, bh) instead of submit_bh(WRITE_SYNC).

I'm not completely confident in my understanding of the page writeback
code paths --- does this change make sense?

					- Ted

 fs/buffer.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 10179cf..392b1b3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1741,7 +1741,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(WRITE, bh);
+			submit_bh((wbc->sync_mode == WB_SYNC_ALL) ?
+				  WRITE_SYNC : WRITE, bh);
 			nr_underway++;
 		}
 		bh = next;
@@ -1795,7 +1796,8 @@ recover:
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh(WRITE, bh);
+			submit_bh((wbc->sync_mode == WB_SYNC_ALL) ?
+				  WRITE_SYNC : WRITE, bh);
 			nr_underway++;
 		}
 		bh = next;
-- 
1.6.0.4.8.g36f27.dirty

