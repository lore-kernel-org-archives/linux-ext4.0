From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] [e2fsprogs] e2fsck: fix segmentation fault when block
	size is greater than 8192
Date: Fri, 2 Jan 2009 18:30:46 -0500
Message-ID: <20090102233046.GF4758@mit.edu>
References: <4948BF24.3040601@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56838 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZABXay (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jan 2009 18:30:54 -0500
Content-Disposition: inline
In-Reply-To: <4948BF24.3040601@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 17, 2008 at 04:58:12PM +0800, Miao Xie wrote:
> When I did fsck a filesystem with large blocksize(greater than 8192),
> segmentation fault occured. The cause is the size of b_data array that is
> defined as a fixed size in buffer_head structure.

Here's a better patch which avoids the need for two calls to malloc
for each buffer_head strcture.

						- Ted

commit e35d548b59e24af9f7fc18396e8880df96d1bc51
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Jan 2 18:14:42 2009 -0500

    e2fsck: Fix journal replay for block sizes greater than 8k
    
    E2fsck was using a fixed-size 8k buffer for replaying blocks from the
    journal.  So attempts to replay a journal on filesystems greater than
    8k would cause e2fsck to crash with a segfault.
    
    Thanks to Miao Xie <miaox@cn.fujitsu.com> for reporting this problem.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 0e4f951..60cc682 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -15,7 +15,6 @@
 #include "e2fsck.h"
 
 struct buffer_head {
-	char		b_data[8192];
 	e2fsck_t	b_ctx;
 	io_channel 	b_io;
 	int	 	b_size;
@@ -23,6 +22,7 @@ struct buffer_head {
 	int	 	b_dirty;
 	int	 	b_uptodate;
 	int	 	b_err;
+	char		b_data[1024];
 };
 
 struct inode {
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 10f5095..adbd3db 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -68,8 +68,10 @@ int journal_bmap(journal_t *journal, blk_t block, unsigned long *phys)
 struct buffer_head *getblk(kdev_t kdev, blk_t blocknr, int blocksize)
 {
 	struct buffer_head *bh;
+	int bufsize = sizeof(*bh) + kdev->k_ctx->fs->blocksize -
+		sizeof(bh->b_data);
 
-	bh = e2fsck_allocate_memory(kdev->k_ctx, sizeof(*bh), "block buffer");
+	bh = e2fsck_allocate_memory(kdev->k_ctx, bufsize, "block buffer");
 	if (!bh)
 		return NULL;
 
