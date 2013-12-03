From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/10] e2fsck: fix j_maxlen if the file system is exactly 1 << 32 blocks
Date: Tue,  3 Dec 2013 00:10:15 -0500
Message-ID: <1386047418-32431-8-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35857 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab3LCFK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:27 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the external journal device has exactly 1 << 32 blocks,
journal->j_maxlen would get set to zero, which would cause e2fsck to
declare the journal to be invalid.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/journal.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index ff11f22..bd2c9a1 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -241,7 +241,6 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 	unsigned long long	start = 0;
 	int			ext_journal = 0;
 	int			tried_backup_jnl = 0;
-	blk64_t			maxlen;
 
 	clear_problem_context(&pctx);
 
@@ -392,6 +391,8 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 	io_channel_set_blksize(ctx->journal_io, ctx->fs->blocksize);
 
 	if (ext_journal) {
+		blk64_t maxlen;
+
 		if (ctx->fs->blocksize == 1024)
 			start = 1;
 		bh = getblk(dev_journal, start, ctx->fs->blocksize);
@@ -426,9 +427,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 		}
 
 		maxlen = ext2fs_blocks_count(&jsuper);
-		if (maxlen > 1ULL << 32)
-			maxlen = (1ULL << 32) - 1;
-		journal->j_maxlen = maxlen;
+		journal->j_maxlen = (maxlen < 1ULL << 32) ? maxlen : (1ULL << 32) - 1;
 		start++;
 	}
 
-- 
1.8.5.rc3.362.gdf10213

