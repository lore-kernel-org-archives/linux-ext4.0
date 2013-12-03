From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: blk64_t to blk_t truncation
Date: Mon, 2 Dec 2013 19:25:03 -0500
Message-ID: <20131203002503.GA18601@thunk.org>
References: <529CF0D2.2010707@ddn.com>
 <529CF1E8.3010003@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Dilger, Andreas" <andreas.dilger@intel.com>
To: Kit Westneat <kwestneat@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35776 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab3LCAZM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 19:25:12 -0500
Content-Disposition: inline
In-Reply-To: <529CF1E8.3010003@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 02, 2013 at 03:47:36PM -0500, Kit Westneat wrote:
> 
> We recently ran into an issue where e2fsck was claiming to clear
> deleted/unused inodes, but was not actually doing it. We tracked it
> down to a bad blk64_t to blk_t conversion in pass2 where
> ext2fs_write_dir_block is being called instead of
> ext2fs_write_dir_block3. There is another similar call in
> allocate_dir_block. These appear to be fixed in master as part of
> the move to adding checksums to the end of directory leaf nodes, but
> it's still an issue on maint.
> 
> I ran gcc with -Wconversion and found a number of other places that
> have blk64_t to blk_t truncations, but I'm not sure how many of them
> are actually problems. For example in block_iterate_ind, block_nr is
> blk_t but it seems to be a specific choice, since there is also the
> blk64 variable. Another instance is with the EA refcounting, which
> is all 32-bit. In expand_dir_proc in pass3.c, it uses the 32-bit
> ext2fs_write_dir_block. Against 1.42.7, gcc reports 103 blk64_t to
> blk_t conversions, so this is just a small sample.

We can only reference 32-bit block numbers using the indirect block
scheme, so that's probably OK.  The EA refcounting is definitely a
problem.  As is the usages of expand_dir_proc in e2fsck/pass3.c.
Thanks for pointing that out.  We'll need to do an audit with
-Wconversion.  Unfortunately it is quite noisy, as you've noted.

I took a quick check about whether we could add -Wconversion to the
list of things which "make gcc-wall" would use, but the problem is
that it's quite noisy about things things things such as the bit
swapping and bit operations in bitops.h.

i've expanded your patch to fix up all of the useages of
ext2fs_write_dir_block() in e2fsck and applied it to my maint branch.
Thanks for pointing this out!

			    	     	    - Ted

commit 7bef6d52125ef3f1ef07d9da71a13546f6843c56
Author: Kit Westneat <kwestneat@ddn.com>
Date:   Mon Dec 2 19:11:52 2013 -0500

    e2fsck: use ext2fs_write_dir_block3() instead of ext2fs_write_dir_block()
    
    The use of ext2fs_write_dir_block() meant that attempts to fix
    deleted/unused inodes in a directory would not be fixed for file
    systems with 64-bit block numbers.  (And some random block with the
    high 32-bits cleared would get corrupted.)
    
    Fix a similar problem when expanding directories and when creating the
    lost+found dirctory.
    
    Signed-off-by: Kit Westneat <kwestneat@ddn.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index bceadfe..f2ac2dd 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1132,7 +1132,7 @@ out_htree:
 		}
 	}
 	if (dir_modified) {
-		cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf);
+		cd->pctx.errcode = ext2fs_write_dir_block3(fs, block_nr, buf, 0);
 		if (cd->pctx.errcode) {
 			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
 					 &cd->pctx))
@@ -1455,7 +1455,7 @@ static int allocate_dir_block(e2fsck_t ctx,
 		return 1;
 	}
 
-	pctx->errcode = ext2fs_write_dir_block(fs, blk, block);
+	pctx->errcode = ext2fs_write_dir_block3(fs, blk, block, 0);
 	ext2fs_free_mem(&block);
 	if (pctx->errcode) {
 		pctx->str = "ext2fs_write_dir_block";
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index e358bb2..926f462 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -198,9 +198,9 @@ static void check_root(e2fsck_t ctx)
 		return;
 	}
 
-	pctx.errcode = ext2fs_write_dir_block(fs, blk, block);
+	pctx.errcode = ext2fs_write_dir_block3(fs, blk, block, 0);
 	if (pctx.errcode) {
-		pctx.str = "ext2fs_write_dir_block";
+		pctx.str = "ext2fs_write_dir_block3";
 		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
@@ -444,7 +444,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 		return 0;
 	}
 
-	retval = ext2fs_write_dir_block(fs, blk, block);
+	retval = ext2fs_write_dir_block3(fs, blk, block, 0);
 	ext2fs_free_mem(&block);
 	if (retval) {
 		pctx.errcode = retval;
@@ -725,7 +725,7 @@ static int expand_dir_proc(ext2_filsys fs,
 			return BLOCK_ABORT;
 		}
 		es->num--;
-		retval = ext2fs_write_dir_block(fs, new_blk, block);
+		retval = ext2fs_write_dir_block3(fs, new_blk, block, 0);
 	} else {
 		retval = ext2fs_get_mem(fs->blocksize, &block);
 		if (retval) {
