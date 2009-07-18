From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix memory leak in block_iterate
Date: Sat, 18 Jul 2009 10:09:49 -0400
Message-ID: <20090718140949.GB25546@mit.edu>
References: <900111.75858.qm@web43503.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48664 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZGROJx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2009 10:09:53 -0400
Content-Disposition: inline
In-Reply-To: <900111.75858.qm@web43503.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 14, 2009 at 09:45:27AM -0700, number9652 wrote:
> 
> One of the error paths in block_iterate could return before freeing the
> scratch memory.  Here we free that memory before returning.

A cleaner patch is simply to let the code in errout: handle freeing
the memory if necessary.  This is what I've checked into the e2fsprogs
maint branch.  Thanks for reporting it!

					- Ted

commit 9922c53a4df10e660a1b425629a1f4db2b4fc03f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jul 18 10:02:41 2009 -0400

    libext2fs: fix memory leak in error path in ext2fs_block_iterate2()
    
    Reported-by: Nic Case <number9652@yahoo.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index de5342d..490116d 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -488,8 +488,10 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 abort_exit:
 	if (ret & BLOCK_CHANGED) {
 		retval = ext2fs_write_inode(fs, ino, &inode);
-		if (retval)
-			return retval;
+		if (retval) {
+			ret |= BLOCK_ERROR;
+			ctx.errcode = retval;
+		}
 	}
 errout:
 	if (!block_buf)
