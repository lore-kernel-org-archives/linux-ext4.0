From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] e2fsck: use specific CRC and corruption errors in journal recovery
Date: Fri, 15 Apr 2016 21:13:43 -0400
Message-ID: <1460769225-31398-2-git-send-email-tytso@mit.edu>
References: <1460769225-31398-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34962 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbcDPBNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 21:13:49 -0400
In-Reply-To: <1460769225-31398-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sync up with kernel commit 6a797d27: "ext4: call out CRC and
corruption errors with specific error codes".

This allows us to distinguish between CRC errors and I/O errors.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/jfs_user.h | 7 +++++++
 e2fsck/recovery.c | 8 ++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index be81f43..f46bb1e 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -181,6 +181,13 @@ extern e2fsck_t e2fsck_global_ctx;  /* Try your very best not to use this! */
 
 #endif /* DEBUGFS */
 
+#ifndef EFSBADCRC
+#define EFSBADCRC	EBADMSG		/* Bad CRC detected */
+#endif
+#ifndef EFSCORRUPTED
+#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
+#endif
+
 /* recovery.c */
 extern int	journal_recover    (journal_t *journal);
 extern int	journal_skip_recovery (journal_t *);
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 41bda03..b828ed4 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -140,7 +140,7 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 
 	if (offset >= journal->j_maxlen) {
 		printk(KERN_ERR "JBD2: corrupted journal superblock\n");
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	err = journal_bmap(journal, offset, &blocknr);
@@ -524,7 +524,7 @@ static int do_one_pass(journal_t *journal,
 			if (descr_csum_size > 0 &&
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
-				err = -EIO;
+				err = -EFSBADCRC;
 				brelse(bh);
 				goto failed;
 			}
@@ -598,7 +598,7 @@ static int do_one_pass(journal_t *journal,
 						journal, tag, obh->b_data,
 						ext2fs_be32_to_cpu(tmp->h_sequence))) {
 						brelse(obh);
-						success = -EIO;
+						success = -EFSBADCRC;
 						printk(KERN_ERR "JBD2: Invalid "
 						       "checksum recovering "
 						       "block %llu in log\n",
@@ -844,7 +844,7 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 	rcount = ext2fs_be32_to_cpu(header->r_count);
 
 	if (!jbd2_revoke_block_csum_verify(journal, header))
-		return -EINVAL;
+		return -EFSBADCRC;
 
 	if (journal_has_csum_v2or3(journal))
 		csum_size = sizeof(struct journal_revoke_tail);
-- 
2.5.0

