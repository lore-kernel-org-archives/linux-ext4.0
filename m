Return-Path: <SRS0=1y6H=WF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923C3C32757
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Aug 2019 12:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71C3A21783
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Aug 2019 12:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406794AbfHIMmk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 9 Aug 2019 08:42:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:37668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406735AbfHIMmk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Aug 2019 08:42:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1FCF6AF79;
        Fri,  9 Aug 2019 12:42:39 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 6F31E1E47C6; Fri,  9 Aug 2019 14:42:38 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Julia Cartwright <julia@ni.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/7] jbd2: Drop unnecessary branch from jbd2_journal_forget()
Date:   Fri,  9 Aug 2019 14:42:30 +0200
Message-Id: <20190809124233.13277-5-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190809124233.13277-1-jack@suse.cz>
References: <20190809124233.13277-1-jack@suse.cz>
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

