From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] jbd2:[trivial] rename obsoleted msg JBD->JBD2
Date: Thu, 21 Nov 2013 15:29:44 +0400
Message-ID: <1385033384-20350-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:18145 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab3KULaM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Nov 2013 06:30:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rename performed via: perl -pi -e 's/JBD:/JBD2:/g' fs/jbd2/*.c

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/jbd2/journal.c     |   10 +++++-----
 fs/jbd2/recovery.c    |    2 +-
 fs/jbd2/transaction.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5203264..de35b53 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1527,13 +1527,13 @@ static int journal_get_superblock(journal_t *journal)
 	if (JBD2_HAS_COMPAT_FEATURE(journal, JBD2_FEATURE_COMPAT_CHECKSUM) &&
 	    JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2)) {
 		/* Can't have checksum v1 and v2 on at the same time! */
-		printk(KERN_ERR "JBD: Can't enable checksumming v1 and v2 "
+		printk(KERN_ERR "JBD2: Can't enable checksumming v1 and v2 "
 		       "at the same time!\n");
 		goto out;
 	}
 
 	if (!jbd2_verify_csum_type(journal, sb)) {
-		printk(KERN_ERR "JBD: Unknown checksum type\n");
+		printk(KERN_ERR "JBD2: Unknown checksum type\n");
 		goto out;
 	}
 
@@ -1541,7 +1541,7 @@ static int journal_get_superblock(journal_t *journal)
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2)) {
 		journal->j_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
 		if (IS_ERR(journal->j_chksum_driver)) {
-			printk(KERN_ERR "JBD: Cannot load crc32c driver.\n");
+			printk(KERN_ERR "JBD2: Cannot load crc32c driver.\n");
 			err = PTR_ERR(journal->j_chksum_driver);
 			journal->j_chksum_driver = NULL;
 			goto out;
@@ -1550,7 +1550,7 @@ static int journal_get_superblock(journal_t *journal)
 
 	/* Check superblock checksum */
 	if (!jbd2_superblock_csum_verify(journal, sb)) {
-		printk(KERN_ERR "JBD: journal checksum error\n");
+		printk(KERN_ERR "JBD2: journal checksum error\n");
 		goto out;
 	}
 
@@ -1836,7 +1836,7 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 			journal->j_chksum_driver = crypto_alloc_shash("crc32c",
 								      0, 0);
 			if (IS_ERR(journal->j_chksum_driver)) {
-				printk(KERN_ERR "JBD: Cannot load crc32c "
+				printk(KERN_ERR "JBD2: Cannot load crc32c "
 				       "driver.\n");
 				journal->j_chksum_driver = NULL;
 				return 0;
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 3929c50..3b6bb19 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -594,7 +594,7 @@ static int do_one_pass(journal_t *journal,
 						be32_to_cpu(tmp->h_sequence))) {
 						brelse(obh);
 						success = -EIO;
-						printk(KERN_ERR "JBD: Invalid "
+						printk(KERN_ERR "JBD2: Invalid "
 						       "checksum recovering "
 						       "block %llu in log\n",
 						       blocknr);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 7aa9a32..68ebfe1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1305,7 +1305,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 		JBUFFER_TRACE(jh, "fastpath");
 		if (unlikely(jh->b_transaction !=
 			     journal->j_running_transaction)) {
-			printk(KERN_EMERG "JBD: %s: "
+			printk(KERN_EMERG "JBD2: %s: "
 			       "jh->b_transaction (%llu, %p, %u) != "
 			       "journal->j_running_transaction (%p, %u)",
 			       journal->j_devname,
@@ -1332,7 +1332,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 		JBUFFER_TRACE(jh, "already on other transaction");
 		if (unlikely(jh->b_transaction !=
 			     journal->j_committing_transaction)) {
-			printk(KERN_EMERG "JBD: %s: "
+			printk(KERN_EMERG "JBD2: %s: "
 			       "jh->b_transaction (%llu, %p, %u) != "
 			       "journal->j_committing_transaction (%p, %u)",
 			       journal->j_devname,
@@ -1345,7 +1345,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 			ret = -EINVAL;
 		}
 		if (unlikely(jh->b_next_transaction != transaction)) {
-			printk(KERN_EMERG "JBD: %s: "
+			printk(KERN_EMERG "JBD2: %s: "
 			       "jh->b_next_transaction (%llu, %p, %u) != "
 			       "transaction (%p, %u)",
 			       journal->j_devname,
-- 
1.7.1

