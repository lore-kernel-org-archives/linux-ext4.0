Return-Path: <SRS0=XaFB=Y5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E16C5DF60
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Nov 2019 16:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DF832190F
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Nov 2019 16:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390435AbfKEQoq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Nov 2019 11:44:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:41690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390408AbfKEQoo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Nov 2019 11:44:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9110AB46D;
        Tue,  5 Nov 2019 16:44:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 5BF481E4ABE; Tue,  5 Nov 2019 17:44:37 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 15/25] jbd2: Drop pointless check from jbd2_journal_stop()
Date:   Tue,  5 Nov 2019 17:44:21 +0100
Message-Id: <20191105164437.32602-15-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

If a transaction is larger than journal->j_max_transaction_buffers, that
is a bug and not a trigger for transaction commit. Also the very next
attempt to start new handle will start transaction commit anyway. So
just remove the pointless check. Arguably, we could start transaction
commit whenever the transaction size is *close* to
journal->j_max_transaction_buffers. This has a potential to reduce
latency of the next jbd2_journal_start() at the cost of somewhat smaller
transactions. However for this to have any effect, it would mean that
there isn't someone already waiting in jbd2_journal_start() which means
metadata load for the fs is pretty light anyway so probably this
optimization is not worth it.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 6f560713f7f0..a160c3f665f9 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1803,13 +1803,10 @@ int jbd2_journal_stop(handle_t *handle)
 
 	/*
 	 * If the handle is marked SYNC, we need to set another commit
-	 * going!  We also want to force a commit if the current
-	 * transaction is occupying too much of the log, or if the
-	 * transaction is too old now.
+	 * going!  We also want to force a commit if the transaction is too
+	 * old now.
 	 */
 	if (handle->h_sync ||
-	    (atomic_read(&transaction->t_outstanding_credits) >
-	     journal->j_max_transaction_buffers) ||
 	    time_after_eq(jiffies, transaction->t_expires)) {
 		/* Do this even for aborted journals: an abort still
 		 * completes the commit thread, it just doesn't write
-- 
2.16.4

