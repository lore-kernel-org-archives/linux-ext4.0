From: akpm@osdl.org
Subject: - jbd2-journal_dirty_data-re-check-for-unmapped-buffers.patch removed from -mm tree
Date: Sat, 28 Oct 2006 17:19:27 -0700
Message-ID: <200610290019.k9T0JRhC006821@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:21920 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964947AbWJ2ATm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Oct 2006 20:19:42 -0400
To: sandeen@sandeen.net, esandeen@redhat.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: journal_dirty_data re-check for unmapped buffers
has been removed from the -mm tree.  Its filename was
     jbd2-journal_dirty_data-re-check-for-unmapped-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jbd2: journal_dirty_data re-check for unmapped buffers
From: Eric Sandeen <sandeen@sandeen.net>

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
---

 fs/jbd2/transaction.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/jbd2/transaction.c~jbd2-journal_dirty_data-re-check-for-unmapped-buffers fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-journal_dirty_data-re-check-for-unmapped-buffers
+++ a/fs/jbd2/transaction.c
@@ -967,6 +967,13 @@ int jbd2_journal_dirty_data(handle_t *ha
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
@@ -1028,6 +1035,11 @@ int jbd2_journal_dirty_data(handle_t *ha
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
@@ -1824,6 +1836,7 @@ static int journal_unmap_buffer(journal_
 			}
 		}
 	} else if (transaction == journal->j_committing_transaction) {
+		JBUFFER_TRACE(jh, "on committing transaction");
 		if (jh->b_jlist == BJ_Locked) {
 			/*
 			 * The buffer is on the committing transaction's locked
@@ -1838,7 +1851,6 @@ static int journal_unmap_buffer(journal_
 		 * can remove it's next_transaction pointer from the
 		 * running transaction if that is set, but nothing
 		 * else. */
-		JBUFFER_TRACE(jh, "on committing transaction");
 		set_buffer_freed(bh);
 		if (jh->b_next_transaction) {
 			J_ASSERT(jh->b_next_transaction ==
@@ -1858,6 +1870,7 @@ static int journal_unmap_buffer(journal_
 		 * i_size already for this truncate so recovery will not
 		 * expose the disk blocks we are discarding here.) */
 		J_ASSERT_JH(jh, transaction == journal->j_running_transaction);
+		JBUFFER_TRACE(jh, "on running transaction");
 		may_free = __dispose_buffer(jh, transaction);
 	}
 
_

Patches currently in -mm which might be from sandeen@sandeen.net are

origin.patch
