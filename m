From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] jbd2: Always set journal superblock checksum when writing
 out superblock
Date: Fri, 10 May 2013 16:40:13 -0700
Message-ID: <20130510234013.GC5706@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add a few missing calls to jbd2_superblock_csum_set just prior to calling
jbd2_write_superblock.  This fixes complaints about corrupt journals if
metadata checksumming and journal checksumming are both enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/journal.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b6cdc57..a4c7678 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1348,6 +1348,7 @@ void jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
 
 	sb->s_sequence = cpu_to_be32(tail_tid);
 	sb->s_start    = cpu_to_be32(tail_block);
+	jbd2_superblock_csum_set(journal, sb);
 
 	jbd2_write_superblock(journal, write_op);
 
@@ -1381,6 +1382,7 @@ static void jbd2_mark_journal_empty(journal_t *journal)
 
 	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
 	sb->s_start    = cpu_to_be32(0);
+	jbd2_superblock_csum_set(journal, sb);
 	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, WRITE_FUA);
