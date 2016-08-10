From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs segfault
Date: Wed, 10 Aug 2016 16:01:13 -0400
Message-ID: <20160810200113.GA10523@thunk.org>
References: <20160809214157.091c200a@schraegle.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: Andreas =?iso-8859-1?Q?Schr=E4gle?= <andreas@schraegle.name>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41422 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933589AbcHJUBW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2016 16:01:22 -0400
Content-Disposition: inline
In-Reply-To: <20160809214157.091c200a@schraegle.name>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 09, 2016 at 09:41:57PM +0700, Andreas Schrägle wrote:
> 
> I seem to have run in a segmentation fault bug in resize2fs.
> 

Thanks for the bug report!  I found the problem and the patch will be
in the next version of e2fsprogs.  It should fairly simple to apply
this patch to e2fsprogs 1.43.1 and rebuild it.

Cheers,

						- Ted

commit 3d6fc974831a360aee460e54c442538445f3017c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Aug 10 15:49:35 2016 -0400

    resize2fs: fix crash when there is an ea block and no blocks to migrate
    
    This fixes a bug introduced in 1.43 by commit fb47b94fffc: "resize2fs:
    rewrite extent/dir/ea block checksums when migrating".  If there is an
    extended attribute block and there are no blocks that need to migrate,
    we will crash.
    
    The bug was caused by a botched De Morgan's transformation.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 09419ce..8f6d95e 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1895,7 +1895,7 @@ static errcode_t migrate_ea_block(ext2_resize_t rfs, ext2_ino_t ino,
 	errcode_t err = 0;
 
 	/* No EA block or no remapping?  Quit early. */
-	if (ext2fs_file_acl_block(rfs->old_fs, inode) == 0 && !rfs->bmap)
+	if (ext2fs_file_acl_block(rfs->old_fs, inode) == 0 || !rfs->bmap)
 		return 0;
 	new_block = extent_translate(rfs->old_fs, rfs->bmap,
 		ext2fs_file_acl_block(rfs->old_fs, inode));
