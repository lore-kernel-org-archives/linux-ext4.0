From: <gregkh@suse.de>
Subject: patch jbd2-commit-fix-transaction-dropping.patch queued to -stable tree
Date: Tue, 07 Aug 2007 02:02:18 -0700
Message-ID: <20070807090718.31D8814458DB@imap.suse.de>
References: <200707160637.l6G6bKPk013984@imap1.linux-foundation.org>
Cc: <stable-commits@vger.kernel.org>
To: jack@suse.cz, akpm@linux-foundation.org, cebbert@redhat.com,
	dev@openvz.org, gregkh@suse.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:46710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946AbXHGJHT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Aug 2007 05:07:19 -0400
In-Reply-To: <200707160637.l6G6bKPk013984@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: jbd2 commit: fix transaction dropping

to the 2.6.22-stable tree.  Its filename is

     jbd2-commit-fix-transaction-dropping.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Sun Jul 15 23:37:38 2007
From: Jan Kara <jack@suse.cz>
Date: Sun, 15 Jul 2007 23:37:20 -0700
Subject: jbd2 commit: fix transaction dropping
To: torvalds@linux-foundation.org
Cc: dev@openvz.org, jack@suse.cz, cebbert@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, stable@kernel.org
Message-ID: <200707160637.l6G6bKPk013984@imap1.linux-foundation.org>


From: Jan Kara <jack@suse.cz>

We have to check that also the second checkpoint list is non-empty before
dropping the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff -puN fs/jbd2/commit.c~jbd2-commit-fix-transaction-dropping fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~jbd2-commit-fix-transaction-dropping
+++ a/fs/jbd2/commit.c
@@ -896,7 +896,8 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL) {
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__jbd2_journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
_

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable



Patches currently in stable-queue which might be from jack@suse.cz are

queue-2.6.22/jbd-commit-fix-transaction-dropping.patch
queue-2.6.22/jbd2-commit-fix-transaction-dropping.patch
