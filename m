From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix ZERO_RANGE bug hidden by flag aliasing
Date: Mon, 1 Sep 2014 14:33:28 -0400
Message-ID: <20140901183328.GL8974@thunk.org>
References: <1409515240-9451-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <namjae.jeon@samsung.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59610 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbaIASdh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 14:33:37 -0400
Content-Disposition: inline
In-Reply-To: <1409515240-9451-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 31, 2014 at 04:00:40PM -0400, Theodore Ts'o wrote:
> Commit b8a8684502a0f introduced an accidental flag aliasing between
> EXT4_EX_NOCACHE and EXT4_GET_BLOCKS_CONVERT_UNWRITTEN.
> 
> Fortunately, this didn't introduce any untorward side effects --- we
> got lucky.  Nevertheless, fix this and leave a warning to hopefully
> avoid this from happening in the future.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

I spoke too soon.  It turns out this flag aliasing was _hiding_ a bug.
The following patch seems to address the problem.  We probably need to
do further cleanup of the extent handling code so it's clearer what's
going on, so for now, I'm going to stick with a more conservative fix.

     	       	  	       	    - Ted

commit 3d714c69e1beba1e07e64e9adc72d446b249be18
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Sep 1 14:32:09 2014 -0400

    ext4: fix ZERO_RANGE bug hidden by flag aliasing
    
    We accidently aliased EXT4_EX_NOCACHE and EXT4_GET_CONVERT_UNWRITTEN
    falgs, which apparently was hiding a bug that was unmasked when this
    flag aliasing issue was addressed (see the subsequent commit).  The
    reproduction case was:
    
       fsx -N 10000 -l 500000 -r 4096 -t 4096 -w 4096 -Z -R -W /vdb/junk
    
    ... which would cause fsx to report corruption in the data file.
    
    The fix we have is a bit of an overkill, but I'd much rather be
    conservative for now, and we can optimize ZERO_RANGE_FL handling
    later.  The fact that we need to zap the extent_status cache for the
    inode is unfortunate, but correctness is far more important than
    performance.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Cc: Namjae Jeon <namjae.jeon@samsung.com>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bc3b49f..4571b5d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4808,7 +4808,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		max_blocks -= lblk;
 
 	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
-		EXT4_GET_BLOCKS_CONVERT_UNWRITTEN;
+		EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
+		EXT4_EX_NOCACHE;
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
 
@@ -4846,15 +4847,21 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		ext4_inode_block_unlocked_dio(inode);
 		inode_dio_wait(inode);
 
+		ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size,
+					     flags, mode);
+		if (ret)
+			goto out_dio;
 		/*
 		 * Remove entire range from the extent status tree.
+		 *
+		 * ext4_es_remove_extent(inode, lblk, max_blocks) is
+		 * NOT sufficient.  I'm not sure why this is the case,
+		 * but let's be conservative and remove the extent
+		 * status tree for the entire inode.  There should be
+		 * no outstanding delalloc extents thanks to the
+		 * filemap_write_and_wait_range() call above.
 		 */
-		ret = ext4_es_remove_extent(inode, lblk, max_blocks);
-		if (ret)
-			goto out_dio;
