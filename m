From: Joel Becker <Joel.Becker@oracle.com>
Subject: [PATCH] [RFC] jbd2: Add buffer triggers
Date: Wed, 17 Sep 2008 16:26:30 -0700
Message-ID: <20080917232629.GB20752@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:20996 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYIQX1J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2008 19:27:09 -0400
Received: from agmgw2.us.oracle.com (agmgw2.us.oracle.com [152.68.180.213])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id m8HNR5OD016700
	for <linux-ext4@vger.kernel.org>; Wed, 17 Sep 2008 18:27:06 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
---
 fs/jbd2/commit.c             |    1 +
 fs/jbd2/journal.c            |   11 +++++++++++
 fs/jbd2/transaction.c        |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h         |   29 +++++++++++++++++++++++++++++
 include/linux/journal-head.h |    5 +++++
 5 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f2ad061..07fef48 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -509,6 +509,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 
 		if (is_journal_aborted(journal)) {
 			JBUFFER_TRACE(jh, "journal is aborting: refile");
+			jbd2_buffer_abort_trigger(jh);
 			jbd2_journal_refile_buffer(journal, jh);
 			/* If that was the last one, we need to clean up
 			 * any descriptor buffers which may have been
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 18d3063..23dbd59 100644
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
@@ -354,6 +355,16 @@ repeat:
 		done_copy_out = 1;
 	}
 
+	/* We have the actual buffer to go out, fire any commit trigger */
+	/* XXX Checking trigger pointers here so as to skip kmap when
+	 * empty */
+	if (jh_in->b_triggers && jh_in->b_triggers->t_commit) {
+		mapped_data = kmap_atomic(new_page, KM_USER0);
+
+		jbd2_buffer_commit_trigger(jh_in, mapped_data + new_offset);
+		kunmap_atomic(mapped_data, KM_USER0);
+	}
+
 	/*
 	 * Did we need to do an escaping?  Now we've done all the
 	 * copying, we can finally do so.
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index e5d5405..e975afa 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -943,6 +943,48 @@ out:
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
index 3dd2090..032af18 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -994,6 +994,33 @@ int __jbd2_journal_clean_checkpoint_list(journal_t *journal);
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
@@ -1032,6 +1059,8 @@ extern int	 jbd2_journal_extend (handle_t *, int nblocks);
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_undo_access(handle_t *, struct buffer_head *);
+void		 jbd2_journal_set_triggers(struct buffer_head *,
+					   struct jbd2_buffer_trigger_type *type);
 extern int	 jbd2_journal_dirty_metadata (handle_t *, struct buffer_head *);
 extern void	 jbd2_journal_release_buffer (handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_forget (handle_t *, struct buffer_head *);
diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
index 8a62d1e..087a1c2 100644
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
1.5.6.3


-- 

None of our men are "experts."  We have most unfortunately found
it necessary to get rid of a man as soon as he thinks himself an
expert -- because no one ever considers himself expert if he really
knows his job.  A man who knows a job sees so much more to be done
than he has done, that he is always pressing forward and never
gives up an instant of thought to how good and how efficient he is.
Thinking always ahead, thinking always of trying to do more, brings
a state of mind in which nothing is impossible. The moment one gets
into the "expert" state of mind a great number of things become
impossible.
	- From Henry Ford Sr., "My Life and Work"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
