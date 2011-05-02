From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] vfs: Unmap underlying metadata of new data buffers only when buffer is mapped
Date: Mon,  2 May 2011 22:56:53 +0200
Message-ID: <1304369816-14545-2-git-send-email-jack@suse.cz>
References: <1304369816-14545-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab1EBU5S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 16:57:18 -0400
In-Reply-To: <1304369816-14545-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we do delayed allocation of some buffer, we want to signal to VFS that
the buffer is new (set buffer_new) so that it properly zeros out everything.
But we don't have the buffer mapped yet so we cannot really unmap underlying
metadata in this state. Make VFS avoid doing unmapping of metadata when the
buffer is not yet mapped.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a08bb8e..9e6d67a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1673,8 +1673,9 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			if (buffer_new(bh)) {
 				/* blockdev mappings never come here */
 				clear_buffer_new(bh);
-				unmap_underlying_metadata(bh->b_bdev,
-							bh->b_blocknr);
+				if (buffer_mapped(bh))
+					unmap_underlying_metadata(bh->b_bdev,
+						bh->b_blocknr);
 			}
 		}
 		bh = bh->b_this_page;
@@ -1862,8 +1863,9 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 			if (err)
 				break;
 			if (buffer_new(bh)) {
-				unmap_underlying_metadata(bh->b_bdev,
-							bh->b_blocknr);
+				if (buffer_mapped(bh))
+					unmap_underlying_metadata(bh->b_bdev,
+						bh->b_blocknr);
 				if (PageUptodate(page)) {
 					clear_buffer_new(bh);
 					set_buffer_uptodate(bh);
@@ -2491,7 +2493,7 @@ int nobh_write_begin(struct address_space *mapping,
 			goto failed;
 		if (!buffer_mapped(bh))
 			is_mapped_to_disk = 0;
-		if (buffer_new(bh))
+		if (buffer_new(bh) && buffer_mapped(bh))
 			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
 		if (PageUptodate(page)) {
 			set_buffer_uptodate(bh);
-- 
1.7.1

