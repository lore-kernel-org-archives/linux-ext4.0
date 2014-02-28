From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext3: Update outdated comment before ext3_ordered_writepage()
Date: Fri, 28 Feb 2014 09:40:31 +0100
Message-ID: <1393576831-29915-3-git-send-email-jack@suse.cz>
References: <1393576831-29915-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaB1Iki (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Feb 2014 03:40:38 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E80B175027
	for <linux-ext4@vger.kernel.org>; Fri, 28 Feb 2014 08:40:37 +0000 (UTC)
In-Reply-To: <1393576831-29915-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The comment is heavily outdated. The recursion into the filesystem isn't
possible because we use GFP_NOFS for our allocations, the issue about
block_write_full_page() dirtying tail page is long resolved as well
(that function doesn't dirty buffers at all), and finally we don't start
a transaction if all blocks are already allocated and mapped.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c | 47 ++++-------------------------------------------
 1 file changed, 4 insertions(+), 43 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2fef98abb207..4ecf88fb69a8 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1559,56 +1559,17 @@ static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
 }
 
 /*
- * Note that we always start a transaction even if we're not journalling
- * data.  This is to preserve ordering: any hole instantiation within
- * __block_write_full_page -> ext3_get_block() should be journalled
- * along with the data so we don't crash and then get metadata which
+ * Note that whenever we need to map blocks we start a transaction even if
+ * we're not journalling data.  This is to preserve ordering: any hole
+ * instantiation within __block_write_full_page -> ext3_get_block() should be
+ * journalled along with the data so we don't crash and then get metadata which
  * refers to old data.
  *
  * In all journalling modes block_write_full_page() will start the I/O.
  *
- * Problem:
- *
- *	ext3_writepage() -> kmalloc() -> __alloc_pages() -> page_launder() ->
- *		ext3_writepage()
- *
- * Similar for:
- *
- *	ext3_file_write() -> generic_file_write() -> __alloc_pages() -> ...
- *
- * Same applies to ext3_get_block().  We will deadlock on various things like
- * lock_journal and i_truncate_mutex.
- *
- * Setting PF_MEMALLOC here doesn't work - too many internal memory
- * allocations fail.
- *
- * 16May01: If we're reentered then journal_current_handle() will be
- *	    non-zero. We simply *return*.
- *
- * 1 July 2001: @@@ FIXME:
- *   In journalled data mode, a data buffer may be metadata against the
- *   current transaction.  But the same file is part of a shared mapping
- *   and someone does a writepage() on it.
- *
- *   We will move the buffer onto the async_data list, but *after* it has
- *   been dirtied. So there's a small window where we have dirty data on
- *   BJ_Metadata.
- *
- *   Note that this only applies to the last partial page in the file.  The
- *   bit which block_write_full_page() uses prepare/commit for.  (That's
- *   broken code anyway: it's wrong for msync()).
- *
- *   It's a rare case: affects the final partial page, for journalled data
- *   where the file is subject to bith write() and writepage() in the same
- *   transction.  To fix it we'll need a custom block_write_full_page().
- *   We'll probably need that anyway for journalling writepage() output.
- *
  * We don't honour synchronous mounts for writepage().  That would be
  * disastrous.  Any write() or metadata operation will sync the fs for
  * us.
- *
- * AKPM2: if all the page's buffers are mapped to disk and !data=journal,
- * we don't need to open a transaction here.
  */
 static int ext3_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
-- 
1.8.1.4

