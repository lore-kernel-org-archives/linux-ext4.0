From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/19] e2fsck: try to salvage corrupt directory entry blocks
Date: Fri, 01 Aug 2014 11:12:28 -0700
Message-ID: <20140801181228.12496.58789.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36262 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaHASMe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:12:34 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the code that would prompt the user to zap directory entry
blocks with bad checksums (i.e. strict_csums).  Instead, we'll run the
directory entries through the usual repair routines in an attempt to
save whatever we can.  At the same time, refactor the code that
schedules the repair of missing dirblock checksum entries.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c   |   34 +++++++++-------------------------
 e2fsck/problem.c |    5 -----
 e2fsck/problem.h |    3 ---
 3 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 69ebab6..ae7768f 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -944,32 +944,16 @@ static int check_dir_block(ext2_filsys fs,
 out_htree:
 #endif /* ENABLE_HTREE */
 
-	/* Verify checksum. */
-	if (is_leaf && de_csum_size && !inline_data_size) {
-		/* No space for csum?  Rebuild dirs in pass 3A. */
-		if (!ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf)) {
-			de_csum_size = 0;
-			if (e2fsck_dir_will_be_rehashed(ctx, ino))
-				goto skip_checksum;
-			if (!fix_problem(cd->ctx, PR_2_LEAF_NODE_MISSING_CSUM,
-					 &cd->pctx))
-				goto skip_checksum;
-			e2fsck_rehash_dir_later(ctx, ino);
+	/* Leaf node with no space for csum?  Rebuild dirs in pass 3A. */
+	if (is_leaf && !inline_data_size && failed_csum &&
+	    !ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf)) {
+		de_csum_size = 0;
+		if (e2fsck_dir_will_be_rehashed(ctx, ino) ||
+		    !fix_problem(cd->ctx, PR_2_LEAF_NODE_MISSING_CSUM,
+				 &cd->pctx))
 			goto skip_checksum;
-		}
-		if (failed_csum) {
-			char *buf2;
-			if (!fix_problem(cd->ctx, PR_2_LEAF_NODE_CSUM_INVALID,
-					 &cd->pctx))
-				goto skip_checksum;
-			ext2fs_new_dir_block(fs,
-					     db->blockcnt == 0 ? ino : 0,
-					     EXT2_ROOT_INO, &buf2);
-			memcpy(buf, buf2, fs->blocksize);
-			ext2fs_free_mem(&buf2);
-			dir_modified++;
-			failed_csum = 0;
-		}
+		e2fsck_rehash_dir_later(ctx, ino);
+		goto skip_checksum;
 	}
 	/* htree nodes don't use fake dirents to store checksums */
 	if (!is_leaf)
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 1b6bdb0..80ca3a0 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1477,11 +1477,6 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@p @h %d: internal node fails checksum.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
-	/* leaf node fails checksum */
-	{ PR_2_LEAF_NODE_CSUM_INVALID,
-	  N_("@d @i %i, %B, offset %N: @d fails checksum.\n"),
-	  PROMPT_SALVAGE, PR_PREEN_OK },
-
 	/* leaf node has no checksum */
 	{ PR_2_LEAF_NODE_MISSING_CSUM,
 	  N_("@d @i %i, %B, offset %N: @d has no checksum.\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 89db5f3..4813fc6 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -879,9 +879,6 @@ struct problem_context {
 /* htree node fails checksum */
 #define PR_2_HTREE_NODE_CSUM_INVALID	0x02004A
 
-/* dir leaf node fails checksum */
-#define PR_2_LEAF_NODE_CSUM_INVALID	0x02004B
