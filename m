From: akpm@linux-foundation.org
Subject: [patch 018/144] jbd: fix commit code to properly abort journal
Date: Thu, 18 Oct 2007 23:39:22 -0700
Message-ID: <200710190639.l9J6dM90020265@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761404AbXJSGj6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Oct 2007 02:39:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Kara <jack@suse.cz>

We should really call journal_abort() and not __journal_abort_hard() in
case of errors.  The latter call does not record the error in the journal
superblock and thus filesystem won't be marked as with errors later (and
user could happily mount it without any warning).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/jbd/commit.c~jbd-fix-commit-code-to-properly-abort-journal fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-fix-commit-code-to-properly-abort-journal
+++ a/fs/jbd/commit.c
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
_
