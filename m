From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/47] libext2fs: use a dynamically sized (or
 caller-provided) block zeroing buffer
Date: Sat, 13 Dec 2014 11:25:31 -0500
Message-ID: <20141213162531.GG17783@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215146.883.18254.stgit@birch.djwong.org>
 <20141212023756.GA10189@thunk.org>
 <20141212050249.GA27096@birch.djwong.org>
 <20141213162403.GF17783@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54485 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbaLMQZc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 11:25:32 -0500
Content-Disposition: inline
In-Reply-To: <20141213162403.GF17783@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 13, 2014 at 11:24:03AM -0500, Theodore Ts'o wrote:
> This is my replacement patch.

Followed by...

commit bc57b123d61f49cddcc3fb594fda2dcf589f9b38
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Dec 12 22:12:45 2014 -0500

    libext2fs: use block_buf in ext2fs_alloc_block2() if it is provided
    
    If the caller supplies a buffer to ext2fs_alloc_block2(), use it
    instead of calling ext2fs_zero_blocks2().
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 54535c4..1bb4d47 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -184,9 +184,6 @@ errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
 	errcode_t	retval;
 	blk64_t		block;
 
-	if (block_buf)
-		memset(block_buf, 0, fs->blocksize);
