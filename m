From: akpm@linux-foundation.org
Subject: [patch 002/268] jbd commit: fix transaction dropping
Date: Sun, 15 Jul 2007 23:37:18 -0700
Message-ID: <200707160637.l6G6bIOv013980@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz, cebbert@redhat.com,
	dev@openvz.org, linux-ext4@vger.kernel.org, stable@kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899AbXGPGhm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 02:37:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Kara <jack@suse.cz>

We have to check that also the second checkpoint list is non-empty before
dropping the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/jbd/commit.c~jbd-commit-fix-transaction-dropping fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-commit-fix-transaction-dropping
+++ a/fs/jbd/commit.c
@@ -887,7 +887,8 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL) {
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
_
