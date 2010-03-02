From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 17/28] jbd2: clean up an assertion in jbd2_journal_commit_transaction()
Date: Tue,  2 Mar 2010 13:18:34 -0500
Message-ID: <1267553925-6308-18-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: dingdinghua <dingdinghua@nrchpc.ac.cn>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43076 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab0CBSS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:58 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: dingdinghua <dingdinghua@nrchpc.ac.cn>

commit_transaction has the same value as journal->j_running_transaction,
so we can simplify the assert statement.

Signed-off-by: dingdinghua <dingdinghua@nrchpc.ac.cn>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/commit.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 3ee211e..671da7f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -883,8 +883,7 @@ restart_loop:
 		spin_unlock(&journal->j_list_lock);
 		bh = jh2bh(jh);
 		jbd_lock_bh_state(bh);
-		J_ASSERT_JH(jh,	jh->b_transaction == commit_transaction ||
-			jh->b_transaction == journal->j_running_transaction);
+		J_ASSERT_JH(jh,	jh->b_transaction == commit_transaction);
 
 		/*
 		 * If there is undo-protected committed data against
-- 
1.6.6.1.1.g974db.dirty

