From: Adrian Bunk <bunk@stusta.de>
Subject: [RFC: 2.6.16 patch] jbd: journal_dirty_data re-check for unmapped buffers
Date: Wed, 4 Apr 2007 05:41:42 +0200
Message-ID: <20070404034142.GA27660@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42186 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030380AbXDDDlo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Apr 2007 23:41:44 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch also seems to make sense for 2.6.16, or do I miss anything?

TIA
Adrian


commit f58a74dca88d48b0669609b4957f3dd757bdc898
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sat Oct 28 10:38:27 2006 -0700

    [PATCH] jbd: journal_dirty_data re-check for unmapped buffers
    
    When running several fsx's and other filesystem stress tests, we found
    cases where an unmapped buffer was still being sent to submit_bh by the
    ext3 dirty data journaling code.
    
    I saw this happen in two ways, both related to another thread doing a
    truncate which would unmap the buffer in question.
    
    Either we would get into journal_dirty_data with a bh which was already
    unmapped (although journal_dirty_data_fn had checked for this earlier, the
    state was not locked at that point), or it would get unmapped in the middle
    of journal_dirty_data when we dropped locks to call sync_dirty_buffer.
    
    By re-checking for mapped state after we've acquired the bh state lock, we
    should avoid these races.  If we find a buffer which is no longer mapped,
    we essentially ignore it, because journal_unmap_buffer has already decided
    that this buffer can go away.
    
    I've also added tracepoints in these two cases, and made a couple other
    tracepoint changes that I found useful in debugging this.
    
    Signed-off-by: Eric Sandeen <esandeen@redhat.com>
    Cc: <linux-ext4@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index d5c6304..4f82bcd 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -967,6 +967,13 @@ int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 	 */
 	jbd_lock_bh_state(bh);
 	spin_lock(&journal->j_list_lock);
+
+	/* Now that we have bh_state locked, are we really still mapped? */
+	if (!buffer_mapped(bh)) {
+		JBUFFER_TRACE(jh, "unmapped buffer, bailing out");
+		goto no_journal;
+	}
+
 	if (jh->b_transaction) {
 		JBUFFER_TRACE(jh, "has transaction");
 		if (jh->b_transaction != handle->h_transaction) {
@@ -1028,6 +1035,11 @@ int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 				sync_dirty_buffer(bh);
 				jbd_lock_bh_state(bh);
 				spin_lock(&journal->j_list_lock);
+				/* Since we dropped the lock... */
+				if (!buffer_mapped(bh)) {
+					JBUFFER_TRACE(jh, "buffer got unmapped");
+					goto no_journal;
+				}
 				/* The buffer may become locked again at any
 				   time if it is redirtied */
 			}
@@ -1824,6 +1836,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 			}
 		}
 	} else if (transaction == journal->j_committing_transaction) {
+		JBUFFER_TRACE(jh, "on committing transaction");
 		if (jh->b_jlist == BJ_Locked) {
 			/*
 			 * The buffer is on the committing transaction's locked
@@ -1838,7 +1851,6 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 		 * can remove it's next_transaction pointer from the
 		 * running transaction if that is set, but nothing
 		 * else. */
-		JBUFFER_TRACE(jh, "on committing transaction");
 		set_buffer_freed(bh);
 		if (jh->b_next_transaction) {
 			J_ASSERT(jh->b_next_transaction ==
@@ -1858,6 +1870,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 		 * i_size already for this truncate so recovery will not
 		 * expose the disk blocks we are discarding here.) */
 		J_ASSERT_JH(jh, transaction == journal->j_running_transaction);
+		JBUFFER_TRACE(jh, "on running transaction");
 		may_free = __dispose_buffer(jh, transaction);
 	}
 
