From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: correctly propagate error from journal to superblock
Date: Sun, 10 Jun 2012 23:48:22 -0400
Message-ID: <1339386502-30606-1-git-send-email-tytso@mit.edu>
Cc: Ken Sumrall <ksumrall@google.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48973 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab2FKDsY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jun 2012 23:48:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the file system is mounted read-only after a file system error has
been detected, the fact that an error occurred is written to the
journal.  This is important because while the journal is getting
replayed, the error indication in the superblock may very well get
overwritten.

Unfortunately, the code to propagate the error indication from the
journal to superblock was broken because this was being done before
the old file system handle is thrown away and the file system is
re-opened to ensure that no stale data is in the file system handle.
As a result, the error indication in the superblock was never written
out.

To fix this, we need to move the check if the journal's error
indicator has been set after the file system has been freed and
re-open.

Reported-by: Ken Sumrall <ksumrall@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/journal.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 74b506b..767ea10 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -848,15 +848,7 @@ static errcode_t recover_ext3_journal(e2fsck_t ctx)
 	if (journal->j_failed_commit) {
 		pctx.ino = journal->j_failed_commit;
 		fix_problem(ctx, PR_0_JNL_TXN_CORRUPT, &pctx);
-		ctx->fs->super->s_state |= EXT2_ERROR_FS;
-		ext2fs_mark_super_dirty(ctx->fs);
-	}
-
-
-	if (journal->j_superblock->s_errno) {
-		ctx->fs->super->s_state |= EXT2_ERROR_FS;
-		ext2fs_mark_super_dirty(ctx->fs);
-		journal->j_superblock->s_errno = 0;
+		journal->j_superblock->s_errno = -EINVAL;
 		mark_buffer_dirty(journal->j_sb_buffer);
 	}
 
@@ -915,7 +907,13 @@ int e2fsck_run_ext3_journal(e2fsck_t ctx)
 
 	/* Set the superblock flags */
 	e2fsck_clear_recover(ctx, recover_retval);
-	return recover_retval;
+
+	/*
+	 * Do one last sanity check, and propagate journal->s_errno to
+	 * the EXT2_ERROR_FS flag in the fs superblock if needed.
+	 */
+	retval = e2fsck_check_ext3_journal(ctx);
+	return retval ? retval : recover_retval;
 }
 
 /*
-- 
1.7.10.2.552.gaa3bb87

