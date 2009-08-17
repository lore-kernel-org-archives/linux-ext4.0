From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] ext3: Fix possible deadlock between
	ext3_truncate() and ext3_get_blocks()
Date: Mon, 17 Aug 2009 16:45:24 +0200
Message-ID: <20090817144524.GA1611@duck.novell.com>
References: <1250252772-13302-1-git-send-email-jack@suse.cz> <1250252772-13302-3-git-send-email-jack@suse.cz> <20090814164105.9923f8f8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZHQOpZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 10:45:25 -0400
Content-Disposition: inline
In-Reply-To: <20090814164105.9923f8f8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 14-08-09 16:41:05, Andrew Morton wrote:
> On Fri, 14 Aug 2009 14:26:10 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > During truncate we are sometimes forced to start a new transaction as the
> > amount of blocks to be journaled is both quite large and hard to predict. So
> > far we restarted a transaction while holding truncate_mutex and that violates
> > lock ordering because truncate_mutex ranks below transaction start (and it
> > can lead to a real deadlock with ext3_get_blocks() allocating new blocks
> > from ext3_writepage()).
> > 
> > Luckily, the problem is easy to fix: We just drop the truncate_mutex before
> > restarting the transaction and acquire it afterwards. We are safe to do this as
> > by the time ext3_truncate() is called, all the page cache for the truncated
> > part of the file is dropped and so writepage() cannot come and allocate new
> > blocks in the part of the file we are truncating. The rest of writers is
> > stopped by us holding i_mutex.
> 
> For ext2 we have the comment:
> 
> 	/*
> 	 * truncate_mutex is for serialising ext2_truncate() against
> 	 * ext2_getblock().  It also protects the internals of the inode's
> 	 * reservation data structures: ext2_reserve_window and
> 	 * ext2_reserve_window_node.
> 	 */
> 
> does truncate_mutex also protect ext3's reservation data?  If so, is
> that impacted by this patch?
  That's a good question: ext3 seems to use truncate_mutex to guard
reservation internals as well. Currently, truncate calls
ext3_discard_reservation() in the end of truncate. That is slightly
suboptimal when we can drop truncate_mutex during truncate as that can lead
to allocation from reservation window which is not well placed wrt the new
file end. Otherwise I don't think there's any issue since reservation is
just an interval of blocks we'd like to allocate from so it's not bound to
blocks allocated to the inode in any way.
  I'll move ext3_discard_reservation() to the beginning of the truncate
to fix the above issue. Thanks for the comment. Attached is a new version
of the patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--x+6KMIRAuhnl3hBn
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Fix-possible-deadlock-between-ext3_truncate.patch"

>From fad69f21486f4b2d78444acc321803bdb571e9d7 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 11 Aug 2009 19:06:10 +0200
Subject: [PATCH] ext3: Fix possible deadlock between ext3_truncate() and ext3_get_blocks()

During truncate we are sometimes forced to start a new transaction as the
amount of blocks to be journaled is both quite large and hard to predict. So
far we restarted a transaction while holding truncate_mutex and that violates
lock ordering because truncate_mutex ranks below transaction start (and it
can lead to a real deadlock with ext3_get_blocks() allocating new blocks
from ext3_writepage()).

Luckily, the problem is easy to fix: We just drop the truncate_mutex before
restarting the transaction and acquire it afterwards. We are safe to do this as
by the time ext3_truncate() is called, all the page cache for the truncated
part of the file is dropped and so writepage() cannot come and allocate new
blocks in the part of the file we are truncating. The rest of writers is
stopped by us holding i_mutex. We also move discarding of a reservation window
to the beginning of truncate so that we don't use it when an allocation happens
while we have dropped truncate_mutex during the truncate.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index b49908a..f591e58 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -172,10 +172,21 @@ static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
  * so before we call here everything must be consistently dirtied against
  * this transaction.
  */
-static int ext3_journal_test_restart(handle_t *handle, struct inode *inode)
+static int truncate_restart_transaction(handle_t *handle, struct inode *inode)
 {
+	int ret;
+
 	jbd_debug(2, "restarting handle %p\n", handle);
-	return ext3_journal_restart(handle, blocks_for_truncate(inode));
+	/*
+	 * Drop truncate_mutex to avoid deadlock with ext3_get_blocks_handle
+	 * At this moment, get_block can be called only for blocks inside
+	 * i_size since page cache has been already dropped and writes are
+	 * blocked by i_mutex. So we can safely drop the truncate_mutex.
+	 */
+	mutex_unlock(&EXT3_I(inode)->truncate_mutex);
+	ret = ext3_journal_restart(handle, blocks_for_truncate(inode));
+	mutex_lock(&EXT3_I(inode)->truncate_mutex);
+	return ret;
 }
 
 /*
@@ -2072,7 +2083,7 @@ static void ext3_clear_blocks(handle_t *handle, struct inode *inode,
 			ext3_journal_dirty_metadata(handle, bh);
 		}
 		ext3_mark_inode_dirty(handle, inode);
-		ext3_journal_test_restart(handle, inode);
+		truncate_restart_transaction(handle, inode);
 		if (bh) {
 			BUFFER_TRACE(bh, "retaking write access");
 			ext3_journal_get_write_access(handle, bh);
@@ -2282,7 +2293,7 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
 				return;
 			if (try_to_extend_transaction(handle, inode)) {
 				ext3_mark_inode_dirty(handle, inode);
-				ext3_journal_test_restart(handle, inode);
+				truncate_restart_transaction(handle, inode);
 			}
 
 			ext3_free_blocks(handle, inode, nr, 1);
@@ -2435,6 +2446,8 @@ void ext3_truncate(struct inode *inode)
 	 */
 	mutex_lock(&ei->truncate_mutex);
 
+	ext3_discard_reservation(inode);
+
 	if (n == 1) {		/* direct blocks */
 		ext3_free_data(handle, inode, NULL, i_data+offsets[0],
 			       i_data + EXT3_NDIR_BLOCKS);
@@ -2495,8 +2508,6 @@ do_indirects:
 		;
 	}
 
-	ext3_discard_reservation(inode);
--x+6KMIRAuhnl3hBn--
