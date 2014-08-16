From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/27] e2fsck: set journal superblock s_sequence to
 tail_sequence
Date: Sat, 16 Aug 2014 16:47:15 -0700
Message-ID: <20140816234715.11171.64926.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43555 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaHPXrU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:47:20 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The journal superblock's s_sequence field seems to track the tid of
the tail (oldest) transaction in the log.  Therefore, when we release
the journal, set the s_sequence to the tail_sequence, because setting
it to the transaction_sequence means that we're setting the tid to
that of the head of the log.  Granted, for replay these two are
usually the same (and s_start == 0 anyway) so thus far we've gotten
lucky and nobody noticed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 84e3a26..414f2d8 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -745,7 +745,7 @@ static void e2fsck_journal_release(e2fsck_t ctx, journal_t *journal,
 		mark_buffer_clean(journal->j_sb_buffer);
 	else if (!(ctx->options & E2F_OPT_READONLY)) {
 		jsb = journal->j_superblock;
-		jsb->s_sequence = htonl(journal->j_transaction_sequence);
+		jsb->s_sequence = htonl(journal->j_tail_sequence);
 		if (reset)
 			jsb->s_start = 0; /* this marks the journal as empty */
 		e2fsck_journal_sb_csum_set(journal, jsb);

