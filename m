From: akpm@linux-foundation.org
Subject: + jbd-fix-commit-code-to-properly-abort-journal.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:21:52 -0700
Message-ID: <200709262221.l8QMLqkX006922@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758978AbXIZWWf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2007 18:22:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: fix commit code to properly abort journal
has been added to the -mm tree.  Its filename is
     jbd-fix-commit-code-to-properly-abort-journal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jbd: fix commit code to properly abort journal
From: Jan Kara <jack@suse.cz>

We should really call journal_abort() and not __journal_abort_hard() in
case of errors.  The latter call does not record the error in the journal
superblock and thus filesystem won't be marked as with errors later (and
user could happily mount it without any warning).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

Patches currently in -mm which might be from jack@suse.cz are

send-quota-messages-via-netlink.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
udf-code-style-fixup-v3.patch
lockdep-give-each-filesystem-its-own-inode-lock-class.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
jbd-fix-commit-code-to-properly-abort-journal.patch
