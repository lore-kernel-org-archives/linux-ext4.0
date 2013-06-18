From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: move superblock checksum calculation to jbd2_write_superblock()
Date: Tue, 18 Jun 2013 11:54:02 -0400
Message-ID: <1371570842-28031-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59067 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab3FRPyG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jun 2013 11:54:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some of the functions which modify the jbd2 superblock were not
updating the checksum before calling jbd2_write_superblock().  Move
the call to jbd2_superblock_csum_set() to jbd2_write_superblock(), so
that the checksum is calculated consistently.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: stable@vger.kernel.org
---
 fs/jbd2/journal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4c8b8d4..28bcfa1 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1335,6 +1335,7 @@ static int journal_reset(journal_t *journal)
 static void jbd2_write_superblock(journal_t *journal, int write_op)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
+	journal_superblock_t *sb = journal->j_superblock;
 	int ret;
 
 	trace_jbd2_write_superblock(journal, write_op);
@@ -1356,6 +1357,7 @@ static void jbd2_write_superblock(journal_t *journal, int write_op)
 		clear_buffer_write_io_error(bh);
 		set_buffer_uptodate(bh);
 	}
+	jbd2_superblock_csum_set(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
 	ret = submit_bh(write_op, bh);
@@ -1452,7 +1454,6 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n",
 		  journal->j_errno);
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
-	jbd2_superblock_csum_set(journal, sb);
 	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, WRITE_SYNC);
-- 
1.7.12.rc0.22.gcdd159b

