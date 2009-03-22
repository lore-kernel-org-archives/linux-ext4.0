From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC 1/2] block_write_full_page: Use synchronous writes for WBC_SYNC_ALL writebacks
Date: Sat, 21 Mar 2009 21:12:09 -0400
Message-ID: <1237684330-11770-2-git-send-email-tytso@mit.edu>
References: <1237684330-11770-1-git-send-email-tytso@mit.edu>
Cc: akpm@linux-foundation.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35244 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZCVBMS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Mar 2009 21:12:18 -0400
In-Reply-To: <1237684330-11770-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When doing synchronous writes because wbc->sync_mode is set to
WBC_SYNC_ALL, send the write request using WRITE_SYNC, so that we
don't unduly block system calls such as fsync().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/buffer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 3cc3a7d..4ea1bbb 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1755,6 +1755,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	struct buffer_head *bh, *head;
 	const unsigned blocksize = 1 << inode->i_blkbits;
 	int nr_underway = 0;
+	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
 
 	BUG_ON(!PageLocked(page));
 
@@ -1846,7 +1847,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(WRITE, bh);
+			submit_bh(write_op, bh);
 			nr_underway++;
 		}
 		bh = next;
@@ -1900,7 +1901,7 @@ recover:
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh(WRITE, bh);
+			submit_bh(write_op, bh);
 			nr_underway++;
 		}
 		bh = next;
-- 
1.5.6.3

