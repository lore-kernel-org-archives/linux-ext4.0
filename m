Return-Path: <SRS0=XaFB=Y5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEBCC5DF60
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Nov 2019 16:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84ECB2190F
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Nov 2019 16:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390370AbfKEQon (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Nov 2019 11:44:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:41620 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390366AbfKEQok (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Nov 2019 11:44:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0824EB3A6;
        Tue,  5 Nov 2019 16:44:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 69F851E4AC2; Tue,  5 Nov 2019 17:44:37 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 19/25] jbd2: Drop jbd2_space_needed()
Date:   Tue,  5 Nov 2019 17:44:25 +0100
Message-Id: <20191105164437.32602-19-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The function is now just a trivial wrapper returning
journal->j_max_transaction_buffers. Drop it.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c  | 2 +-
 fs/jbd2/transaction.c | 5 +++--
 include/linux/jbd2.h  | 9 ---------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index a1909066bde6..8fff6677a5da 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -110,7 +110,7 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 	int nblocks, space_left;
 	/* assert_spin_locked(&journal->j_state_lock); */
 
-	nblocks = jbd2_space_needed(journal);
+	nblocks = journal->j_max_transaction_buffers;
 	while (jbd2_log_space_left(journal) < nblocks) {
 		write_unlock(&journal->j_state_lock);
 		mutex_lock_io(&journal->j_checkpoint_mutex);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index ed7cf9e62584..ba388da7e02b 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -270,12 +270,13 @@ static int add_transaction_credits(journal_t *journal, int blocks,
 	 * *before* starting to dirty potentially checkpointed buffers
 	 * in the new transaction.
 	 */
-	if (jbd2_log_space_left(journal) < jbd2_space_needed(journal)) {
+	if (jbd2_log_space_left(journal) < journal->j_max_transaction_buffers) {
 		atomic_sub(total, &t->t_outstanding_credits);
 		read_unlock(&journal->j_state_lock);
 		jbd2_might_wait_for_commit(journal);
 		write_lock(&journal->j_state_lock);
-		if (jbd2_log_space_left(journal) < jbd2_space_needed(journal))
+		if (jbd2_log_space_left(journal) <
+					journal->j_max_transaction_buffers)
 			__jbd2_log_wait_for_space(journal);
 		write_unlock(&journal->j_state_lock);
 		return 1;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index bef4f74b1ea0..1dd2703a8e26 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1562,15 +1562,6 @@ static inline int jbd2_journal_has_csum_v2or3(journal_t *journal)
 	return journal->j_chksum_driver != NULL;
 }
 
-/*
- * Return the minimum number of blocks which must be free in the journal
- * before a new transaction may be started.  Must be called under j_state_lock.
- */
-static inline int jbd2_space_needed(journal_t *journal)
-{
-	return journal->j_max_transaction_buffers;
-}
-
 /*
  * Return number of free blocks in the log. Must be called under j_state_lock.
  */
-- 
2.16.4

