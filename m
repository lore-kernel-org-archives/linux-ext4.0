From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/25] e2fsck: fix minor errors in journal handling
Date: Mon, 08 Sep 2014 16:12:48 -0700
Message-ID: <20140908231248.25904.70007.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaIHXMw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:12:52 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
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
index d12e317..6119cda 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -769,7 +769,7 @@ static void e2fsck_journal_release(e2fsck_t ctx, journal_t *journal,
 		mark_buffer_clean(journal->j_sb_buffer);
 	else if (!(ctx->options & E2F_OPT_READONLY)) {
 		jsb = journal->j_superblock;
-		jsb->s_sequence = htonl(journal->j_transaction_sequence);
+		jsb->s_sequence = htonl(journal->j_tail_sequence);
 		if (reset)
 			jsb->s_start = 0; /* this marks the journal as empty */
 		e2fsck_journal_sb_csum_set(journal, jsb);

