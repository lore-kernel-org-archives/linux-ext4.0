From: akpm@linux-foundation.org
Subject: [patch 275/307] jbd: fix the way the b_modified flag is cleared
Date: Mon, 28 Apr 2008 02:16:10 -0700
Message-ID: <200804280916.m3S9GAW7019153@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jbacik@redhat.com, jack@ucw.cz,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762508AbYD1JVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:21:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Josef Bacik <jbacik@redhat.com>

Currently at the start of a journal commit we loop through all of the buffers
on the committing transaction and clear the b_modified flag (the flag that is
set when a transaction modifies the buffer) under the j_list_lock.

The problem is that everywhere else this flag is modified only under the jbd
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
Acked-by: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c      |   16 ----------------
 fs/jbd/transaction.c |   13 +++++++++++++
 2 files changed, 13 insertions(+), 16 deletions(-)

diff -puN fs/jbd/commit.c~jbd-fix-the-way-the-b_modified-flag-is-cleared fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-fix-the-way-the-b_modified-flag-is-cleared
+++ a/fs/jbd/commit.c
@@ -407,22 +407,6 @@ void journal_commit_transaction(journal_
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
diff -puN fs/jbd/transaction.c~jbd-fix-the-way-the-b_modified-flag-is-cleared fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-fix-the-way-the-b_modified-flag-is-cleared
+++ a/fs/jbd/transaction.c
@@ -609,6 +609,12 @@ repeat:
 		goto done;
 
 	/*
+	 * this is the first time this transaction is touching this buffer,
+	 * reset the modified flag
+	 */
+	jh->b_modified = 0;
+
+	/*
 	 * If there is already a copy-out version of this buffer, then we don't
 	 * need to make another one
 	 */
@@ -820,9 +826,16 @@ int journal_get_create_access(handle_t *
 
 	if (jh->b_transaction == NULL) {
 		jh->b_transaction = transaction;
+
+		/* first access by this transaction */
+		jh->b_modified = 0;
+
 		JBUFFER_TRACE(jh, "file as BJ_Reserved");
 		__journal_file_buffer(jh, transaction, BJ_Reserved);
 	} else if (jh->b_transaction == journal->j_committing_transaction) {
+		/* first access by this transaction */
+		jh->b_modified = 0;
+
 		JBUFFER_TRACE(jh, "set next transaction");
 		jh->b_next_transaction = transaction;
 	}
_
