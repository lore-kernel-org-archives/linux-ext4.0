From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] ext4: remove unnecessary call to waitqueue_active()
Date: Mon, 31 Oct 2011 11:02:46 -0400
Message-ID: <1320073367-28916-2-git-send-email-tytso@mit.edu>
References: <20111031150206.GC16825@thunk.org>
 <1320073367-28916-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37935 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061Ab1JaPCt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 11:02:49 -0400
In-Reply-To: <1320073367-28916-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The usage of waitqueue_active() is not necessary, and introduces (I
believe) a hard-to-hit race.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/page-io.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index aed4096..4fa1d70 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -70,7 +70,6 @@ static void put_io_page(struct ext4_io_page *io_page)
 void ext4_free_io_end(ext4_io_end_t *io)
 {
 	int i;
-	wait_queue_head_t *wq;
 
 	BUG_ON(!io);
 	if (io->page)
@@ -78,10 +77,8 @@ void ext4_free_io_end(ext4_io_end_t *io)
 	for (i = 0; i < io->num_io_pages; i++)
 		put_io_page(io->pages[i]);
 	io->num_io_pages = 0;
-	wq = ext4_ioend_wq(io->inode);
-	if (atomic_dec_and_test(&EXT4_I(io->inode)->i_ioend_count) &&
-	    waitqueue_active(wq))
-		wake_up_all(wq);
+	if (atomic_dec_and_test(&EXT4_I(io->inode)->i_ioend_count))
+		wake_up_all(ext4_ioend_wq(io->inode));
 	kmem_cache_free(io_end_cachep, io);
 }
 
@@ -96,7 +93,6 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 	struct inode *inode = io->inode;
 	loff_t offset = io->offset;
 	ssize_t size = io->size;
-	wait_queue_head_t *wq;
 	int ret = 0;
 
 	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
@@ -121,11 +117,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 	if (io->flag & EXT4_IO_END_UNWRITTEN) {
 		io->flag &= ~EXT4_IO_END_UNWRITTEN;
 		/* Wake up anyone waiting on unwritten extent conversion */
-		wq = ext4_ioend_wq(io->inode);
-		if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten) &&
-		    waitqueue_active(wq)) {
-			wake_up_all(wq);
-		}
+		if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
+			wake_up_all(ext4_ioend_wq(io->inode));
 	}
 
 	return ret;
-- 
1.7.4.1.22.gec8e1.dirty

