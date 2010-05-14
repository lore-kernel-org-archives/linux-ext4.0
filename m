From: tytso@mit.edu
Subject: Re: your mail
Date: Fri, 14 May 2010 18:07:26 -0400
Message-ID: <20100514220726.GF16989@thunk.org>
References: <20100514213946.0FEA81BC316@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: curtw@google.com, fmayhar@google.com, mrubin@google.com,
	linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34276 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab0ENWHa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 May 2010 18:07:30 -0400
Content-Disposition: inline
In-Reply-To: <20100514213946.0FEA81BC316@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 14, 2010 at 02:39:45PM -0700, Jiaying Zhang wrote:
> This patch changes e2fsck to use the same checking on the validity
> of an extent as the kernel ext4 is using.

Actually, the better fix is to explicitly test for extent.e_blk == 0.
The kernel test works because at the moment nothing creates file
systems where s_first_data_block is anything other than 0 or 1.  But
technically speaking, having an extent which begins at
s_first_data_block isn't actually _wrong_.  It might overlap with fs
metadata, but pass1b will handle that.  The reason why it doesn't in
the case of 0 is because 0 is a special case and also means "there's
no block present" when returned by ext2fs_block_iterate.

Arguably the kernel should be changed to something similar, but in
practice it won't make a difference in practice.  E2fsck can do a
slightly better job recovering in the case of 1k block filesystems, so
this patch is slightly better.

						- Ted

commit e6238d3708d328851bfdff7580d1b8504c7cf2e4
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri May 14 18:03:14 2010 -0400

    e2fsck: Explicitly reject extents that begin at physical block 0 as illegal
    
    In the case where s_first_data_block is 1, we need to explictly reject
    an extent whose starting physical block is zero.
    
    Thanks to Jiaying Zhang <jiayingz@google.com> for finding this bug.
    
    Addresses-Google-Bug: #2573806
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5e2ecc7..c35937f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1694,7 +1694,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		is_dir = LINUX_S_ISDIR(pctx->inode->i_mode);
 
 		problem = 0;
-		if (extent.e_pblk < ctx->fs->super->s_first_data_block ||
+		if (extent.e_pblk == 0 ||
+		    extent.e_pblk < ctx->fs->super->s_first_data_block ||
 		    extent.e_pblk >= ctx->fs->super->s_blocks_count)
 			problem = PR_1_EXTENT_BAD_START_BLK;
 		else if (extent.e_lblk < start_block)
