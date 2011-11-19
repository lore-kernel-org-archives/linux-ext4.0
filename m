From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2] jbd: clear revoked flag on buffers before a new transaction started
Date: Sat, 19 Nov 2011 17:34:29 +0800
Message-ID: <1321695269-3319-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35322 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1KSMIG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 07:08:06 -0500
Received: by iage36 with SMTP id e36so4841730iag.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Nov 2011 04:08:05 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, we clear revoked flag only when a block is reused.  However,
this can tigger a false journal error.  Consider a situation when a block
is used as a meta block and is deleted(revoked) in ordered mode, then the
block is allocated as a data block to a file.  At this moment, user changes
the file's journal mode from ordered to journaled and truncates the file.
The block will be considered re-revoked by journal because it has revoked
flag still pending from the last transaction and an assertion triggers.

We fix the problem by keeping the revoked status more uptodate - we clear
revoked flag when switching revoke tables to reflect there is no revoked
buffers in current transaction any more.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/jbd/commit.c     |    6 ++++++
 fs/jbd/revoke.c     |   34 ++++++++++++++++++++++++++++++++++
 include/linux/jbd.h |    1 +
 3 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 8799207..f2b9a57 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -392,6 +392,12 @@ void journal_commit_transaction(journal_t *journal)
 	jbd_debug (3, "JBD: commit phase 1\n");
 
 	/*
+	 * Clear revoked flag to reflect there is no revoked buffers
+	 * in the next transaction which is going to be started.
+	 */
+	journal_clear_buffer_revoked_flags(journal);
+
+	/*
 	 * Switch to a new revoke table.
 	 */
 	journal_switch_revoke_table(journal);
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 034eb82..501d363 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -47,6 +47,10 @@
  *   overwriting the new data.  We don't even need to clear the revoke
  *   bit here.
  *
+ * We cache revoke status of a buffer in the current transaction in b_states
+ * bits.  As the name says, revokevalid flag indicates that the cached revoke
+ * status of a buffer is valid and we can rely on the cached status.
+ *
  * Revoke information on buffers is a tri-state value:
  *
  * RevokeValid clear:	no cached revoke status, need to look it up
@@ -474,6 +478,36 @@ int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	return did_revoke;
 }
 
+/*
+ * journal_clear_revoked_flag clears revoked flag of buffers in
+ * revoke table to reflect there is no revoked buffers in the next
+ * transaction which is going to be started.
+ */
+void journal_clear_buffer_revoked_flags(journal_t *journal)
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
index 0f9f0b6..5aa964e 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -918,6 +918,7 @@ extern int	journal_set_revoke(journal_t *, unsigned int, tid_t);
 extern int	journal_test_revoke(journal_t *, unsigned int, tid_t);
 extern void	journal_clear_revoke(journal_t *);
 extern void	journal_switch_revoke_table(journal_t *journal);
+extern void	journal_clear_buffer_revoked_flags(journal_t *journal);
 
 /*
  * The log thread user interface:
-- 
1.7.5.1

