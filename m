From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: improve performance of region_allocate()
Date: Wed, 23 Aug 2017 19:21:35 -0400
Message-ID: <20170823232135.s54yfvs3zia2dnva@thunk.org>
References: <20170819011635.1815929-1-dsp@fb.com>
 <20170822022948.nyn6fessudjaj5xh@thunk.org>
 <a4b31ace-3a54-051d-75df-b47452c789cb@uls.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Doug Porter <dsp@fb.com>, linux-ext4@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47498 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbdHWXVk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Aug 2017 19:21:40 -0400
Content-Disposition: inline
In-Reply-To: <a4b31ace-3a54-051d-75df-b47452c789cb@uls.co.za>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jaco, here's the version of your patch I plan to use.  Please take a
look.

The only real changes are mostly whitespace and formatting.

By the way, it would be nice if you could send me permission to add a

Signed-off-by: Jaco Kroon <jaco@uls.co.za>

See http://elinux.org/Developer_Certificate_Of_Origin for an
explanation of what this means.

						- Ted

commit 320d436c006dc2550ebd01084b6e823f0cea8bc2
Author: Jaco Kroon <jaco@uls.co.za>
Date:   Wed Aug 23 13:54:25 2017 -0400

    e2fsck: optimize out the use region_t in scan_extent_node()
    
    Since extents have a guarantee of being monotonically increasing we
    merely need to check that block n+1 starts after block n.  This is a
    simple enough check and we can perform this by calculating the next
    expected logical block instead of using the region usage tracking data
    abstraction.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 8044beed6..bc26beb99 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -96,7 +96,7 @@ struct process_block_struct {
 	struct problem_context *pctx;
 	ext2fs_block_bitmap fs_meta_blocks;
 	e2fsck_t	ctx;
-	region_t	region;
+	blk64_t		next_lblock;
 	struct extent_tree_info	eti;
 };
 
@@ -2628,9 +2628,18 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			  (1U << (21 - ctx->fs->super->s_log_block_size))))
 			problem = PR_1_TOOBIG_DIR;
 
-		if (is_leaf && problem == 0 && extent.e_len > 0 &&
-		    region_allocate(pb->region, extent.e_lblk, extent.e_len))
-			problem = PR_1_EXTENT_COLLISION;
+		if (is_leaf && problem == 0 && extent.e_len > 0) {
+#if 0
+			printf("extent_region(ino=%u, expect=%llu, "
+			       "lblk=%llu, len=%u)\n",
+			       pb->ino, pb->next_lblock,
+			       extent.e_lblk, extent.e_len);
+#endif
+			if (extent.e_lblk < pb->next_lblock)
+				problem = PR_1_EXTENT_COLLISION;
+			else if (extent.e_lblk + extent.e_len > pb->next_lblock)
+				pb->next_lblock = extent.e_lblk + extent.e_len;
+		}
 
 		/*
 		 * Uninitialized blocks in a directory?  Clear the flag and
@@ -2963,13 +2972,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	memset(pb->eti.ext_info, 0, sizeof(pb->eti.ext_info));
 	pb->eti.ino = pb->ino;
 
-	pb->region = region_create(0, info.max_lblk);
-	if (!pb->region) {
-		ext2fs_extent_free(ehandle);
-		fix_problem(ctx, PR_1_EXTENT_ALLOC_REGION_ABORT, pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
+	pb->next_lblock = 0;
 
 	eof_lblk = ((EXT2_I_SIZE(inode) + fs->blocksize - 1) >>
 		EXT2_BLOCK_SIZE_BITS(fs->super)) - 1;
@@ -2982,8 +2985,6 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 				   "check_blocks_extents");
 		pctx->errcode = 0;
 	}
-	region_free(pb->region);
-	pb->region = NULL;
 	ext2fs_extent_free(ehandle);
 
 	/* Rebuild unless it's a dir and we're rehashing it */
