From: akpm@osdl.org
Subject: - ext3-fix-j_asserttransaction-t_updates-0-in-journal_stop.patch removed from -mm tree
Date: Fri, 20 Oct 2006 13:40:42 -0700
Message-ID: <200610202040.k9KKegbc001587@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:16606 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030357AbWJTUkr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Oct 2006 16:40:47 -0400
To: hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3/4: fix J_ASSERT(transaction->t_updates > 0) in journal_stop()
has been removed from the -mm tree.  Its filename was
     ext3-fix-j_asserttransaction-t_updates-0-in-journal_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3/4: fix J_ASSERT(transaction->t_updates > 0) in journal_stop()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

A disk generated some I/O error, after it, I hitted
J_ASSERT(transaction->t_updates > 0) in journal_stop().

It seems to happened on ext3_truncate() path from stack trace. Then,
maybe the following case may trigger J_ASSERT(transaction->t_updates > 0).

ext3_truncate()
    -> ext3_free_branches()
        -> ext3_journal_test_restart()
	    -> ext3_journal_restart()
                -> journal_restart()
                transaction->t_updates--;
                /* another process aborted journal */
                    -> start_this_handle()
		    returns -EROFS without transaction->t_updates++;

    -> ext3_journal_stop()
        -> journal_stop()
	J_ASSERT(transaction->t_updates > 0)

If journal was aborted in middle of journal_restart(), ext3_truncate()
may trigger J_ASSERT().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jbd/transaction.c  |    5 +++--
 fs/jbd2/transaction.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/jbd/transaction.c~ext3-fix-j_asserttransaction-t_updates-0-in-journal_stop fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~ext3-fix-j_asserttransaction-t_updates-0-in-journal_stop
+++ a/fs/jbd/transaction.c
@@ -1314,13 +1314,14 @@ int journal_stop(handle_t *handle)
 	int old_handle_count, err;
 	pid_t pid;
 
-	J_ASSERT(transaction->t_updates > 0);
 	J_ASSERT(journal_current_handle() == handle);
 
 	if (is_handle_aborted(handle))
 		err = -EIO;
-	else
+	else {
+		J_ASSERT(transaction->t_updates > 0);
 		err = 0;
+	}
 
 	if (--handle->h_ref > 0) {
 		jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
diff -puN fs/jbd2/transaction.c~ext3-fix-j_asserttransaction-t_updates-0-in-journal_stop fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~ext3-fix-j_asserttransaction-t_updates-0-in-journal_stop
+++ a/fs/jbd2/transaction.c
@@ -1314,13 +1314,14 @@ int jbd2_journal_stop(handle_t *handle)
 	int old_handle_count, err;
 	pid_t pid;
 
-	J_ASSERT(transaction->t_updates > 0);
 	J_ASSERT(journal_current_handle() == handle);
 
 	if (is_handle_aborted(handle))
 		err = -EIO;
-	else
+	else {
+		J_ASSERT(transaction->t_updates > 0);
 		err = 0;
+	}
 
 	if (--handle->h_ref > 0) {
 		jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
clocksource-acpi_pm-add-another-greylist-chipset.patch
