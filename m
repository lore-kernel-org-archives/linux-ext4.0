From: Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 01/18] jbd2: Add buffer triggers
Date: Tue,  9 Dec 2008 17:09:38 -0800
Message-ID: <1228871395-10273-2-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: mfasheh@suse.com, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
To: ocfs2-devel@oss.oracle.com
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

Filesystems often to do compute intensive operation on some
metadata.  If this operation is repeated many times, it can be very
expensive.  It would be much nicer if the operation could be performed
once before a buffer goes to disk.

This adds triggers to jbd2 buffer heads.  Just before writing a metadata
buffer to the journal, jbd2 will optionally call a commit trigger associated
with the buffer.  If the journal is aborted, an abort trigger will be
called on any dirty buffers as they are dropped from pending
transactions.

ocfs2 will use this feature.

Initially I tried to come up with a more generic trigger that could be
used for non-buffer-related events like transaction completion.  It
doesn't tie nicely, because the information a buffer trigger needs
(specific to a journal_head) isn't the same as what a transaction
trigger needs (specific to a tranaction_t or perhaps journal_t).  So I
implemented a buffer set, with the understanding that
journal/transaction wide triggers should be implemented separately.

There is only one trigger set allowed per buffer.  I can't think of any
reason to attach more than one set.  Contrast this with a journal or
transaction in which multiple places may want to watch the entire
transaction separately.

The trigger sets are considered static allocation from the jbd2
perspective.  ocfs2 will just have one trigger set per block type,
setting the same set on every bh of the same type.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>
---
 fs/jbd2/commit.c             |    1 +
 fs/jbd2/journal.c            |    8 ++++++++
 fs/jbd2/transaction.c        |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h         |   29 +++++++++++++++++++++++++++++
 include/linux/journal-head.h |    5 +++++
 5 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index ebc667b..2ee799a 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -509,6 +509,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		if (is_journal_aborted(journal)) {
 			clear_buffer_jbddirty(jh2bh(jh));
 			JBUFFER_TRACE(jh, "journal is aborting: refile");
+			jbd2_buffer_abort_trigger(jh);
 			jbd2_journal_refile_buffer(journal, jh);
 			/* If that was the last one, we need to clean up
 			 * any descriptor buffers which may have been
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e70d657..c5e8935 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -50,6 +50,7 @@ EXPORT_SYMBOL(jbd2_journal_unlock_updates);
 EXPORT_SYMBOL(jbd2_journal_get_write_access);
 EXPORT_SYMBOL(jbd2_journal_get_create_access);
 EXPORT_SYMBOL(jbd2_journal_get_undo_access);
+EXPORT_SYMBOL(jbd2_journal_set_triggers);
 EXPORT_SYMBOL(jbd2_journal_dirty_metadata);
 EXPORT_SYMBOL(jbd2_journal_release_buffer);
 EXPORT_SYMBOL(jbd2_journal_forget);
@@ -321,6 +322,13 @@ repeat:
 
 	mapped_data = kmap_atomic(new_page, KM_USER0);
 	/*
+	 * Fire any commit trigger.  Do this before checking for escaping,
+	 * as the trigger may modify the magic offset.  If a copy-out
+	 * happens afterwards, it will have the correct data in the buffer.
+	 */
+	jbd2_buffer_commit_trigger(jh_in, mapped_data + new_offset);
+
+	/*
 	 * Check for escaping
 	 */
 	if (*((__be32 *)(mapped_data + new_offset)) ==
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 39b7805..648624c 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -944,6 +944,48 @@ out:
 }
 
 /**
+ * void jbd2_journal_set_triggers() - Add triggers for commit writeout
+ * @bh: buffer to trigger on
+ * @type: struct jbd2_buffer_trigger_type containing the trigger(s).
+ *
+ * Set any triggers on this journal_head.
+ *
+ * Call with NULL to clear the triggers.
+ */
+void jbd2_journal_set_triggers(struct buffer_head *bh,
+			       struct jbd2_buffer_trigger_type *type)
+{
+	struct journal_head *jh = bh2jh(bh);
+
+	if (jh->b_triggers && type) {
+		WARN_ON_ONCE(jh->b_triggers != type);
+		return;
+	}
+
+	jh->b_triggers = type;
+}
+
+void jbd2_buffer_commit_trigger(struct journal_head *jh, void *mapped_data)
+{
+	struct buffer_head *bh = jh2bh(jh);
+
+	if (!jh->b_triggers || !jh->b_triggers->t_commit)
+		return;
+
+	jh->b_triggers->t_commit(jh->b_triggers, bh, mapped_data, bh->b_size);
+}
+
+void jbd2_buffer_abort_trigger(struct journal_head *jh)
+{
+	if (!jh->b_triggers || !jh->b_triggers->t_abort)
+		return;
+
+	jh->b_triggers->t_abort(jh->b_triggers, jh2bh(jh));
+}
+
+
+
+/**
  * int jbd2_journal_dirty_metadata() -  mark a buffer as containing dirty metadata
  * @handle: transaction to add buffer to.
  * @bh: buffer to mark
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index f366457..493d67a 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1008,6 +1008,33 @@ int __jbd2_journal_clean_checkpoint_list(journal_t *journal);
 int __jbd2_journal_remove_checkpoint(struct journal_head *);
 void __jbd2_journal_insert_checkpoint(struct journal_head *, transaction_t *);
 
+
+/*
+ * Triggers
+ */
+
+struct jbd2_buffer_trigger_type {
+	/*
+	 * Fired just before a buffer is written to the journal.
+	 * mapped_data is a mapped buffer that is the frozen data for
+	 * commit.
+	 */
+	void (*t_commit)(struct jbd2_buffer_trigger_type *type,
+			 struct buffer_head *bh, void *mapped_data,
+			 size_t size);
+
+	/*
+	 * Fired during journal abort for dirty buffers that will not be
+	 * committed.
+	 */
+	void (*t_abort)(struct jbd2_buffer_trigger_type *type,
+			struct buffer_head *bh);
+};
+
+extern void jbd2_buffer_commit_trigger(struct journal_head *jh,
+				       void *mapped_data);
+extern void jbd2_buffer_abort_trigger(struct journal_head *jh);
+
 /* Buffer IO */
 extern int
 jbd2_journal_write_metadata_buffer(transaction_t	  *transaction,
@@ -1046,6 +1073,8 @@ extern int	 jbd2_journal_extend (handle_t *, int nblocks);
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_undo_access(handle_t *, struct buffer_head *);
+void		 jbd2_journal_set_triggers(struct buffer_head *,
+					   struct jbd2_buffer_trigger_type *type);
 extern int	 jbd2_journal_dirty_metadata (handle_t *, struct buffer_head *);
 extern void	 jbd2_journal_release_buffer (handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_forget (handle_t *, struct buffer_head *);
diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
index bb70ebb..6e762ad 100644
--- a/include/linux/journal-head.h
+++ b/include/linux/journal-head.h
@@ -12,6 +12,8 @@
 
 typedef unsigned int		tid_t;		/* Unique transaction ID */
 typedef struct transaction_s	transaction_t;	/* Compound transaction type */
+
+
 struct buffer_head;
 
 struct journal_head {
@@ -87,6 +89,9 @@ struct journal_head {
 	 * [j_list_lock]
 	 */
 	struct journal_head *b_cpnext, *b_cpprev;
+
+	/* Trigger type */
+	struct jbd2_buffer_trigger_type *b_triggers;
 };
 
 #endif		/* JOURNAL_HEAD_H_INCLUDED */
-- 
1.5.6.5
