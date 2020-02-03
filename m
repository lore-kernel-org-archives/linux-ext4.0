Return-Path: <SRS0=4bn4=3X=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCD8C33CAC
	for <linux-ext4@archiver.kernel.org>; Mon,  3 Feb 2020 14:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B96FB20CC7
	for <linux-ext4@archiver.kernel.org>; Mon,  3 Feb 2020 14:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgBCOGT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 3 Feb 2020 09:06:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:55192 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728362AbgBCOGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Feb 2020 09:06:16 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 14AEF56E0498A6092F79;
        Mon,  3 Feb 2020 22:06:12 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 3 Feb 2020
 22:06:02 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <jack@suse.cz>, <tytso@mit.edu>
CC:     <linux-ext4@vger.kernel.org>, <yi.zhang@huawei.com>,
        <luoshijie1@huawei.com>, <zhangxiaoxu5@huawei.com>
Subject: [PATCH 1/2] jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()
Date:   Mon, 3 Feb 2020 22:04:57 +0800
Message-ID: <20200203140458.37397-2-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200203140458.37397-1-yi.zhang@huawei.com>
References: <20200203140458.37397-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

There is no need to delay the clearing of b_modified flag to the
transaction committing time when unmapping the journalled buffer, so
just move it to the journal_unmap_buffer().

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/jbd2/commit.c      | 43 +++++++++++++++----------------------------
 fs/jbd2/transaction.c | 24 +++++++++++-------------
 2 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2494095e0340..6396fe70085b 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -976,34 +976,21 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		 * it. */
 
 		/*
-		* A buffer which has been freed while still being journaled by
-		* a previous transaction.
-		*/
-		if (buffer_freed(bh)) {
-			/*
-			 * If the running transaction is the one containing
-			 * "add to orphan" operation (b_next_transaction !=
-			 * NULL), we have to wait for that transaction to
-			 * commit before we can really get rid of the buffer.
-			 * So just clear b_modified to not confuse transaction
-			 * credit accounting and refile the buffer to
-			 * BJ_Forget of the running transaction. If the just
-			 * committed transaction contains "add to orphan"
-			 * operation, we can completely invalidate the buffer
-			 * now. We are rather through in that since the
-			 * buffer may be still accessible when blocksize <
-			 * pagesize and it is attached to the last partial
-			 * page.
-			 */
-			jh->b_modified = 0;
-			if (!jh->b_next_transaction) {
-				clear_buffer_freed(bh);
-				clear_buffer_jbddirty(bh);
-				clear_buffer_mapped(bh);
-				clear_buffer_new(bh);
-				clear_buffer_req(bh);
-				bh->b_bdev = NULL;
-			}
+		 * A buffer which has been freed while still being journaled
+		 * by a previous transaction, refile the buffer to BJ_Forget of
+		 * the running transaction. If the just committed transaction
+		 * contains "add to orphan" operation, we can completely
+		 * invalidate the buffer now. We are rather through in that
+		 * since the buffer may be still accessible when blocksize <
+		 * pagesize and it is attached to the last partial page.
+		 */
+		if (buffer_freed(bh) && !jh->b_next_transaction) {
+			clear_buffer_freed(bh);
+			clear_buffer_jbddirty(bh);
+			clear_buffer_mapped(bh);
+			clear_buffer_new(bh);
+			clear_buffer_req(bh);
+			bh->b_bdev = NULL;
 		}
 
 		if (buffer_jbddirty(bh)) {
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index e77a5a0b4e46..a479cbf8ae54 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2337,11 +2337,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 		set_buffer_freed(bh);
 		if (journal->j_running_transaction && buffer_jbddirty(bh))
 			jh->b_next_transaction = journal->j_running_transaction;
-		spin_unlock(&journal->j_list_lock);
-		spin_unlock(&jh->b_state_lock);
-		write_unlock(&journal->j_state_lock);
-		jbd2_journal_put_journal_head(jh);
-		return 0;
+		may_free = 0;
 	} else {
 		/* Good, the buffer belongs to the running transaction.
 		 * We are writing our own transaction's data, not any
@@ -2369,14 +2365,16 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 	write_unlock(&journal->j_state_lock);
 	jbd2_journal_put_journal_head(jh);
 zap_buffer_unlocked:
-	clear_buffer_dirty(bh);
-	J_ASSERT_BH(bh, !buffer_jbddirty(bh));
-	clear_buffer_mapped(bh);
-	clear_buffer_req(bh);
-	clear_buffer_new(bh);
-	clear_buffer_delay(bh);
-	clear_buffer_unwritten(bh);
-	bh->b_bdev = NULL;
+	if (!buffer_freed(bh)) {
+		clear_buffer_dirty(bh);
+		J_ASSERT_BH(bh, !buffer_jbddirty(bh));
+		clear_buffer_mapped(bh);
+		clear_buffer_req(bh);
+		clear_buffer_new(bh);
+		clear_buffer_delay(bh);
+		clear_buffer_unwritten(bh);
+		bh->b_bdev = NULL;
+	}
 	return may_free;
 }
 
-- 
2.17.2

