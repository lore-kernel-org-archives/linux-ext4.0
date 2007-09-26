From: akpm@linux-foundation.org
Subject: + jbd2-fix-commit-code-to-properly-abort-journal.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:22:42 -0700
Message-ID: <200709262222.l8QMMgmG006947@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592AbXIZWXI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2007 18:23:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: fix commit code to properly abort journal
has been added to the -mm tree.  Its filename is
     jbd2-fix-commit-code-to-properly-abort-journal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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


diff -puN fs/jbd2/commit.c~jbd2-fix-commit-code-to-properly-abort-journal fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~jbd2-fix-commit-code-to-properly-abort-journal
+++ a/fs/jbd2/commit.c
@@ -541,7 +541,7 @@ void jbd2_journal_commit_transaction(jou
 	spin_unlock(&journal->j_list_lock);
 
 	if (err)
-		__jbd2_journal_abort_hard(journal);
+		jbd2_journal_abort(journal, err);
 
 	jbd2_journal_write_revoke_records(journal, commit_transaction);
 
@@ -604,7 +604,7 @@ void jbd2_journal_commit_transaction(jou
 
 			descriptor = jbd2_journal_get_descriptor_buffer(journal);
 			if (!descriptor) {
-				__jbd2_journal_abort_hard(journal);
+				jbd2_journal_abort(journal, -EIO);
 				continue;
 			}
 
@@ -637,7 +637,7 @@ void jbd2_journal_commit_transaction(jou
 		   and repeat this loop: we'll fall into the
 		   refile-on-abort condition above. */
 		if (err) {
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 			continue;
 		}
 
@@ -862,7 +862,7 @@ wait_for_iobuf:
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
jbd2-fix-commit-code-to-properly-abort-journal.patch
