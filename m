From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] e2fsck: Move check to add an index to a directory after fixing i_size
Date: Sat, 28 Nov 2009 10:30:32 -0500
Message-ID: <1259422233-14024-2-git-send-email-tytso@mit.edu>
References: <20091128152750.GD6763@thunk.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48027 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZK1Pa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Nov 2009 10:30:59 -0500
In-Reply-To: <20091128152750.GD6763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The check that determines whether an directory needs to be have an
index added to it depends on i_size.  So move it after we have fixed
up i_size so that we reliable will rehash a directory that needs it,
even if its i_size field was originally incorrect.  Otherwise, a
second run of e2fsck would be needed before the directory gets an
index added.

Thanks to Mikulas Patocka for providing a sample file system which
demonstrated this problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index f87d3ed..40948e7 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1896,10 +1896,6 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 #endif
 		}
 	}
-	if (ctx->dirs_to_hash && pb.is_dir &&
-	    !(inode->i_flags & EXT2_INDEX_FL) &&
-	    ((inode->i_size / fs->blocksize) >= 3))
-		ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
 
 	if (!pb.num_blocks && pb.is_dir) {
 		if (fix_problem(ctx, PR_1_ZERO_LENGTH_DIR, pctx)) {
@@ -1977,6 +1973,12 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 		pctx->num = 0;
 	}
+
+	if (ctx->dirs_to_hash && pb.is_dir &&
+	    !(inode->i_flags & EXT2_INDEX_FL) &&
+	    ((inode->i_size / fs->blocksize) >= 3))
+		ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
+
 out:
 	if (dirty_inode)
 		e2fsck_write_inode(ctx, ino, inode, "check_blocks");
-- 
1.6.5.216.g5288a.dirty

