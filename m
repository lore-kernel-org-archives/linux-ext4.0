From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/24] e2fsck: don't offer to recreate the journal if fsck
 is aborting due to bad block bitmaps
Date: Fri, 18 Jul 2014 15:52:56 -0700
Message-ID: <20140718225256.31374.91713.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35466 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762724AbaGRWxD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:53:03 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsck knows the bitmaps are bad at the exit (probably because they
were bad at the start and have not been fixed), don't offer to
recreate the journal because doing so causes e2fsck to abort a second
time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/unix.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 7055a92..bb5141f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1642,7 +1642,8 @@ print_unsupp_features:
 	run_result = e2fsck_run(ctx);
 	e2fsck_clear_progbar(ctx);
 
-	if (ctx->flags & E2F_FLAG_JOURNAL_INODE) {
+	if (!ctx->invalid_bitmaps &&
+	    (ctx->flags & E2F_FLAG_JOURNAL_INODE)) {
 		if (fix_problem(ctx, PR_6_RECREATE_JOURNAL, &pctx)) {
 			if (journal_size < 1024)
 				journal_size = ext2fs_default_journal_size(ext2fs_blocks_count(fs->super));

