From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] jbd2: Always set journal superblock checksum when writing
 out superblock
Date: Mon, 13 May 2013 14:49:40 -0700
Message-ID: <20130513214940.GC8037@blackbox.djwong.org>
References: <20130510234013.GC5706@blackbox.djwong.org>
 <328F41F9-3133-4742-9172-C7C3C79BD1CB@dilger.ca>
 <20130513184615.GA8037@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42280 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3EMVtq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 17:49:46 -0400
Content-Disposition: inline
In-Reply-To: <20130513184615.GA8037@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Avoid future programming errors by making it so that the journal superblock
checksum is set in jbd2_write_superblock.  This fixes some journal checksum
failures when metadata_csum is turned on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4576bec..85550bf 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1325,6 +1325,7 @@ static void jbd2_write_superblock(journal_t *journal, int write_op)
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_op &= ~(REQ_FUA | REQ_FLUSH);
 	lock_buffer(bh);
+	jbd2_superblock_csum_set(journal, journal->j_superblock);
 	if (buffer_write_io_error(bh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the journal
@@ -1436,7 +1437,6 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n",
 		  journal->j_errno);
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
-	jbd2_superblock_csum_set(journal, sb);
 	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, WRITE_SYNC);
