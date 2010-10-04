From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] jbd: Simplify return path of journal_init_common()
Date: Mon,  4 Oct 2010 14:49:58 +0900
Message-ID: <1286171398-3479-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:63647 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0JDFuE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Oct 2010 01:50:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/journal.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 2c4b1f1..6f20a75 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -698,7 +698,7 @@ static journal_t * journal_init_common (void)
 
 	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
-		goto fail;
+		goto out;
 
 	init_waitqueue_head(&journal->j_wait_transaction_locked);
 	init_waitqueue_head(&journal->j_wait_logspace);
@@ -721,11 +721,10 @@ static journal_t * journal_init_common (void)
 	err = journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
 	if (err) {
 		kfree(journal);
-		goto fail;
+		journal = NULL;
 	}
+out:
 	return journal;
-fail:
-	return NULL;
 }
 
 /* journal_init_dev and journal_init_inode:
-- 
1.7.0.4

