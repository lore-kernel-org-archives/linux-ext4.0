From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2fsck: Let end_blk to be the maximum value of u32.
Date: Mon, 11 Jun 2012 01:02:45 -0400
Message-ID: <20120611050245.GB1437@thunk.org>
References: <1337238967-4704-1-git-send-email-tm@tao.ma>
 <1337238967-4704-2-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48983 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab2FKFCt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jun 2012 01:02:49 -0400
Content-Disposition: inline
In-Reply-To: <1337238967-4704-2-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tao,

Thanks for reporting the problem and submitting a test case.  I've
kept the regression test case (although I ended up renaming it).
However, I think a better fix is to change e2fsck, since it wasn't
making a check that it shouldn't have been making in the first place.
The commit description describes the fix which I think is better....

    	   	       		     	 - Ted

commit 9c40d14841f04811097a123d6e8555e78ce56811
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jun 11 00:25:45 2012 -0400

    e2fsck: only check for zero-length leaf extents
    
    The on-disk format for interior nodes in the extent tree does not
    encode the length of each entry in the interior node; instead, it is
    synthesized/simulated by the extent library code in libext2fs.
    Unfortunately, this simulation is not perfect; in particular it does
    not work for the last extent in the extent tree if there are
    uninitialized blocks allocated using fallocate with
    FALLOC_FL_KEEP_SIZE, and it leads to e2fsck incorrectly complaining
    about an invalid zero-length extent.
    
    We only need to worry about the extent length for the leaves of the
    tree, since it is there were we are checking an on-disk value, as
    opposed to a software-generated simulation.  So restrict the check of
    extent length to leaf nodes in the extent tree.
    
    Reported-by: Tao Ma <tm@tao.ma>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c6aae6e..72dcd97 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1779,7 +1779,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			problem = PR_1_EXTENT_BAD_START_BLK;
 		else if (extent.e_lblk < start_block)
 			problem = PR_1_OUT_OF_ORDER_EXTENTS;
-		else if (extent.e_len == 0)
+		else if (is_leaf && extent.e_len == 0)
 			problem = PR_1_EXTENT_LENGTH_ZERO;
 		else if (is_leaf &&
 			 (extent.e_pblk + extent.e_len) >
