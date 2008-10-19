From: akpm@linux-foundation.org
Subject: [patch 089/148] jbd: don't dirty original metadata buffer on abort
Date: Sat, 18 Oct 2008 20:27:54 -0700
Message-ID: <200810190327.m9J3RsOm032706@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hidehiro.kawai.ez@hitachi.com,
	jack@suse.cz, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbYJSDeD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Oct 2008 23:34:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
