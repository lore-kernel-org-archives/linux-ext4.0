From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 04/28] ext4: Add new tracepoint for jbd2_cleanup_journal_tail
Date: Tue,  2 Mar 2010 13:18:21 -0500
Message-ID: <1267553925-6308-5-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43019 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab0CBSSu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:50 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/checkpoint.c        |    1 +
 include/trace/events/jbd2.h |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 8868493..30beb11 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -507,6 +507,7 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 	if (blocknr < journal->j_tail)
 		freed = freed + journal->j_last - journal->j_first;
 
+	trace_jbd2_cleanup_journal_tail(journal, first_tid, blocknr, freed);
 	jbd_debug(1,
 		  "Cleaning journal tail from %d to %d (offset %lu), "
 		  "freeing %lu\n",
diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 96b370a..bf16545 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -199,6 +199,34 @@ TRACE_EVENT(jbd2_checkpoint_stats,
 		  __entry->forced_to_close, __entry->written, __entry->dropped)
 );
 
+TRACE_EVENT(jbd2_cleanup_journal_tail,
+
+	TP_PROTO(journal_t *journal, tid_t first_tid,
+		 unsigned long block_nr, unsigned long freed),
+
+	TP_ARGS(journal, first_tid, block_nr, freed),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	tid_t,	tail_sequence		)
+		__field(	tid_t,	first_tid		)
+		__field(unsigned long,	block_nr		)
+		__field(unsigned long,	freed			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->tail_sequence	= journal->j_tail_sequence;
+		__entry->first_tid	= first_tid;
+		__entry->block_nr	= block_nr;
+		__entry->freed		= freed;
+	),
+
+	TP_printk("dev %s from %u to %u offset %lu freed %lu",
+		  jbd2_dev_to_name(__entry->dev), __entry->tail_sequence,
+		  __entry->first_tid, __entry->block_nr, __entry->freed)
+);
+
 #endif /* _TRACE_JBD2_H */
 
 /* This part must be outside protection */
-- 
1.6.6.1.1.g974db.dirty

