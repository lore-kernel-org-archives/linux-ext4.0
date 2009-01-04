From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: Submit writes to the journal using WRITE_SYNC
Date: Sun,  4 Jan 2009 16:42:21 -0500
Message-ID: <1231105341-22896-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbZADVmY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Jan 2009 16:42:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since we will be waiting for writes to the journal to complete in
jbd2_journal_commit_transaction() and journal_submit_commit_record(),
submit them using WRITE_SYNC.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/commit.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 0ad8416..04d3472 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -138,7 +138,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		set_buffer_ordered(bh);
 		barrier_done = 1;
 	}
-	ret = submit_bh(WRITE, bh);
+	ret = submit_bh(WRITE_SYNC, bh);
 	if (barrier_done)
 		clear_buffer_ordered(bh);
 
@@ -159,7 +159,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		lock_buffer(bh);
 		set_buffer_uptodate(bh);
 		clear_buffer_dirty(bh);
-		ret = submit_bh(WRITE, bh);
+		ret = submit_bh(WRITE_SYNC, bh);
 	}
 	*cbh = bh;
 	return ret;
@@ -676,7 +676,7 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(WRITE, bh);
+				submit_bh(WRITE_SYNC, bh);
 			}
 			cond_resched();
 			stats.u.run.rs_blocks_logged += bufs;
-- 
1.6.0.4.8.g36f27.dirty

