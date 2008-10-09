From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 33/42] ext4: Add debugging markers that can be used by systemtap
Date: Thu,  9 Oct 2008 00:05:51 -0400
Message-ID: <1223525160-9887-34-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
 <1223525160-9887-19-git-send-email-tytso@mit.edu>
 <1223525160-9887-20-git-send-email-tytso@mit.edu>
 <1223525160-9887-21-git-send-email-tytso@mit.edu>
 <1223525160-9887-22-git-send-email-tytso@mit.edu>
 <1223525160-9887-23-git-send-email-tytso@mit.edu>
 <1223525160-9887-24-git-send-email-tytso@mit.edu>
 <1223525160-9887-25-git-send-email-tytso@mit.edu>
 <1223525160-9887-26-git-send-email-tytso@mit.edu>
 <1223525160-9887-27-git-send-email-tytso@mit.edu>
 <1223525160-9887-28-git-send-email-tytso@mit.edu>
 <1223525160-9887-29-git-send-email-tytso@mit.edu>
 <1223525160-9887-30-git-send-email-tytso@mit.edu>
 <1223525160-9887-31-git-send-email-tytso@mit.edu>
 <1223525160-9887-32-git-send-email-tytso@mit.edu>
 <1223525160-9887-33-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44268 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758848AbYJIEaS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:30:18 -0400
In-Reply-To: <1223525160-9887-33-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This debugging markers are designed to debug problems such as the
random filesystem latency problems reported by Arjan.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/fsync.c      |    5 +++++
 fs/ext4/super.c      |    2 ++
 fs/jbd2/checkpoint.c |    3 +++
 fs/jbd2/commit.c     |    6 ++++++
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index c37d1e8..5afe437 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -28,6 +28,7 @@
 #include <linux/writeback.h>
 #include <linux/jbd2.h>
 #include <linux/blkdev.h>
+#include <linux/marker.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -51,6 +52,10 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
+	trace_mark(ext4_sync_file, "dev %s datasync %d ino %ld parent %ld",
+		   inode->i_sb->s_id, datasync, inode->i_ino,
+		   dentry->d_parent->d_inode->i_ino);
+
 	/*
 	 * data=writeback:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dfcd41f..9c02146 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -35,6 +35,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
+#include <linux/marker.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
 #include <asm/uaccess.h>
@@ -2951,6 +2952,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 {
 	tid_t target;
 
+	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
 	sb->s_dirt = 0;
 	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
 		if (wait)
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index af4651b..42895d3 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -20,6 +20,7 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
+#include <linux/marker.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 
@@ -328,6 +329,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 	 * journal straight away.
 	 */
 	result = jbd2_cleanup_journal_tail(journal);
+	trace_mark(jbd2_checkpoint, "dev %s need_checkpoint %d",
+		   journal->j_devname, result);
 	jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
 	if (result <= 0)
 		return result;
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index b091e53..e91f051 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -16,6 +16,7 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
+#include <linux/marker.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -368,6 +369,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	commit_transaction = journal->j_running_transaction;
 	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 
+	trace_mark(jbd2_start_commit, "dev %s transaction %d",
+		   journal->j_devname, commit_transaction->t_tid);
 	jbd_debug(1, "JBD: starting commit of transaction %d\n",
 			commit_transaction->t_tid);
 
@@ -985,6 +988,9 @@ restart_loop:
 	}
 	spin_unlock(&journal->j_list_lock);
 
+	trace_mark(jbd2_end_commit, "dev %s transaction %d head %d",
+		   journal->j_devname, commit_transaction->t_tid,
+		   journal->j_tail_sequence);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
 
-- 
1.5.6.1.205.ge2c7.dirty

