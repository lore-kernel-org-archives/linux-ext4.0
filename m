From: akpm@linux-foundation.org
Subject: + jbd-ordered-data-integrity-fix.patch added to -mm tree
Date: Tue, 03 Jun 2008 15:40:06 -0700
Message-ID: <200806032240.m53Me6Q8023572@imap1.linux-foundation.org>
Cc: hidehiro.kawai.ez@hitachi.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbYFCWkM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 18:40:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: ordered data integrity fix
has been added to the -mm tree.  Its filename is
     jbd-ordered-data-integrity-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: ordered data integrity fix
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

In ordered mode, if a file data buffer being dirtied exists in the
committing transaction, we write the buffer to the disk, move it from the
committing transaction to the running transaction, then dirty it.  But we
don't have to remove the buffer from the committing transaction when the
buffer couldn't be written out, otherwise it would miss the error and the
committing transaction would not abort.

This patch adds an error check before removing the buffer from the
committing transaction.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN fs/jbd/transaction.c~jbd-ordered-data-integrity-fix fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-ordered-data-integrity-fix
+++ a/fs/jbd/transaction.c
@@ -954,9 +954,10 @@ int journal_dirty_data(handle_t *handle,
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
+	int ret = 0;
 
 	if (is_handle_aborted(handle))
-		return 0;
+		return ret;
 
 	jh = journal_add_journal_head(bh);
 	JBUFFER_TRACE(jh, "entry");
@@ -1067,7 +1068,16 @@ int journal_dirty_data(handle_t *handle,
 				   time if it is redirtied */
 			}
 
-			/* journal_clean_data_list() may have got there first */
+			/*
+			 * We cannot remove the buffer with io error from the
+			 * committing transaction, because otherwise it would
+			 * miss the error and the commit would not abort.
+			 */
+			if (unlikely(!buffer_uptodate(bh))) {
+				ret = -EIO;
+				goto no_journal;
+			}
+
 			if (jh->b_transaction != NULL) {
 				JBUFFER_TRACE(jh, "unfile from commit");
 				__journal_temp_unlink_buffer(jh);
@@ -1108,7 +1118,7 @@ no_journal:
 	}
 	JBUFFER_TRACE(jh, "exit");
 	journal_put_journal_head(jh);
-	return 0;
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

jbd-strictly-check-for-write-errors-on-data-buffers.patch
jbd-ordered-data-integrity-fix.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-abort-ext3-if-the-journal-has-aborted.patch

