From: dingdinghua <dingdinghua85@gmail.com>
Subject: [PATCH] fix race bwtween write_metadata_buffer and get_write_access
Date: Thu,  9 Jul 2009 17:47:07 +0800
Message-ID: <1247132827-29614-1-git-send-email-dingdinghua85@gmail.com>
Cc: dingdinghua <dingdinghua85@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:8948 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZGIJrO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jul 2009 05:47:14 -0400
Received: by wa-out-1112.google.com with SMTP id j5so6076wah.21
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jul 2009 02:47:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At committing phase, we call jbd2_journal_write_metadata_buffer to
prepare log block's buffer_head, in this function, new_bh->b_data is set
to b_frozen_data or bh_in->b_data. We call "jbd_unlock_bh_state(bh_in)"
too early, since at this point , we haven't file bh_in to BJ_shadow
list, and we may set new_bh->b_data to bh_in->b_data, at this time,
another thread may call get write access of bh_in, modify bh_in->b_data
and dirty it. So , if new_bh->b_data is set to bh_in->b_data, the
committing transaction may flush the newly modified buffer content to
disk, preserve work done in jbd2_journal_get_write_access is useless.
jbd also has this problem.

Signed-off-by: dingdinghua <dingdinghua85@gmail.com>
---
 fs/jbd/journal.c  |   20 +++++++++++---------
 fs/jbd2/journal.c |   20 +++++++++++---------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 737f724..ff5dcb5 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -287,6 +287,7 @@ int journal_write_metadata_buffer(transaction_t *transaction,
 	struct page *new_page;
 	unsigned int new_offset;
 	struct buffer_head *bh_in = jh2bh(jh_in);
+	journal_t *journal = transaction->t_journal;
 
 	/*
 	 * The buffer really shouldn't be locked: only the current committing
@@ -300,6 +301,11 @@ int journal_write_metadata_buffer(transaction_t *transaction,
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
 	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
+	/* keep subsequent assertions sane */
+	new_bh->b_state = 0;
+	init_buffer(new_bh, NULL, NULL);
+	atomic_set(&new_bh->b_count, 1);
+	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
 
 	/*
 	 * If a new transaction has already done a buffer copy-out, then
@@ -361,14 +367,6 @@ repeat:
 		kunmap_atomic(mapped_data, KM_USER0);
 	}
 
-	/* keep subsequent assertions sane */
-	new_bh->b_state = 0;
-	init_buffer(new_bh, NULL, NULL);
-	atomic_set(&new_bh->b_count, 1);
-	jbd_unlock_bh_state(bh_in);
-
-	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
-
 	set_bh_page(new_bh, new_page, new_offset);
 	new_jh->b_transaction = NULL;
 	new_bh->b_size = jh2bh(jh_in)->b_size;
@@ -385,7 +383,11 @@ repeat:
 	 * copying is moved to the transaction's shadow queue.
 	 */
 	JBUFFER_TRACE(jh_in, "file as BJ_Shadow");
-	journal_file_buffer(jh_in, transaction, BJ_Shadow);
+	spin_lock(&journal->j_list_lock);
+	__journal_file_buffer(jh_in, transaction, BJ_Shadow);
+	spin_unlock(&journal->j_list_lock);
+	jbd_unlock_bh_state(bh_in);
+
 	JBUFFER_TRACE(new_jh, "file as BJ_IO");
 	journal_file_buffer(new_jh, transaction, BJ_IO);
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 18bfd5d..a601417 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -297,6 +297,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 	unsigned int new_offset;
 	struct buffer_head *bh_in = jh2bh(jh_in);
 	struct jbd2_buffer_trigger_type *triggers;
+	journal_t *journal = transaction->t_journal;
 
 	/*
 	 * The buffer really shouldn't be locked: only the current committing
@@ -310,6 +311,11 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
 	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
+	/* keep subsequent assertions sane */
+	new_bh->b_state = 0;
+	init_buffer(new_bh, NULL, NULL);
+	atomic_set(&new_bh->b_count, 1);
+	new_jh = jbd2_journal_add_journal_head(new_bh);	/* This sleeps */
 
 	/*
 	 * If a new transaction has already done a buffer copy-out, then
@@ -388,14 +394,6 @@ repeat:
 		kunmap_atomic(mapped_data, KM_USER0);
 	}
 
-	/* keep subsequent assertions sane */
-	new_bh->b_state = 0;
-	init_buffer(new_bh, NULL, NULL);
-	atomic_set(&new_bh->b_count, 1);
-	jbd_unlock_bh_state(bh_in);
-
-	new_jh = jbd2_journal_add_journal_head(new_bh);	/* This sleeps */
