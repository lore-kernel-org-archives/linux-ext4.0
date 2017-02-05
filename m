From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/7] jbd2: don't leak modified metadata buffers on an aborted journal
Date: Sun,  5 Feb 2017 02:34:25 -0500
Message-ID: <20170205073430.9109-2-tytso@mit.edu>
References: <20170205073430.9109-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34016 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752028AbdBEHef (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 5 Feb 2017 02:34:35 -0500
In-Reply-To: <20170205073430.9109-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the journal has been aborted, we shouldn't mark the underlying
buffer head as dirty, since that will cause the metadata block to get
modified.  And if the journal has been aborted, we shouldn't allow
this since it will almost certainly lead to a corrupted file system.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/jbd2/transaction.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index e1652665bd93..5e659ee08d6a 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1863,7 +1863,9 @@ static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
 
 	__blist_del_buffer(list, jh);
 	jh->b_jlist = BJ_None;
-	if (test_clear_buffer_jbddirty(bh))
+	if (transaction && is_journal_aborted(transaction->t_journal))
+		clear_buffer_jbddirty(bh);
+	else if (test_clear_buffer_jbddirty(bh))
 		mark_buffer_dirty(bh);	/* Expose it to the VM */
 }
 
-- 
2.11.0.rc0.7.gbe5a750
