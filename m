From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] jbd2: don't leak memory if setting up journal fails
Date: Tue, 14 Mar 2017 21:19:55 -0700
Message-ID: <20170315041955.30687-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36265 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdCOEV0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Mar 2017 00:21:26 -0400
Received: by mail-pf0-f193.google.com with SMTP id j5so783964pfb.3
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2017 21:21:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In journal_init_common(), if we failed to allocate the j_wbuf array, or
if we failed to create the buffer_head for the journal superblock, we
leaked the memory allocated for the revocation tables.  Fix this.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/jbd2/journal.c | 22 +++++++++++-----------
 fs/jbd2/revoke.c  |  1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index a1a359bfcc9c..5adc2fb62b0f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1125,10 +1125,8 @@ static journal_t *journal_init_common(struct block_device *bdev,
 
 	/* Set up a default-sized revoke table for the new mount. */
 	err = jbd2_journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
-	if (err) {
-		kfree(journal);
-		return NULL;
-	}
+	if (err)
+		goto err_cleanup;
 
 	spin_lock_init(&journal->j_history_lock);
 
@@ -1145,23 +1143,25 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	journal->j_wbufsize = n;
 	journal->j_wbuf = kmalloc_array(n, sizeof(struct buffer_head *),
 					GFP_KERNEL);
-	if (!journal->j_wbuf) {
-		kfree(journal);
-		return NULL;
-	}
+	if (!journal->j_wbuf)
+		goto err_cleanup;
 
 	bh = getblk_unmovable(journal->j_dev, start, journal->j_blocksize);
 	if (!bh) {
 		pr_err("%s: Cannot get buffer for journal superblock\n",
 			__func__);
-		kfree(journal->j_wbuf);
-		kfree(journal);
-		return NULL;
+		goto err_cleanup;
 	}
 	journal->j_sb_buffer = bh;
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
 
 	return journal;
+
+err_cleanup:
+	kfree(journal->j_wbuf);
+	jbd2_journal_destroy_revoke(journal);
+	kfree(journal);
+	return NULL;
 }
 
 /* jbd2_journal_init_dev and jbd2_journal_init_inode:
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index cfc38b552118..f9aefcda5854 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -280,6 +280,7 @@ int jbd2_journal_init_revoke(journal_t *journal, int hash_size)
 
 fail1:
 	jbd2_journal_destroy_revoke_table(journal->j_revoke_table[0]);
+	journal->j_revoke_table[0] = NULL;
 fail0:
 	return -ENOMEM;
 }
-- 
2.12.0
