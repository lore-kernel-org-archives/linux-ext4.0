From: Jan Kara <jack@suse.com>
Subject: [PATCH] jbd2: Fix checkpoint list cleanup
Date: Mon,  5 Oct 2015 15:59:32 +0200
Message-ID: <1444053572-15671-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbbJEN7k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Oct 2015 09:59:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Unlike comments and expectation of callers journal_clean_one_cp_list()
returned 1 not only if it freed the transaction but also if it freed
some buffers in the transaction. That could make
__jbd2_journal_clean_checkpoint_list() skip processing
t_checkpoint_io_list and continue with processing the next transaction.
This is mostly a cosmetic issue since the only result is we can
sometimes free less memory than we could. But it's still worth fixing.
Fix journal_clean_one_cp_list() to return 1 only if the transaction was
really freed.

Fixes: 50849db32a9f529235a84bcc84a6b8e631b1d0ec
Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/jbd2/checkpoint.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 8c44654ce274..684996c8a3a4 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -427,7 +427,6 @@ static int journal_clean_one_cp_list(struct journal_head *jh, bool destroy)
 	struct journal_head *last_jh;
 	struct journal_head *next_jh = jh;
 	int ret;
-	int freed = 0;
 
 	if (!jh)
 		return 0;
@@ -441,10 +440,9 @@ static int journal_clean_one_cp_list(struct journal_head *jh, bool destroy)
 		else
 			ret = __jbd2_journal_remove_checkpoint(jh) + 1;
 		if (!ret)
-			return freed;
+			return 0;
 		if (ret == 2)
 			return 1;
-		freed = 1;
 		/*
 		 * This function only frees up some memory
 		 * if possible so we dont have an obligation
@@ -452,10 +450,10 @@ static int journal_clean_one_cp_list(struct journal_head *jh, bool destroy)
 		 * requested:
 		 */
 		if (need_resched())
-			return freed;
+			return 0;
 	} while (jh != last_jh);
 
-	return freed;
+	return 0;
 }
 
 /*
-- 
2.1.4

