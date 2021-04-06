Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58437C43460
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Apr 2021 16:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2893B613BD
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Apr 2021 16:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbhDFQSP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 6 Apr 2021 12:18:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:44606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234686AbhDFQSN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Apr 2021 12:18:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 30A8DB262;
        Tue,  6 Apr 2021 16:18:05 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EDFC81F2B6A; Tue,  6 Apr 2021 18:18:04 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        syzbot+30774a6acf6a2cf6d535@syzkaller.appspotmail.com
Subject: [PATCH 1/2] ext4: Annotate data race in start_this_handle()
Date:   Tue,  6 Apr 2021 18:17:59 +0200
Message-Id: <20210406161804.20150-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406161605.2504-1-jack@suse.cz>
References: <20210406161605.2504-1-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Access to journal->j_running_transaction is not protected by appropriate
lock and thus is racy. We are well aware of that and the code handles
the race properly. Just add a comment and data_race() annotation.

Reported-by: syzbot+30774a6acf6a2cf6d535@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 9396666b7314..398d1d9209e2 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -349,7 +349,12 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
 	}
 
 alloc_transaction:
-	if (!journal->j_running_transaction) {
+	/*
+	 * This check is racy but it is just an optimization of allocating new
+	 * transaction early if there are high chances we'll need it. If we
+	 * guess wrong, we'll retry or free unused transaction.
+	 */
+	if (!data_race(journal->j_running_transaction)) {
 		/*
 		 * If __GFP_FS is not present, then we may be being called from
 		 * inside the fs writeback layer, so we MUST NOT fail.
-- 
2.26.2

