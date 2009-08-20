From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck.ext4 -D corrupts fs?
Date: Wed, 19 Aug 2009 22:44:19 -0400
Message-ID: <20090820024419.GA7076@mit.edu>
References: <h6hmcr$hqi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Marcin Miroslaw <spam_trap@kolekcja.mejor.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60900 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZHTCoW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 22:44:22 -0400
Content-Disposition: inline
In-Reply-To: <h6hmcr$hqi$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2009 at 10:13:14PM +0200, Marcin Miroslaw wrote:
> Hello,
> I've noticed fs curruption after using fsck.ext4 -D

Yeah, I really should get a new release of e2fsprogs out.  It's fixed
in the maint branch.

					- Ted

commit 16e470e65010ba3f0516cf9cdf1bd6c98f064e3f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Jul 19 22:43:33 2009 -0400

    libext2fs: Fix regression in ext2fs_extent_set_bmap()
    
    Commit 0dc291611 introduced a regression when unmapping the first
    block in an extent.  This caused e2fsck -fD to corrupt large
    directories if the directory has to shrink by more than one block.
    The problem was set_bmap should only go to a next leaf when setting a
    first block in an extent, and not when it is unmapping the first block
    in an extent.
    
    Addresses-Debian-Bug: #537510
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 7fcc2cf..9d7b7de 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1296,11 +1296,12 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 			}
 			if (retval)
 				goto done;
+			retval = ext2fs_extent_get(handle,
+						   EXT2_EXTENT_NEXT_LEAF,
+						   &extent);
+			if (retval)
+				goto done;
 		}
-		retval = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT_LEAF,
-					   &extent);
-		if (retval)
-			goto done;
 		extent.e_pblk++;
 		extent.e_lblk++;
 		extent.e_len--;
