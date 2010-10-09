From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] vfs: Unmap underlying metadata of new data buffers only when buffer is mapped
Date: Sat,  9 Oct 2010 02:12:25 +0200
Message-ID: <1286583147-14760-2-git-send-email-jack@suse.cz>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42339 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759948Ab0JIANm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Oct 2010 20:13:42 -0400
In-Reply-To: <1286583147-14760-1-git-send-email-jack@suse.cz>
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
index 3e7dca2..0f2ba29 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1688,8 +1688,9 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
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
@@ -1875,8 +1876,9 @@ int block_prepare_write(struct page *page, unsigned from, unsigned to,
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
@@ -2514,7 +2516,7 @@ int nobh_write_begin(struct address_space *mapping,
 			goto failed;
 		if (!buffer_mapped(bh))
 			is_mapped_to_disk = 0;
-		if (buffer_new(bh))
+		if (buffer_new(bh) && buffer_mapped(bh))
 			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
 		if (PageUptodate(page)) {
 			set_buffer_uptodate(bh);
-- 
1.6.4.2

