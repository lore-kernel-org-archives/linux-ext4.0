From: Greg KH <gregkh@suse.de>
Subject: [patch 089/114] jbd2: Fix return value of jbd2_journal_start_commit()
Date: Fri, 13 Mar 2009 18:11:06 -0700
Message-ID: <20090314011044.553768976@mini.kroah.org>
References: <20090314010937.416083662@mini.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755027AbZCNBVM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:12 -0400
Content-Disposition: inline; filename=jbd2-fix-return-value-of-jbd2_journal_start_commit.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

(cherry picked from commit c88ccea3143975294f5a52097546bcbb75975f52)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/journal.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -430,7 +430,7 @@ int __jbd2_log_space_left(journal_t *jou
 }
 
 /*
- * Called under j_state_lock.  Returns true if a transaction was started.
+ * Called under j_state_lock.  Returns true if a transaction commit was started.
  */
 int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 {
@@ -498,7 +498,8 @@ int jbd2_journal_force_commit_nested(jou
 
 /*
  * Start a commit of the current running transaction (if any).  Returns true
- * if a transaction was started, and fills its tid in at *ptid
+ * if a transaction is going to be committed (or is currently already
+ * committing), and fills its tid in at *ptid
  */
 int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
 {
@@ -508,15 +509,19 @@ int jbd2_journal_start_commit(journal_t 
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


