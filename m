From: Theodore Tso <tytso@mit.edu>
Subject: Re: Random corruption test for e2fsck
Date: Wed, 11 Jul 2007 13:43:47 -0400
Message-ID: <20070711174347.GD19456@thunk.org>
References: <1184072860.4440.39.camel@garfield.linsyssoft.com> <20070710145855.GB27033@thunk.org> <20070711094410.GM6417@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39623 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758566AbXGKRnv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 13:43:51 -0400
Content-Disposition: inline
In-Reply-To: <20070711094410.GM6417@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2007 at 03:44:11AM -0600, Andreas Dilger wrote:
> I've already found some kind of memory corruption in e2fsck as a result
> of running this as a regular user.  It segfaults in qsort() when freeing
> memory.  The image that causes this problem is attached, and it happens
> with the unpatched 1.39-WIP Mercurial tree of 2007-05-22.  Unfortunately,
> I don't have any decent memory debugging tools handy, so it isn't easy to
> see what is happening.  This is on an FC3 i686 system, in case it matters.

Thanks for sending me the test case!  Here's the patch, which will
probably cause me to do a 1.40.2 release sooner rather than later...

						- Ted

commit 5e9ba85c2694926eb784531d81ba107200cf1a51
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Jul 11 13:42:43 2007 -0400

    Fix e2fsck segfault on very badly damaged filesystems
    
    A recent change to e2fsck_add_dir_info() to use tdb files to check
    filesystems with a very large number of filesystems had a typo which
    caused us to resize the wrong data structure.  This would cause a
    array overrun leading to malloc pointer corruptions.  Since we
    normally can very accurately predict how big the the dirinfo array
    needs to be, this bug only got triggered on very badly corrupted
    filesystems.
    
    Thanks to Andreas Dilger for submitting the test case which discovered
    this problem, and to Kalpak Shah for writing a random testing script
    which created the test case.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/dirinfo.c b/e2fsck/dirinfo.c
index aaa4d09..f583c62 100644
--- a/e2fsck/dirinfo.c
+++ b/e2fsck/dirinfo.c
@@ -126,7 +126,7 @@ void e2fsck_add_dir_info(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
 		ctx->dir_info->size += 10;
 		retval = ext2fs_resize_mem(old_size, ctx->dir_info->size *
 					   sizeof(struct dir_info),
-					   &ctx->dir_info);
+					   &ctx->dir_info->array);
 		if (retval) {
 			ctx->dir_info->size -= 10;
 			return;
