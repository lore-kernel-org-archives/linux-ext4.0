From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2] jbd: clear revoked flag on buffers before a new transaction started
Date: Tue, 15 Nov 2011 16:02:31 +0800
Message-ID: <1321344152-13033-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61299 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1KOK1W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 05:27:22 -0500
Received: by yenq3 with SMTP id q3so439984yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 02:27:21 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A revoked block in a transaction means the block is deleted by filesystem
in the transaction.  If the block is reused in the same transaction, we
need to cancel revoke status of the block.  We also should prohibit a block
from being revoked more than once in a transaction.  So we need to look up
the revoke table to check if a given block is revoked, to acceletate the
looking up, jbd/jbd2 use revoked flag to cache status of a block.

Ok, we should clear revoked flag once the transaction is not running. Because
the revoking and cancelling revoke operate on a running transaction. Once
a transaction is non-running, revoked flag is useless.

Without this patch, the following case triggers a false journal error.
Given that a block is used as a meta block and is deleted(revoked) in ordered
mode, then the block is allocated as a data block to a file.  Up to now,
user changes the file's journal mode from ordered to journaled, then truncates
the file.  The block will be considered re-revoked by journal because it
has revoked flag in last transaction.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/jbd/commit.c     |    5 +++++
 fs/jbd/revoke.c     |   28 ++++++++++++++++++++++++++++
 include/linux/jbd.h |    1 +
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 8799207..075b7e8 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -392,6 +392,11 @@ void journal_commit_transaction(journal_t *journal)
 	jbd_debug (3, "JBD: commit phase 1\n");
 
 	/*
+	 * Clear revoked flag.
+	 */
+	journal_clear_revoked_flag(journal);
+
+	/*
 	 * Switch to a new revoke table.
 	 */
 	journal_switch_revoke_table(journal);
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 034eb82..cf73b67 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -474,6 +474,34 @@ int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	return did_revoke;
 }
 
+/* journal_clear_revoked_flag clears revoked flag of buffers in
+ * revoke table.
+ */
+void journal_clear_revoked_flag(journal_t *journal)
+{
+	struct jbd_revoke_table_s *revoke = journal->j_revoke;
+	int i = 0;
+
+	for (i = 0; i < revoke->hash_size; i++) {
+		struct list_head *hash_list;
+		struct list_head *list_entry;
+		hash_list = &revoke->hash_table[i];
+
+		list_for_each(list_entry, hash_list) {
+			struct jbd_revoke_record_s *record;
+			struct buffer_head *bh;
+			record = (struct jbd_revoke_record_s *)list_entry;
+			bh = __find_get_block(journal->j_fs_dev,
+					      record->blocknr,
+					      journal->j_blocksize);
+			if (bh) {
+				clear_buffer_revoked(bh);
+				__brelse(bh);
+			}
+		}
+	}
+}
+
 /* journal_switch_revoke table select j_revoke for next transaction
  * we do not want to suspend any processing until all revokes are
  * written -bzzz
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 0f9f0b6..de59ac0 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -918,6 +918,7 @@ extern int	journal_set_revoke(journal_t *, unsigned int, tid_t);
 extern int	journal_test_revoke(journal_t *, unsigned int, tid_t);
 extern void	journal_clear_revoke(journal_t *);
 extern void	journal_switch_revoke_table(journal_t *journal);
+extern void	journal_clear_revoked_flag(journal_t *journal);
 
 /*
  * The log thread user interface:
-- 
1.7.5.1

