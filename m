From: akpm@linux-foundation.org
Subject: + jbd2-fix-the-way-the-b_modified-flag-is-cleared.patch added to -mm tree
Date: Fri, 29 Feb 2008 16:04:06 -0800
Message-ID: <200803010004.m21046Tv027545@imap1.linux-foundation.org>
Cc: jbacik@redhat.com, jack@ucw.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932294AbYCAAFT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 19:05:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd2: fix the way the b_modified flag is cleared
has been added to the -mm tree.  Its filename is
     jbd2-fix-the-way-the-b_modified-flag-is-cleared.patch

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
Subject: jbd2: fix the way the b_modified flag is cleared
From: Josef Bacik <jbacik@redhat.com>

Currently at the start of a journal commit we loop through all of the buffers
on the committing transaction and clear the b_modified flag (the flag that is
set when a transaction modifies the buffer) under the j_list_lock.

The problem is that everywhere else this flag is modified only under the jbd2
lock buffer flag, so it will race with a running transaction who could
potentially set it, and have it unset by the committing transaction.

This is also a big waste, you can have several thousands of buffers that you
are clearing the modified flag on when you may not need to.  This patch
removes this code and instead clears the b_modified flag upon entering
do_get_write_access/journal_get_create_access, so if that transaction does
indeed use the buffer then it will be accounted for properly, and if it does
not then we know we didn't use it.

That will be important for the next patch in this series.  Tested thoroughly
by myself using postmark/iozone/bonnie++.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c      |   16 ----------------
 fs/jbd2/transaction.c |   13 +++++++++++++
 2 files changed, 13 insertions(+), 16 deletions(-)

diff -puN fs/jbd2/commit.c~jbd2-fix-the-way-the-b_modified-flag-is-cleared fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~jbd2-fix-the-way-the-b_modified-flag-is-cleared
+++ a/fs/jbd2/commit.c
@@ -520,22 +520,6 @@ void jbd2_journal_commit_transaction(jou
 	jbd_debug (3, "JBD: commit phase 2\n");
 
 	/*
-	 * First, drop modified flag: all accesses to the buffers
-	 * will be tracked for a new trasaction only -bzzz
-	 */
-	spin_lock(&journal->j_list_lock);
-	if (commit_transaction->t_buffers) {
-		new_jh = jh = commit_transaction->t_buffers->b_tnext;
-		do {
-			J_ASSERT_JH(new_jh, new_jh->b_modified == 1 ||
-					new_jh->b_modified == 0);
-			new_jh->b_modified = 0;
-			new_jh = new_jh->b_tnext;
-		} while (new_jh != jh);
-	}
-	spin_unlock(&journal->j_list_lock);
-
-	/*
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
diff -puN fs/jbd2/transaction.c~jbd2-fix-the-way-the-b_modified-flag-is-cleared fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-fix-the-way-the-b_modified-flag-is-cleared
+++ a/fs/jbd2/transaction.c
@@ -618,6 +618,12 @@ repeat:
 		goto done;
 
 	/*
+	 * this is the first time this transaction is touching this buffer,
+	 * reset the modified flag
+	 */
+       jh->b_modified = 0;
+
+	/*
 	 * If there is already a copy-out version of this buffer, then we don't
 	 * need to make another one
 	 */
@@ -829,9 +835,16 @@ int jbd2_journal_get_create_access(handl
 
 	if (jh->b_transaction == NULL) {
 		jh->b_transaction = transaction;
+
+		/* first access by this transaction */
+		jh->b_modified = 0;
+
 		JBUFFER_TRACE(jh, "file as BJ_Reserved");
 		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
 	} else if (jh->b_transaction == journal->j_committing_transaction) {
+		/* first access by this transaction */
+		jh->b_modified = 0;
+
 		JBUFFER_TRACE(jh, "set next transaction");
 		jh->b_next_transaction = transaction;
 	}
_

Patches currently in -mm which might be from jbacik@redhat.com are

jbd-fix-the-way-the-b_modified-flag-is-cleared.patch
jbd2-fix-the-way-the-b_modified-flag-is-cleared.patch
jbd-fix-possible-journal-overflow-issues.patch
jbd2-fix-possible-journal-overflow-issues.patch

