From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/4] jbd2: restart replay without revokes if journal block
 csum fails
Date: Wed, 10 Sep 2014 17:28:38 -0700
Message-ID: <20140911002838.10109.50948.stgit@birch.djwong.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23640 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIKA2q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2014 20:28:46 -0400
In-Reply-To: <20140911002818.10109.51772.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If, during a journal_checksum_v3 replay we encounter a block that
doesn't match its tag in the descriptor block tag, we need to restart
the replay without the revoke table in the hopes of replaying the
newest non-corrupt version of the block that we possibly can.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/recovery.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)


diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 9b329b5..0094d8b 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -439,6 +439,7 @@ static int do_one_pass(journal_t *journal,
 	 * block offsets): query the superblock.
 	 */
 
+restart_pass:
 	sb = journal->j_superblock;
 	next_commit_ID = be32_to_cpu(sb->s_sequence);
 	next_log_block = be32_to_cpu(sb->s_start);
@@ -585,7 +586,8 @@ static int do_one_pass(journal_t *journal,
 					/* If the block has been
 					 * revoked, then we're all done
 					 * here. */
-					if (jbd2_journal_test_revoke
+					if (!block_error &&
+					    jbd2_journal_test_revoke
 					    (journal, blocknr,
 					     next_commit_ID)) {
 						brelse(obh);
@@ -599,11 +601,24 @@ static int do_one_pass(journal_t *journal,
 						be32_to_cpu(tmp->h_sequence))) {
 						brelse(obh);
 						success = -EIO;
+						if (!block_error) {
+							/* If we see a corrupt
+							 * block, kill the
+							 * revoke list and
+							 * restart the replay
+							 * so that the blocks
+							 * are as close to
+							 * accurate as
+							 * possible. */
+							jbd2_journal_clear_revoke(journal);
+							brelse(bh);
+							block_error = 1;
+							goto restart_pass;
+						}
 						printk(KERN_ERR "JBD2: Invalid "
 						       "checksum recovering "
 						       "block %llu in log\n",
 						       blocknr);
-						block_error = 1;
 						goto skip_write;
 					}
 

