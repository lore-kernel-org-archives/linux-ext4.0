From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Fix commit code to properly abort journal
Date: Tue, 25 Sep 2007 16:01:13 +0200
Message-ID: <20070925140113.GE412@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42602 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751615AbXIYNj5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 09:39:57 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  attached patch changes JBD commit code to properly record reason for
aborted journal (j_errno) and not just mark the journal as aborted. Andrew,
could you please queue the patch? Thanks.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

-----

We should really call journal_abort() and not __journal_abort_hard() in case
of errors. The latter call does not record the error in the journal superblock and
thus filesystem won't be marked as with errors later (and user could happily mount
it without any warning).

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-rc6/fs/jbd/commit.c linux-2.6.23-rc6-1-jbd_abort_fix/fs/jbd/commit.c
--- linux-2.6.23-rc6/fs/jbd/commit.c	2007-09-18 19:22:28.000000000 +0200
+++ linux-2.6.23-rc6-1-jbd_abort_fix/fs/jbd/commit.c	2007-09-25 15:02:49.000000000 +0200
@@ -466,7 +466,7 @@ void journal_commit_transaction(journal_
 	spin_unlock(&journal->j_list_lock);
 
 	if (err)
-		__journal_abort_hard(journal);
+		journal_abort(journal, err);
 
 	journal_write_revoke_records(journal, commit_transaction);
 
@@ -524,7 +524,7 @@ void journal_commit_transaction(journal_
 
 			descriptor = journal_get_descriptor_buffer(journal);
 			if (!descriptor) {
-				__journal_abort_hard(journal);
+				journal_abort(journal, -EIO);
 				continue;
 			}
 
@@ -557,7 +557,7 @@ void journal_commit_transaction(journal_
 		   and repeat this loop: we'll fall into the
 		   refile-on-abort condition above. */
 		if (err) {
-			__journal_abort_hard(journal);
+			journal_abort(journal, err);
 			continue;
 		}
 
@@ -748,7 +748,7 @@ wait_for_iobuf:
 		err = -EIO;
 
 	if (err)
-		__journal_abort_hard(journal);
+		journal_abort(journal, err);
 
 	/* End of a transaction!  Finally, we can do checkpoint
            processing: any buffers committed as a result of this
