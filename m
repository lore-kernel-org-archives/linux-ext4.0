Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD59C282D4
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 06:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87A1A20989
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 06:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfA3GqB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jan 2019 01:46:01 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3241 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727617AbfA3GqB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 30 Jan 2019 01:46:01 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B73AF2FF821BF9C7D08B;
        Wed, 30 Jan 2019 14:45:58 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.408.0; Wed, 30 Jan 2019
 14:45:52 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH v4 1/4] jbd2: make sure dirty flag is cleared while revorking a buffer which belongs to older transaction
Date:   Wed, 30 Jan 2019 14:49:37 +0800
Message-ID: <1548830980-29482-2-git-send-email-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548830980-29482-1-git-send-email-yi.zhang@huawei.com>
References: <1548830980-29482-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Now, we capture a data corruption problem on ext4 while we're truncating
an extent index block. Imaging that if we are revoking a buffer which
has been journaled by the committing transaction, the buffer's jbddirty
flag will not be cleared in jbd2_journal_forget(), so the commit code
will set the buffer dirty flag again after refile the buffer.

fsx                               kjournald2
                                  jbd2_journal_commit_transaction
jbd2_journal_revoke                commit phase 1~5...
 jbd2_journal_forget
   belongs to older transaction    commit phase 6
   jbddirty not clear               __jbd2_journal_refile_buffer
                                     __jbd2_journal_unfile_buffer
                                      test_clear_buffer_jbddirty
                                       mark_buffer_dirty

Finally, if the freed extent index block was allocated again as data
block by some other files, it may corrupt the file data after writing
cached pages later, such as during unmount time. (In general,
clean_bdev_aliases() related helpers should be invoked after
re-allocation to prevent the above corruption, but unfortunately we
missed it when zeroout the head of extra extent blocks in
ext4_ext_handle_unwritten_extents()).

This patch mark buffer as freed and set j_next_transaction to the new
transaction when it already belongs to the committing transaction in
jbd2_journal_forget(), so that commit code knows it should clear dirty
bits when it is done with the buffer.

This problem can be reproduced by xfstests generic/455 easily with
seeds (3246 3247 3248 3249).

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
---
 fs/jbd2/transaction.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index f07f006..f0d8dab 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1609,14 +1609,21 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 		/* However, if the buffer is still owned by a prior
 		 * (committing) transaction, we can't drop it yet... */
 		JBUFFER_TRACE(jh, "belongs to older transaction");
-		/* ... but we CAN drop it from the new transaction if we
-		 * have also modified it since the original commit. */
+		/* ... but we CAN drop it from the new transaction through
+		 * marking the buffer as freed and set j_next_transaction to
+		 * the new transaction, so that not only the commit code
+		 * knows it should clear dirty bits when it is done with the
+		 * buffer, but also the buffer can be checkpointed only
+		 * after the new transaction commits. */
 
-		if (jh->b_next_transaction) {
-			J_ASSERT(jh->b_next_transaction == transaction);
+		set_buffer_freed(bh);
+
+		if (!jh->b_next_transaction) {
 			spin_lock(&journal->j_list_lock);
-			jh->b_next_transaction = NULL;
+			jh->b_next_transaction = transaction;
 			spin_unlock(&journal->j_list_lock);
+		} else {
+			J_ASSERT(jh->b_next_transaction == transaction);
 
 			/*
 			 * only drop a reference if this transaction modified
-- 
2.7.4

