From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Massive filesystem corruption
Date: Thu, 25 Dec 2008 22:57:56 -0500
Message-ID: <20081226035756.GL9871@mit.edu>
References: <87abanbfvo.fsf@burly.wgtn.ondioline.org> <20081223061833.GQ23723@mit.edu> <877i5ozprb.fsf@burly.wgtn.ondioline.org> <200812201914.43614.technoboy85@gmail.com> <494D471C.8030907@redhat.com> <200812210305.49271.technoboy85@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Matteo Croce <technoboy85@gmail.com>,
	Paul Collins <paul@burly.ondioline.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52900 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbYLZD6E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Dec 2008 22:58:04 -0500
Content-Disposition: inline
In-Reply-To: <877i5ozprb.fsf@burly.wgtn.ondioline.org> <200812210305.49271.technoboy85@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 21, 2008 at 03:05:49AM +0100, Matteo Croce wrote:
> > > Pass 1: Checking inodes, blocks, and sizes
> > > Error1: Corrupt extent header on inode 107192
> > > [New Thread 0xb7e46700 (LWP 12878)]

The following patch to e2fsprogs will fix e2fsck's inability to deal
with a corrupted interior node in the extent tree.  It will be in the
next maintenance release of e2fsprogs, and it should address the
problem you've pointed out.

Regards,

						- Ted


commit 7518c176867099eb529502103106501861a71280
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Dec 25 22:42:38 2008 -0500

    e2fsck: Fix an unhandled corruption case in scan_extent_node()
    
    A corrupted interior node in an extent tree would cause e2fsck to
    crash with the error message:
    
    Error1: Corrupt extent header on inode 107192
    Aborted (core dumped)
    
    Handle this and related failures when scanning an inode's extent tree
    more robustly.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2619272..04aeb26 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1655,6 +1655,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			problem = PR_1_EXTENT_ENDS_BEYOND;
 
 		if (problem) {
+		report_problem:
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
@@ -1662,11 +1663,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 				pctx->errcode =
 					ext2fs_extent_delete(ehandle, 0);
 				if (pctx->errcode) {
-					fix_problem(ctx,
-						    PR_1_EXTENT_DELETE_FAIL,
-						    pctx);
-					/* Should never get here */
-					ctx->flags |= E2F_FLAG_ABORT;
+					pctx->str = "ext2fs_extent_delete";
 					return;
 				}
 				pctx->errcode = ext2fs_extent_get(ehandle,
@@ -1682,23 +1679,27 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		}
 
 		if (!is_leaf) {
-			mark_block_used(ctx, extent.e_pblk);
-			pb->num_blocks++;
+			blk = extent.e_pblk;
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_DOWN, &extent);
 			if (pctx->errcode) {
-				printf("Error1: %s on inode %u\n",
-					error_message(pctx->errcode), pctx->ino);
-				abort();
+				pctx->str = "EXT2_EXTENT_DOWN";
+				problem = PR_1_EXTENT_HEADER_INVALID;
+				if (pctx->errcode == EXT2_ET_EXTENT_HEADER_BAD)
+					goto report_problem;
+				return;
 			}
 			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
+			if (pctx->errcode)
+				return;
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_UP, &extent);
 			if (pctx->errcode) {
-				printf("Error1: %s on inode %u\n",
-					error_message(pctx->errcode), pctx->ino);
-				abort();
+				pctx->str = "EXT2_EXTENT_UP";
+				return;
 			}
+			mark_block_used(ctx, blk);
+			pb->num_blocks++;
 			goto next;
 		}
 
@@ -1780,7 +1781,14 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	}
 
 	scan_extent_node(ctx, pctx, pb, 0, ehandle);
-
+	if (pctx->errcode &&
+	    fix_problem(ctx, PR_1_EXTENT_ITERATE_FAILURE, pctx)) {
+		pb->num_blocks = 0;
+		inode->i_blocks = 0;
+		e2fsck_clear_inode(ctx, ino, inode, E2F_FLAG_RESTART,
+				   "check_blocks_extents");
+		pctx->errcode = 0;
+	}
 	ext2fs_extent_free(ehandle);
 }
 
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 19e8719..9cb3094 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -823,10 +823,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error while reading over @x tree in @i %i: %m\n"),
 	  PROMPT_CLEAR_INODE, 0 },
 
-	/* Error deleting a bogus extent */
-	{ PR_1_EXTENT_DELETE_FAIL,
-	  N_("Error while deleting extent: %m\n"),
-	  PROMPT_ABORT, 0 },
+	/* Failure to iterate extents */
+	{ PR_1_EXTENT_ITERATE_FAILURE,
+	  N_("Failed to iterate extents in @i %i\n"
+	     "\t(op %s, blk %b, lblk %c): %m\n"),
+	  PROMPT_CLEAR_INODE, 0 },
 
 	/* Bad starting block in extent */
 	{ PR_1_EXTENT_BAD_START_BLK,
@@ -863,6 +864,10 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has out of order extents\n\t(@n logical @b %c, physical @b %b, len %N)\n"),
 	  PROMPT_CLEAR, 0 },
 
+	{ PR_1_EXTENT_HEADER_INVALID,
+	  N_("@i %i has an invalid extent node (blk %b, lblk %c)\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 815b37c..1cb054c 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -479,8 +479,8 @@ struct problem_context {
 /* Error while reading extent tree */
 #define PR_1_READ_EXTENT		0x010056
 
-/* Error deleting a bogus extent */
-#define PR_1_EXTENT_DELETE_FAIL		0x010057
+/* Failure to iterate extents */
+#define PR_1_EXTENT_ITERATE_FAILURE	0x010057
 
 /* Bad starting block in extent */
 #define PR_1_EXTENT_BAD_START_BLK	0x010058
@@ -503,6 +503,9 @@ struct problem_context {
 /* Extents are out of order */
 #define PR_1_OUT_OF_ORDER_EXTENTS	0x01005E
 
+/* Extent node header invalid */
+#define PR_1_EXTENT_HEADER_INVALID	0x01005F
+
 /*
  * Pass 1b errors
  */
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 929e5cd..5545a94 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -441,8 +441,10 @@ retry:
 		eh = (struct ext3_extent_header *) newpath->buf;
 
 		retval = ext2fs_extent_header_verify(eh, handle->fs->blocksize);
-		if (retval)
+		if (retval) {
+			handle->level--;
 			return retval;
+		}
 
 		newpath->left = newpath->entries =
 			ext2fs_le16_to_cpu(eh->eh_entries);
