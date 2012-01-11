From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/6] jbd2: __jbd2_journal_temp_unlink_buffer() is static
Date: Wed, 11 Jan 2012 01:31:09 +0100
Message-ID: <1326241872-20142-4-git-send-email-jack@suse.cz>
References: <1326241872-20142-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab2AKAb2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 19:31:28 -0500
In-Reply-To: <1326241872-20142-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a0e41a4..acd08be 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1548,9 +1548,9 @@ __blist_del_buffer(struct journal_head **list, struct journal_head *jh)
  * of these pointers, it could go bad.  Generally the caller needs to re-read
  * the pointer from the transaction_t.
  *
- * Called under j_list_lock.  The journal may not be locked.
+ * Called under j_list_lock.
  */
-void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
+static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
 {
 	struct journal_head **list = NULL;
 	transaction_t *transaction;
-- 
1.7.1

