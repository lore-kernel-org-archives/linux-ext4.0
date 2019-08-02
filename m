Return-Path: <SRS0=XG74=V6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC8EC32750
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Aug 2019 15:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DA7821783
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Aug 2019 15:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbfHBPOR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 2 Aug 2019 11:14:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:35234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730671AbfHBPOQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Aug 2019 11:14:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C131EAF38;
        Fri,  2 Aug 2019 15:14:15 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D95D01E43FD; Fri,  2 Aug 2019 17:14:14 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Julia Cartwright <julia@ni.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/7] jbd2: Drop unnecessary branch from jbd2_journal_forget()
Date:   Fri,  2 Aug 2019 17:13:53 +0200
Message-Id: <20190802151356.777-5-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190802151356.777-1-jack@suse.cz>
References: <20190802151356.777-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We have cleared both dirty & jbddirty bits from the bh. So there's no
difference between bforget() and brelse(). Thus there's no point jumping
to no_jbd branch.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index c4fe050e78c6..9ccef3d6e817 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1596,10 +1596,6 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 		} else {
 			__jbd2_journal_unfile_buffer(jh);
 			jbd2_journal_put_journal_head(jh);
-			if (!buffer_jbd(bh)) {
-				spin_unlock(&journal->j_list_lock);
-				goto not_jbd;
-			}
 		}
 		spin_unlock(&journal->j_list_lock);
 	} else if (jh->b_transaction) {
-- 
2.16.4

