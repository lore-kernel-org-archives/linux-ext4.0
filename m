From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 5/5] jbd2: clear revoked flag on buffers before a new transaction started
Date: Tue, 15 Nov 2011 16:07:54 +0800
Message-ID: <1321344474-14707-5-git-send-email-xiaoqiangnk@gmail.com>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1KOKcj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 05:32:39 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so8283497iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 02:32:39 -0800 (PST)
In-Reply-To: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
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
 fs/ext4/ext4_jbd2.c  |    5 +++++
 fs/jbd2/commit.c     |    5 +++++
 fs/jbd2/revoke.c     |   28 ++++++++++++++++++++++++++++
 include/linux/jbd2.h |    1 +
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index aca1790..c69baa0 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -47,6 +47,11 @@ int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
 		  "data mode %x\n",
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
+	if (bh)
+		printk("forgetting bh %p: is_metadata = %d, mode %o, "
+		  "data mode %x\n",
+		  bh, is_metadata, inode->i_mode,
+		  test_opt(inode->i_sb, DATA_FLAGS));
 
 	/* In the no journal case, we can just do a bforget and return */
 	if (!ext4_handle_valid(handle)) {
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 264f0bb..ec63df5 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -430,6 +430,11 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	jbd_debug (3, "JBD: commit phase 1\n");
 
 	/*
+	 * Clear revoked flag.
+	 */
+	journal_clear_revoked_flag(journal);
+
+	/*
 	 * Switch to a new revoke table.
 	 */
 	jbd2_journal_switch_revoke_table(journal);
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 1b67105..dca50c6 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -474,6 +474,34 @@ int jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	return did_revoke;
 }
 
+/* journal_clear_revoked_flag clears revoked flag of buffers in
+ * revoke table.
+ */
+void journal_clear_revoked_flag(journal_t *journal)
+{
+	struct jbd2_revoke_table_s *revoke = journal->j_revoke;
+	int i = 0;
+
+	for (i = 0; i < revoke->hash_size; i++) {
+		struct list_head *hash_list;
+		struct list_head *list_entry;
+		hash_list = &revoke->hash_table[i];
+
+		list_for_each(list_entry, hash_list) {
+			struct jbd2_revoke_record_s *record;
+			struct buffer_head *bh;
+			record = (struct jbd2_revoke_record_s *)list_entry;
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
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e44d114..4891a4d 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1156,6 +1156,7 @@ extern int	jbd2_journal_set_revoke(journal_t *, unsigned long long, tid_t);
 extern int	jbd2_journal_test_revoke(journal_t *, unsigned long long, tid_t);
 extern void	jbd2_journal_clear_revoke(journal_t *);
 extern void	jbd2_journal_switch_revoke_table(journal_t *journal);
+extern void	journal_clear_revoked_flag(journal_t *journal);
 
 /*
  * The log thread user interface:
-- 
1.7.5.1

