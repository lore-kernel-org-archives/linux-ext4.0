From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 41/41] JBD2: use tracepoints for instrumentation
Date: Thu, 05 Mar 2009 17:48:09 -0500
Message-ID: <20090305225520.910893161@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Stephen C. Tweedie" <sct@redhat.com>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.o
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.polymtl.ca ([132.207.4.11]:37724 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758772AbZCEXha (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Mar 2009 18:37:30 -0500
Content-Disposition: inline; filename=jbd2-instrumentation-move-to-tracepoints.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Moved the jbd2 instrumentation to tracepoints. This incrases maintainability.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Stephen C. Tweedie <sct@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-ext4@vger.kernel.org
---
 fs/jbd2/checkpoint.c |    7 ++++---
 fs/jbd2/commit.c     |   12 ++++++------
 include/trace/jbd2.h |   19 +++++++++++++++++++
 3 files changed, 29 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/fs/jbd2/checkpoint.c
===================================================================
--- linux-2.6-lttng.orig/fs/jbd2/checkpoint.c	2009-01-30 11:58:01.000000000 -0500
+++ linux-2.6-lttng/fs/jbd2/checkpoint.c	2009-01-30 11:58:18.000000000 -0500
@@ -20,9 +20,11 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
-#include <linux/marker.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <trace/jbd2.h>
+
+DEFINE_TRACE(jbd2_checkpoint);
 
 /*
  * Unlink a buffer from a transaction checkpoint list.
@@ -358,8 +360,7 @@ int jbd2_log_do_checkpoint(journal_t *jo
 	 * journal straight away.
 	 */
 	result = jbd2_cleanup_journal_tail(journal);
-	trace_mark(jbd2_checkpoint, "dev %s need_checkpoint %d",
-		   journal->j_devname, result);
+	trace_jbd2_checkpoint(journal, result);
 	jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
 	if (result <= 0)
 		return result;
Index: linux-2.6-lttng/fs/jbd2/commit.c
===================================================================
--- linux-2.6-lttng.orig/fs/jbd2/commit.c	2009-01-30 11:58:01.000000000 -0500
+++ linux-2.6-lttng/fs/jbd2/commit.c	2009-01-30 12:00:21.000000000 -0500
@@ -16,7 +16,6 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
-#include <linux/marker.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -26,6 +25,10 @@
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/bio.h>
+#include <trace/jbd2.h>
+
+DEFINE_TRACE(jbd2_start_commit);
+DEFINE_TRACE(jbd2_end_commit);
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -393,8 +396,7 @@ void jbd2_journal_commit_transaction(jou
 	commit_transaction = journal->j_running_transaction;
 	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 
-	trace_mark(jbd2_start_commit, "dev %s transaction %d",
-		   journal->j_devname, commit_transaction->t_tid);
+	trace_jbd2_start_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD: starting commit of transaction %d\n",
 			commit_transaction->t_tid);
 
@@ -1045,9 +1047,7 @@ restart_loop:
 	if (journal->j_commit_callback)
 		journal->j_commit_callback(journal, commit_transaction);
 
-	trace_mark(jbd2_end_commit, "dev %s transaction %d head %d",
-		   journal->j_devname, commit_transaction->t_tid,
-		   journal->j_tail_sequence);
+	trace_jbd2_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
 	if (to_free)
Index: linux-2.6-lttng/include/trace/jbd2.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/trace/jbd2.h	2009-01-30 12:03:33.000000000 -0500
@@ -0,0 +1,19 @@
+#ifndef _TRACE_JBD2_H
+#define _TRACE_JBD2_H
+
+#include <linux/tracepoint.h>
+#include <linux/jbd2.h>
+
+DECLARE_TRACE(jbd2_checkpoint,
+	TPPROTO(journal_t *journal, int result),
+		TPARGS(journal, result));
+
+DECLARE_TRACE(jbd2_start_commit,
+	TPPROTO(journal_t *journal, transaction_t *commit_transaction),
+		TPARGS(journal, commit_transaction));
+
+DECLARE_TRACE(jbd2_end_commit,
+	TPPROTO(journal_t *journal, transaction_t *commit_transaction),
+		TPARGS(journal, commit_transaction));
+
+#endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
