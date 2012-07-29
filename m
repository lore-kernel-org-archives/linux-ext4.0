From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: make sure the journal sb is written in ext4_clear_journal_err()
Date: Sat, 28 Jul 2012 23:52:46 -0400
Message-ID: <1343533966-18178-1-git-send-email-tytso@mit.edu>
References: <20120729035118.GA17210@thunk.org>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>,
	stable@kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41880 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab2G2Dww (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jul 2012 23:52:52 -0400
In-Reply-To: <20120729035118.GA17210@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After we transfer set the EXT4_ERROR_FS bit in the file system
superblock, it's not enough to call jbd2_journal_clear_err() to clear
the error indication from journal superblock --- we need to call
jbd2_journal_update_sb_errno() as well.  Otherwise, when the root file
system is mounted read-only, the journal is replayed, and the error
indicator is transferred to the superblock --- but the s_errno field
in the jbd2 superblock is left set (since although we cleared it in
memory, we never flushed it out to disk).

This can end up confusing e2fsck.  We should make e2fsck more robust
in this case, but the kernel shouldn't be leaving things in this
confused state, either.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/super.c      | 1 +
 fs/jbd2/journal.c    | 3 ++-
 include/linux/jbd2.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a2a5979..ca09462 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4444,6 +4444,7 @@ static void ext4_clear_journal_err(struct super_block *sb,
 		ext4_commit_super(sb, 1);
 
 		jbd2_journal_clear_err(journal);
+		jbd2_journal_update_sb_errno(journal);
 	}
 }
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e9a3c4c..bd23f2e 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1377,7 +1377,7 @@ static void jbd2_mark_journal_empty(journal_t *journal)
  * Update a journal's errno.  Write updated superblock to disk waiting for IO
  * to complete.
  */
-static void jbd2_journal_update_sb_errno(journal_t *journal)
+void jbd2_journal_update_sb_errno(journal_t *journal)
 {
 	journal_superblock_t *sb = journal->j_superblock;
 
@@ -1390,6 +1390,7 @@ static void jbd2_journal_update_sb_errno(journal_t *journal)
 
 	jbd2_write_superblock(journal, WRITE_SYNC);
 }
+EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 
 /*
  * Read the superblock for a given journal, performing initial
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index f334c7f..3efc43f 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1125,6 +1125,7 @@ extern int	   jbd2_journal_destroy    (journal_t *);
 extern int	   jbd2_journal_recover    (journal_t *journal);
 extern int	   jbd2_journal_wipe       (journal_t *, int);
 extern int	   jbd2_journal_skip_recovery	(journal_t *);
+extern void	   jbd2_journal_update_sb_errno(journal_t *);
 extern void	   jbd2_journal_update_sb_log_tail	(journal_t *, tid_t,
 				unsigned long, int);
 extern void	   __jbd2_journal_abort_hard	(journal_t *);
-- 
1.7.12.rc0.22.gcdd159b

