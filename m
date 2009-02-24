From: Theodore Ts'o <tytso@mit.edu>
Subject: [STABLE, 2.6.28.y] jbd2: Fix return value of jbd2_journal_start_commit()
Date: Tue, 24 Feb 2009 12:14:41 -0500
Message-ID: <1235495688-8044-1-git-send-email-tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39949 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980AbZBXRPX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 12:15:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

The function jbd2_journal_start_commit() returns 1 if either a
transaction is committing or the function has queued a transaction
commit. But it returns 0 if we raced with somebody queueing the
transaction commit as well. This resulted in ext4_sync_fs() not
functioning correctly (description from Arthur Jones):

   In the case of a data=ordered umount with pending long symlinks
   which are delayed due to a long list of other I/O on the backing
   block device, this causes the buffer associated with the long
   symlinks to not be moved to the inode dirty list in the second
   phase of fsync_super.  Then, before they can be dirtied again,
   kjournald exits, seeing the UMOUNT flag and the dirty pages are
   never written to the backing block device, causing long symlink
   corruption and exposing new or previously freed block data to
   userspace.

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

This patch fixes jbd2_journal_start_commit() to always return 1 when
there's a transaction committing or queued for commit.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
CC: Eric Sandeen <sandeen@redhat.com>
CC: linux-ext4@vger.kernel.org
(cherry picked from commit c88ccea3143975294f5a52097546bcbb75975f52)
---
 fs/jbd2/journal.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e70d657..a8fb64d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -430,7 +430,7 @@ int __jbd2_log_space_left(journal_t *journal)
 }
 
 /*
- * Called under j_state_lock.  Returns true if a transaction was started.
+ * Called under j_state_lock.  Returns true if a transaction commit was started.
  */
 int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 {
@@ -498,7 +498,8 @@ int jbd2_journal_force_commit_nested(journal_t *journal)
 
 /*
  * Start a commit of the current running transaction (if any).  Returns true
- * if a transaction was started, and fills its tid in at *ptid
+ * if a transaction is going to be committed (or is currently already
+ * committing), and fills its tid in at *ptid
  */
 int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
 {
@@ -508,15 +509,19 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
 	if (journal->j_running_transaction) {
 		tid_t tid = journal->j_running_transaction->t_tid;
 
-		ret = __jbd2_log_start_commit(journal, tid);
-		if (ret && ptid)
+		__jbd2_log_start_commit(journal, tid);
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
-- 
1.5.6.3

