From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/8] jbd2: Fix BH_JWrite setting in checkpointing code
Date: Wed, 15 Feb 2012 19:34:10 +0100
Message-ID: <1329330854-14237-5-git-send-email-jack@suse.cz>
References: <1329330854-14237-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab2BOSek (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 13:34:40 -0500
In-Reply-To: <1329330854-14237-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

BH_JWrite bit should be set when buffer is written to the journal. So
checkpointing shouldn't set this bit when writing out buffer. This didn't
cause any observable bug since BH_JWrite bit is used only for debugging
purposes but it's good to have this consistent.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index de76f1f..e68a820 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -266,7 +266,6 @@ __flush_batch(journal_t *journal, int *batch_count)
 
 	for (i = 0; i < *batch_count; i++) {
 		struct buffer_head *bh = journal->j_chkpt_bhs[i];
-		clear_buffer_jwrite(bh);
 		BUFFER_TRACE(bh, "brelse");
 		__brelse(bh);
 	}
@@ -340,7 +339,6 @@ static int __process_buffer(journal_t *journal, struct journal_head *jh,
 		BUFFER_TRACE(bh, "queue");
 		get_bh(bh);
 		J_ASSERT_BH(bh, !buffer_jwrite(bh));
-		set_buffer_jwrite(bh);
 		journal->j_chkpt_bhs[*batch_count] = bh;
 		__buffer_relink_io(jh);
 		jbd_unlock_bh_state(bh);
-- 
1.7.1

