From: <gregkh@suse.de>
Subject: patch jbd-fix-the-way-the-b_modified-flag-is-cleared.patch added to 2.6.25-stable tree
Date: Fri, 01 Aug 2008 20:57:20 -0700
Message-ID: <20080802040653.9B7F114544DD@imap.suse.de>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: jbacik@redhat.com, akpm@linux-foundation.org, gregkh@suse.de,
	jack@ucw.cz, linux-ext4@vger.kernel.org,
	torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYHBEG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2008 00:06:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: jbd: fix the way the b_modified flag is cleared

to the 2.6.25-stable tree.  Its filename is

    jbd-fix-the-way-the-b_modified-flag-is-cleared.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From 5bc833feaa8b2236265764e7e81f44937be46eda Mon Sep 17 00:00:00 2001
From: Josef Bacik <jbacik@redhat.com>
Date: Mon, 28 Apr 2008 02:16:10 -0700
Subject: jbd: fix the way the b_modified flag is cleared

From: Josef Bacik <jbacik@redhat.com>

commit 5bc833feaa8b2236265764e7e81f44937be46eda upstream

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/commit.c      |   16 ----------------
 fs/jbd/transaction.c |   13 +++++++++++++
 2 files changed, 13 insertions(+), 16 deletions(-)

--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
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
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
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


Patches currently in stable-queue which might be from jbacik@redhat.com are

queue-2.6.25/jbd-fix-possible-journal-overflow-issues.patch
queue-2.6.25/jbd-fix-the-way-the-b_modified-flag-is-cleared.patch
