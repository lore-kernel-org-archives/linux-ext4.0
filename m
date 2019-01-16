Return-Path: <SRS0=njA7=PY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733118AbfAPNey (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Jan 2019 08:34:54 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <miaoxie@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v2] jbd2: make sure dirty flag is cleared while revorking a buffer which belongs to older transaction
Date: Wed, 16 Jan 2019 21:38:23 +0800
Message-ID: <1547645903-57295-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
block by some other files, it may corrupt the file data when writing
cached pages later, such as during umount time.

This patch mark buffer as freed and set j_next_transaction to the new
transaction when it already belongs to the committing transaction in
jbd2_journal_forget(), so that commit code knows it should clear dirty
bits when it is done with the buffer.

This problem can be reproduced by xfstests generic/455 easily with
seeds (3246 3247 3248 3249).

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Cc: stable@vger.kernel.org
---
 fs/jbd2/transaction.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index f07f006..f7f9647 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1609,14 +1609,19 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 		/* However, if the buffer is still owned by a prior
 		 * (committing) transaction, we can't drop it yet... */
 		JBUFFER_TRACE(jh, "belongs to older transaction");
-		/* ... but we CAN drop it from the new transaction if we
-		 * have also modified it since the original commit. */
+		/* ... but we CAN drop it from the new transaction, mark
+		 * buffer as freed and set j_next_transaction to the new
+		 * transaction so that commit code knows it should clear
+		 * dirty bits when it is done with the buffer. */
 
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
