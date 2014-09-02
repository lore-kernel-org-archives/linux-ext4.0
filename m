From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Optimize jbd2_log_do_checkpoint() a bit
Date: Tue,  2 Sep 2014 19:18:30 +0200
Message-ID: <1409678310-11646-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbaIBRSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 13:18:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we discover written out buffer in transaction checkpoint list we
don't have to recheck validity of a transaction. Either this is the last
buffer in a transaction - and then we are done - or this isn't and then
we can just take another buffer from the checkpoint list without
dropping j_list_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 993a187527f3..3722e2e53638 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -343,12 +343,15 @@ restart:
 		if (!buffer_dirty(bh)) {
 			if (unlikely(buffer_write_io_error(bh)) && !result)
 				result = -EIO;
-			get_bh(bh);
 			BUFFER_TRACE(bh, "remove from checkpoint");
-			__jbd2_journal_remove_checkpoint(jh);
-			spin_unlock(&journal->j_list_lock);
-			__brelse(bh);
-			goto retry;
+			if (__jbd2_journal_remove_checkpoint(jh)) {
+				/*
+				 * This was the last buffer attached to the
+				 * transaction. We are done.
+				 */
+				goto out;
+			}
+			continue;
 		}
 		/*
 		 * Important: we are about to write the buffer, and
-- 
1.8.1.4

