From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Fix deadlock in data=journal mode when fs is frozen
Date: Thu, 22 May 2014 17:25:39 +0200
Message-ID: <1400772339-24781-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbaEVPZq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2014 11:25:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1F0BCAC6E
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2014 15:25:45 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext3 is used in data=journal mode, syncing filesystem makes sure
all the data is committed in the journal but the data doesn't have to be
checkpointed. ext3_freeze() then takes care of checkpointing all the
data so all buffer heads are clean but pages can still have dangling
dirty bits. So when flusher thread comes later when filesystem is
frozen, it tries to write back dirty pages, ext3_journalled_writepage()
tries to start a transaction and hangs waiting for frozen fs causing a
deadlock because a holder of s_umount semaphore may be waiting for
flusher thread to complete.

The fix is luckily relatively easy. We don't have to start a transaction
in ext3_journalled_writepage() when a page is just dirty (and doesn't
have PageChecked set) because in that case all buffers should be already
mapped (mapping must happen before writing a buffer to the journal) and
it is enough to write them out. This optimization also solves the deadlock
because block_write_full_page() will just find out there's no buffer to
write and do nothing.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

  JFYI: I've added this patch to my tree.

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index f5157d0d1b43..695abe738a24 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1716,17 +1716,17 @@ static int ext3_journalled_writepage(struct page *page,
 	WARN_ON_ONCE(IS_RDONLY(inode) &&
 		     !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
-	if (ext3_journal_current_handle())
-		goto no_write;
-
 	trace_ext3_journalled_writepage(page);
-	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto no_write;
-	}
-
 	if (!page_has_buffers(page) || PageChecked(page)) {
+		if (ext3_journal_current_handle())
+			goto no_write;
+
+		handle = ext3_journal_start(inode,
+					    ext3_writepage_trans_blocks(inode));
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto no_write;
+		}
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.
@@ -1749,17 +1749,18 @@ static int ext3_journalled_writepage(struct page *page,
 		atomic_set(&EXT3_I(inode)->i_datasync_tid,
 			   handle->h_transaction->t_tid);
 		unlock_page(page);
+		err = ext3_journal_stop(handle);
+		if (!ret)
+			ret = err;
 	} else {
 		/*
-		 * It may be a page full of checkpoint-mode buffers.  We don't
-		 * really know unless we go poke around in the buffer_heads.
-		 * But block_write_full_page will do the right thing.
+		 * It is a page full of checkpoint-mode buffers. Go and write
+		 * them. They should have been already mapped when they went
+		 * to the journal so provide NULL get_block function to catch
+		 * errors.
 		 */
-		ret = block_write_full_page(page, ext3_get_block, wbc);
+		ret = block_write_full_page(page, NULL, wbc);
 	}
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
 out:
 	return ret;
 
-- 
1.8.1.4

