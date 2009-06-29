From: <gregkh@suse.de>
Subject: patch jbd-fix-race-in-buffer-processing-in-commit-code.patch added to 2.6.29-stable tree
Date: Mon, 29 Jun 2009 10:46:52 -0700
Message-ID: <20090629174714.95D2348FF0@coco.kroah.org>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: jack@suse.cz, akpm@linux-foundation.org, gregkh@suse.de,
	linux-ext4@vger.kernel.org, torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:50325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbZF2RrL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jun 2009 13:47:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: jbd: fix race in buffer processing in commit code

to the 2.6.29-stable tree.  Its filename is

    jbd-fix-race-in-buffer-processing-in-commit-code.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From a61d90d75d0f9e86432c45b496b4b0fbf0fd03dc Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 9 Jun 2009 16:26:26 -0700
Subject: jbd: fix race in buffer processing in commit code

From: Jan Kara <jack@suse.cz>

commit a61d90d75d0f9e86432c45b496b4b0fbf0fd03dc upstream.

In commit code, we scan buffers attached to a transaction.  During this
scan, we sometimes have to drop j_list_lock and then we recheck whether
the journal buffer head didn't get freed by journal_try_to_free_buffers().
 But checking for buffer_jbd(bh) isn't enough because a new journal head
could get attached to our buffer head.  So add a check whether the journal
head remained the same and whether it's still at the same transaction and
list.

This is a nasty bug and can cause problems like memory corruption (use after
free) or trigger various assertions in JBD code (observed).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/commit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -238,7 +238,7 @@ write_out_data:
 			spin_lock(&journal->j_list_lock);
 		}
 		/* Someone already cleaned up the buffer? */
-		if (!buffer_jbd(bh)
+		if (!buffer_jbd(bh) || bh2jh(bh) != jh
 			|| jh->b_transaction != commit_transaction
 			|| jh->b_jlist != BJ_SyncData) {
 			jbd_unlock_bh_state(bh);
@@ -466,7 +466,9 @@ void journal_commit_transaction(journal_
 			spin_lock(&journal->j_list_lock);
 			continue;
 		}
-		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
+		if (buffer_jbd(bh) && bh2jh(bh) == jh &&
+		    jh->b_transaction == commit_transaction &&
+		    jh->b_jlist == BJ_Locked) {
 			__journal_unfile_buffer(jh);
 			jbd_unlock_bh_state(bh);
 			journal_remove_journal_head(bh);


Patches currently in stable-queue which might be from jack@suse.cz are

queue-2.6.29/jbd-fix-race-in-buffer-processing-in-commit-code.patch
