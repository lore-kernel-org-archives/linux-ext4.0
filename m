Return-Path: <SRS0=SFt/=XW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C19C388F4
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Sep 2019 11:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E74B02146E
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Sep 2019 11:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfI0LQO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 27 Sep 2019 07:16:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:52460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727316AbfI0LQG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 27 Sep 2019 07:16:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02EB4B147;
        Fri, 27 Sep 2019 11:16:04 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 64CF31E4832; Fri, 27 Sep 2019 13:16:20 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 13/15] jbd2: Fix statistics for the number of logged blocks
Date:   Fri, 27 Sep 2019 13:15:34 +0200
Message-Id: <20190927111536.16455-14-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190927111536.16455-1-jack@suse.cz>
References: <20190927111536.16455-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

jbd2 statistics counting number of blocks logged in a transaction was
wrong. It didn't count the commit block and more importantly it didn't
count revoke descriptor blocks. Make sure these get properly counted.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2736c00cf70e..43f2dde5bb47 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -726,7 +726,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
 			}
 			cond_resched();
-			stats.run.rs_blocks_logged += bufs;
 
 			/* Force a new descriptor to be generated next
                            time round the loop. */
@@ -813,6 +812,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		if (unlikely(!buffer_uptodate(bh)))
 			err = -EIO;
 		jbd2_unfile_log_bh(bh);
+		stats.run.rs_blocks_logged++;
 
 		/*
 		 * The list contains temporary buffer heads created by
@@ -858,6 +858,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
 		clear_buffer_jwrite(bh);
 		jbd2_unfile_log_bh(bh);
+		stats.run.rs_blocks_logged++;
 		__brelse(bh);		/* One for getblk */
 		/* AKPM: bforget here */
 	}
@@ -879,6 +880,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	}
 	if (cbh)
 		err = journal_wait_on_commit_record(journal, cbh);
+	stats.run.rs_blocks_logged++;
 	if (jbd2_has_feature_async_commit(journal) &&
 	    journal->j_flags & JBD2_BARRIER) {
 		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
-- 
2.16.4

