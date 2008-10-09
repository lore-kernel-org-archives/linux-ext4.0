From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 25/42] ext4/jbd2: Avoid WARN() messages when failing to write to the superblock
Date: Thu,  9 Oct 2008 00:05:43 -0400
Message-ID: <1223525160-9887-26-git-send-email-tytso@mit.edu>
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
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54492 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756340AbYJIEGL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:11 -0400
In-Reply-To: <1223525160-9887-25-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes some very common warnings reported by kerneloops.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c   |   23 ++++++++++++++++++++++-
 fs/jbd2/journal.c |   27 +++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8175318..fb5766e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2810,13 +2810,34 @@ static void ext4_commit_super(struct super_block *sb,
 
 	if (!sbh)
 		return;
+	if (buffer_write_io_error(sbh)) {
+		/*
+		 * Oh, dear.  A previous attempt to write the
+		 * superblock failed.  This could happen because the
+		 * USB device was yanked out.  Or it could happen to
+		 * be a transient write error and maybe the block will
+		 * be remapped.  Nothing we can do but to retry the
+		 * write and hope for the best.
+		 */
+		printk(KERN_ERR "ext4: previous I/O error to "
+		       "superblock detected for %s.\n", sb->s_id);
+		clear_buffer_write_io_error(sbh);
+		set_buffer_uptodate(sbh);
+	}
 	es->s_wtime = cpu_to_le32(get_seconds());
 	ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext4_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
-	if (sync)
+	if (sync) {
 		sync_dirty_buffer(sbh);
+		if (buffer_write_io_error(sbh)) {
+			printk(KERN_ERR "ext4: I/O error while writing "
+			       "superblock for %s.\n", sb->s_id);
+			clear_buffer_write_io_error(sbh);
+			set_buffer_uptodate(sbh);
+		}
+	}
 }
 
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 81186a2..01c3901 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1255,6 +1255,22 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
 		goto out;
 	}
 
+	if (buffer_write_io_error(bh)) {
+		/*
+		 * Oh, dear.  A previous attempt to write the journal
+		 * superblock failed.  This could happen because the
+		 * USB device was yanked out.  Or it could happen to
+		 * be a transient write error and maybe the block will
+		 * be remapped.  Nothing we can do but to retry the
+		 * write and hope for the best.
+		 */
+		printk(KERN_ERR "JBD2: previous I/O error detected "
+		       "for journal superblock update for %s.\n",
+		       journal->j_devname);
+		clear_buffer_write_io_error(bh);
+		set_buffer_uptodate(bh);
+	}
+
 	spin_lock(&journal->j_state_lock);
 	jbd_debug(1,"JBD: updating superblock (start %ld, seq %d, errno %d)\n",
 		  journal->j_tail, journal->j_tail_sequence, journal->j_errno);
@@ -1266,9 +1282,16 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
 
 	BUFFER_TRACE(bh, "marking dirty");
 	mark_buffer_dirty(bh);
-	if (wait)
+	if (wait) {
 		sync_dirty_buffer(bh);
-	else
+		if (buffer_write_io_error(bh)) {
+			printk(KERN_ERR "JBD2: I/O error detected "
+			       "when updating journal superblock for %s.\n",
+			       journal->j_devname);
+			clear_buffer_write_io_error(bh);
+			set_buffer_uptodate(bh);
+		}
+	} else
 		ll_rw_block(SWRITE, 1, &bh);
 
 out:
-- 
1.5.6.1.205.ge2c7.dirty

