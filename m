From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 07/20] ext4/jbd2: Avoid WARN() messages when failing to write to the superblock
Date: Sun, 16 Nov 2008 11:05:27 -0500
Message-ID: <1226851540-8032-8-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44742 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751910AbYKPQiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:38:00 -0500
In-Reply-To: <1226851540-8032-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes some very common warnings reported by kerneloops.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 914258bf2cb22bf4336a1b1d90c551b4b11ca5aa)
---
 fs/ext4/super.c   |   23 ++++++++++++++++++++++-
 fs/jbd2/journal.c |   27 +++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f98f9bb..bf0d58c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2804,13 +2804,34 @@ static void ext4_commit_super(struct super_block *sb,
 
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
index ebe4940..52d2bee 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1259,6 +1259,22 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
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
@@ -1270,9 +1286,16 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
 
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
1.6.0.4.8.g36f27.dirty

