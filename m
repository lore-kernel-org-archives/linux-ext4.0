From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2] jbd2: clear revoked flag on buffers before a new transaction started
Date: Sat, 19 Nov 2011 17:32:05 +0800
Message-ID: <1321695125-2237-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64766 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1KSMFo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 07:05:44 -0500
Received: by ghbz2 with SMTP id z2so1439039ghb.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Nov 2011 04:05:43 -0800 (PST)
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
 fs/jbd2/commit.c     |    6 ++++++
 fs/jbd2/revoke.c     |   34 ++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h |    1 +
 3 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 264f0bb..b4bf73f 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -430,6 +430,12 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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
 	jbd2_journal_switch_revoke_table(journal);
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 1b67105..66547de 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
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
@@ -474,6 +478,36 @@ int jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	return did_revoke;
 }
 
+/*
+ * journal_clear_revoked_flag clears revoked flag of buffers in
+ * revoke table to reflect there is no revoked buffers in the next
+ * transaction which is going to be started.
+ */
+void journal_clear_buffer_revoked_flags(journal_t *journal)
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
index e44d114..3041ee1 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1156,6 +1156,7 @@ extern int	jbd2_journal_set_revoke(journal_t *, unsigned long long, tid_t);
 extern int	jbd2_journal_test_revoke(journal_t *, unsigned long long, tid_t);
 extern void	jbd2_journal_clear_revoke(journal_t *);
 extern void	jbd2_journal_switch_revoke_table(journal_t *journal);
+extern void	journal_clear_buffer_revoked_flags(journal_t *journal);
 
 /*
  * The log thread user interface:
-- 
1.7.5.1

