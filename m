From: Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 37/58] jbd commit: fix transaction dropping
Date: Wed, 22 Aug 2007 11:39:21 +0200
Message-ID: <20070822084028.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
Cc: Jan Kara <jack@suse.cz>, Chuck Ebbert <cebbert@redhat.com>,
	Kirill Korotaev <dev@openvz.org>, <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 1wt.eu ([62.212.114.60]:2219 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652AbXHVJKJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Aug 2007 05:10:09 -0400
Content-Disposition: inline; filename=0037-jbd-commit-fix-transaction-dropping.patch
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We have to check that also the second checkpoint list is non-empty before
dropping the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/jbd/commit.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index be4648b..84436cb 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -888,7 +888,8 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL) {
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
-- 
1.5.2.5

-- 
