From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] JBD: Fix JBD warnings when compiling with CONFIG_JBD_DEBUG
Date: Tue, 25 Sep 2007 11:33:56 -0500
Message-ID: <20070925163356.10843.40083.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jack@suse.cz
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36306 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXIYQhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 12:37:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

JBD: Fix JBD warnings when compiling with CONFIG_JBD_DEBUG

Note from Mingming's JBD2 fix:

Noticed all warnings are occurs when the debug level is 0. Then found
the "jbd2: Move jbd2-debug file to debugfs" patch
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0f49d5d019afa4e94253bfc92f0daca3badb990b

changed the jbd2_journal_enable_debug from int type to u8, makes the
jbd_debug comparision is always true when the debugging level is 0. Thus
the compile warning occurs. 

Thought about changing the jbd2_journal_enable_debug data type back to
int, but can't, because the jbd2-debug is moved to debug fs, where
calling debugfs_create_u8() to create the debugfs entry needs the value
to be u8 type.

Even if we changed the data type back to int, the code is still buggy,
kernel should not print jbd2 debug message if the
jbd2_journal_enable_debug is set to 0. But this is not the case.

The fix is change the level of debugging to 1. The same should fixed in
ext3/JBD, but currently ext3 jbd-debug via /proc fs is broken, so we
probably should fix it all together.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 fs/ext3/inode.c   |    2 +-
 fs/jbd/recovery.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index de4e316..f5b0e79 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2887,7 +2887,7 @@ int ext3_write_inode(struct inode *inode, int wait)
 		return 0;
 
 	if (ext3_journal_current_handle()) {
-		jbd_debug(0, "called recursively, non-PF_MEMALLOC!\n");
+		jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
 		dump_stack();
 		return -EIO;
 	}
diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 2a5f4b8..c5d9694 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -250,10 +250,10 @@ int journal_recover(journal_t *journal)
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REPLAY);
 
-	jbd_debug(0, "JBD: recovery, exit status %d, "
+	jbd_debug(1, "JBD: recovery, exit status %d, "
 		  "recovered transactions %u to %u\n",
 		  err, info.start_transaction, info.end_transaction);
-	jbd_debug(0, "JBD: Replayed %d and revoked %d/%d blocks\n",
+	jbd_debug(1, "JBD: Replayed %d and revoked %d/%d blocks\n",
 		  info.nr_replays, info.nr_revoke_hits, info.nr_revokes);
 
 	/* Restart the log at the next transaction ID, thus invalidating
@@ -297,7 +297,7 @@ int journal_skip_recovery(journal_t *journal)
 #ifdef CONFIG_JBD_DEBUG
 		int dropped = info.end_transaction - be32_to_cpu(sb->s_sequence);
 #endif
-		jbd_debug(0,
+		jbd_debug(1,
 			  "JBD: ignoring %d transaction%s from the journal.\n",
 			  dropped, (dropped == 1) ? "" : "s");
 		journal->j_transaction_sequence = ++info.end_transaction;
