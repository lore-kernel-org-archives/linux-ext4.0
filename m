From: akpm@linux-foundation.org
Subject: - jbd2-fix-commit-code-to-properly-abort-journal.patch removed from -mm tree
Date: Thu, 11 Oct 2007 20:00:38 -0700
Message-ID: <200710120300.l9C30cbW028968@imap1.linux-foundation.org>
To: jack@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbXJLDAr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 23:00:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: fix commit code to properly abort journal
has been removed from the -mm tree.  Its filename was
     jbd2-fix-commit-code-to-properly-abort-journal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jbd2: fix commit code to properly abort journal
From: Jan Kara <jack@suse.cz>

We should really call journal_abort() and not __journal_abort_hard() in
case of errors.  The latter call does not record the error in the journal
superblock and thus filesystem won't be marked as with errors later (and
user could happily mount it without any warning).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/jbd2/commit.c~jbd2-fix-commit-code-to-properly-abort-journal fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~jbd2-fix-commit-code-to-properly-abort-journal
+++ a/fs/jbd2/commit.c
@@ -539,7 +539,7 @@ void jbd2_journal_commit_transaction(jou
 	spin_unlock(&journal->j_list_lock);
 
 	if (err)
-		__jbd2_journal_abort_hard(journal);
+		jbd2_journal_abort(journal, err);
 
 	jbd2_journal_write_revoke_records(journal, commit_transaction);
 
@@ -602,7 +602,7 @@ void jbd2_journal_commit_transaction(jou
 
 			descriptor = jbd2_journal_get_descriptor_buffer(journal);
 			if (!descriptor) {
-				__jbd2_journal_abort_hard(journal);
+				jbd2_journal_abort(journal, -EIO);
 				continue;
 			}
 
@@ -635,7 +635,7 @@ void jbd2_journal_commit_transaction(jou
 		   and repeat this loop: we'll fall into the
 		   refile-on-abort condition above. */
 		if (err) {
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 			continue;
 		}
 
@@ -860,7 +860,7 @@ wait_for_iobuf:
 	err = journal_wait_on_commit_record(cbh);
 
 	if (err)
-		__jbd2_journal_abort_hard(journal);
+		jbd2_journal_abort(journal, err);
 
 	/* End of a transaction!  Finally, we can do checkpoint
            processing: any buffers committed as a result of this
_

Patches currently in -mm which might be from jack@suse.cz are

send-quota-messages-via-netlink.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
udf-code-style-fixup-v3.patch
lockdep-give-each-filesystem-its-own-inode-lock-class.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
jbd-fix-commit-code-to-properly-abort-journal.patch
