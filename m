From: akpm@linux-foundation.org
Subject: + jbd-fix-return-value-of-journal_start_commit.patch added to -mm tree
Date: Tue, 03 Feb 2009 13:04:44 -0800
Message-ID: <200902032104.n13L4iip024281@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, sandeen@redhat.com,
	snitzer@gmail.com
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbZBCVFn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 16:05:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: fix return value of journal_start_commit()
has been added to the -mm tree.  Its filename is
     jbd-fix-return-value-of-journal_start_commit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: fix return value of journal_start_commit()
From: Jan Kara <jack@suse.cz>

journal_start_commit() returns 1 if either a transaction is committing or
the function has queued a transaction commit.  But it returns 0 if we
raced with somebody queueing the transaction commit as well.  This
resulted in ext3_sync_fs() not functioning correctly (description from
Arthur Jones): In the case of a data=ordered umount with pending long
symlinks which are delayed due to a long list of other I/O on the backing
block device, this causes the buffer associated with the long symlinks to
not be moved to the inode dirty list in the second phase of fsync_super. 
Then, before they can be dirtied again, kjournald exits, seeing the UMOUNT
flag and the dirty pages are never written to the backing block device,
causing long symlink corruption and exposing new or previously freed block
data to userspace.

This can be reproduced with a script created by Eric Sandeen
<sandeen@redhat.com>:

        #!/bin/bash

        umount /mnt/test2
        mount /dev/sdb4 /mnt/test2
        rm -f /mnt/test2/*
        dd if=/dev/zero of=/mnt/test2/bigfile bs=1M count=512
        touch /mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
        ln -s /mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
        /mnt/test2/link
        umount /mnt/test2
        mount /dev/sdb4 /mnt/test2
        ls /mnt/test2/

This patch fixes journal_start_commit() to always return 1 when there's
a transaction committing or queued for commit.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Mike Snitzer <snitzer@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/jbd/journal.c~jbd-fix-return-value-of-journal_start_commit fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-fix-return-value-of-journal_start_commit
+++ a/fs/jbd/journal.c
@@ -427,7 +427,7 @@ int __log_space_left(journal_t *journal)
 }
 
 /*
- * Called under j_state_lock.  Returns true if a transaction was started.
+ * Called under j_state_lock.  Returns true if a transaction commit was started.
  */
 int __log_start_commit(journal_t *journal, tid_t target)
 {
@@ -495,7 +495,8 @@ int journal_force_commit_nested(journal_
 
 /*
  * Start a commit of the current running transaction (if any).  Returns true
- * if a transaction was started, and fills its tid in at *ptid
+ * if a transaction is going to be committed (or is currently already
+ * committing), and fills its tid in at *ptid
  */
 int journal_start_commit(journal_t *journal, tid_t *ptid)
 {
@@ -505,15 +506,19 @@ int journal_start_commit(journal_t *jour
 	if (journal->j_running_transaction) {
 		tid_t tid = journal->j_running_transaction->t_tid;
 
-		ret = __log_start_commit(journal, tid);
-		if (ret && ptid)
+		__log_start_commit(journal, tid);
+		/* There's a running transaction and we've just made sure
+		 * it's commit has been scheduled. */
+		if (ptid)
 			*ptid = tid;
-	} else if (journal->j_committing_transaction && ptid) {
+		ret = 1;
+	} else if (journal->j_committing_transaction) {
 		/*
 		 * If ext3_write_super() recently started a commit, then we
 		 * have to wait for completion of that transaction
 		 */
-		*ptid = journal->j_committing_transaction->t_tid;
+		if (ptid)
+			*ptid = journal->j_committing_transaction->t_tid;
 		ret = 1;
 	}
 	spin_unlock(&journal->j_state_lock);
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
jbd-fix-return-value-of-journal_start_commit.patch
revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs.patch
fs-adfs-return-f_fsid-for-statfs2.patch

