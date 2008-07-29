From: akpm@linux-foundation.org
Subject: + jbd-dont-dirty-original-metadata-buffer-on-abort.patch added to -mm tree
Date: Mon, 28 Jul 2008 23:57:50 -0700
Message-ID: <200807290657.m6T6voxG019834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: don't dirty original metadata buffer on abort
has been added to the -mm tree.  Its filename is
     jbd-dont-dirty-original-metadata-buffer-on-abort.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: don't dirty original metadata buffer on abort
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

Currently, original metadata buffers are dirtied when they are unfiled
whether the journal has aborted or not.  Eventually these buffers will be
written-back to the filesystem by pdflush.  This means some metadata
buffers are written to the filesystem without journaling if the journal
aborts.  So if both journal abort and system crash happen at the same
time, the filesystem would become inconsistent state.  Additionally,
replaying journaled metadata can overwrite the latest metadata on the
filesystem partly.  Because, if the journal aborts, journaled metadata are
preserved and replayed during the next mount not to lose uncheckpointed
metadata.  This would also break the consistency of the filesystem.

This patch prevents original metadata buffers from being dirtied on abort
by clearing BH_JBDDirty flag from those buffers.  Thus, no metadata
buffers are written to the filesystem without journaling.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/jbd/commit.c~jbd-dont-dirty-original-metadata-buffer-on-abort fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-dont-dirty-original-metadata-buffer-on-abort
+++ a/fs/jbd/commit.c
@@ -518,9 +518,10 @@ void journal_commit_transaction(journal_
 		jh = commit_transaction->t_buffers;
 
 		/* If we're in abort mode, we just un-journal the buffer and
-		   release it for background writing. */
+		   release it. */
 
 		if (is_journal_aborted(journal)) {
+			clear_buffer_jbddirty(jh2bh(jh));
 			JBUFFER_TRACE(jh, "journal is aborting: refile");
 			journal_refile_buffer(journal, jh);
 			/* If that was the last one, we need to clean up
@@ -855,6 +856,8 @@ restart_loop:
 		if (buffer_jbddirty(bh)) {
 			JBUFFER_TRACE(jh, "add to new checkpointing trans");
 			__journal_insert_checkpoint(jh, commit_transaction);
+			if (is_journal_aborted(journal))
+				clear_buffer_jbddirty(bh);
 			JBUFFER_TRACE(jh, "refile for checkpoint writeback");
 			__journal_refile_buffer(jh);
 			jbd_unlock_bh_state(bh);
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

origin.patch
linux-next.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-abort-ext3-if-the-journal-has-aborted.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch

