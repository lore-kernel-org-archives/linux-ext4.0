From: tytso@mit.edu
Subject: Re: [PATCH v2] replaced BUG() with return -EIO from
 ext4_ext_get_blocks
Date: Mon, 14 Dec 2009 10:04:53 -0500
Message-ID: <20091214150453.GD4867@thunk.org>
References: <4B22A572.5010201@redhat.com>
 <1260651656-13805-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, fmayhar@google.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49387 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbZLNPE4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 10:04:56 -0500
Content-Disposition: inline
In-Reply-To: <1260651656-13805-1-git-send-email-surbhi.palande@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Surbhi,

Thanks for the patch, and since I believe this is your first patch
submission, welcome to the ext4 developer's community!

I made a few stylistic changes to your patch before adding it to the
ext4 patch queue.  I removed the comment "We don't want to panic..."
since the explanation is not going to help someone reading the code in
the future (comments referring to non-existent code, such as why we're
not going to call BUG_ON are best placed in the commit description,
since when someone looks at the code a year from now, they won't see
the missing BUG_ON :-).

(BTW, the comment to which you added the "We don't want to panic.."
aside is itself kind of nasty:

      /*
       * consistent leaf must not be empty;
       * this situation is possible, though, _during_ tree modification;
       * this is why assert can't be put in ext4_ext_find_extent()
       */

This comment really should be made in the code body of
ext4_ext_find_extent(), with an comment above that function indicating
that callers who care should be making this check.  A code clean up
for another day, along with auditing all of the *other* callers of
ext4_ext_find_extent() that they are making this check when
appropriate...)

I also made some minor whitespace changes with respect to argument
alignment, and in the commit description I used the term "Kernel BZ"
and included the URL instead of using the term "upstream bug #", since
that's commonly used terminology for commits in the kernel tree.
(Upstream makes sense if the patch lives in a distro tree, but it's
less clear when it's actually in the upstream repository, since the
"upstream" developers generally don't refer to themselves or their
project in those terms.)

Thanks, regards,

						- Ted

commit 9f31d1227c3f2611405fc29e092c61a56b37da33
Author: Surbhi Palande <surbhi.palande@canonical.com>
Date:   Mon Dec 14 09:53:52 2009 -0500

    ext4: replace BUG() with return -EIO in ext4_ext_get_blocks
    
    This patch fixes the Kernel BZ #14286.  When the address of an extent
    corresponding to a valid block is corrupted, a -EIO should be reported
    instead of a BUG().  This situation should not normally not occur
    except in the case of a corrupted filesystem.  If however it does,
    then the system should not panic directly but depending on the mount
    time options appropriate action should be taken. If the mount options
    so permit, the I/O should be gracefully aborted by returning a -EIO.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14286
    
    Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3a7928f..8fd6c56 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3190,7 +3190,13 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 * this situation is possible, though, _during_ tree modification;
 	 * this is why assert can't be put in ext4_ext_find_extent()
 	 */
-	BUG_ON(path[depth].p_ext == NULL && depth != 0);
+	if (path[depth].p_ext == NULL && depth != 0) {
+		ext4_error(inode->i_sb, __func__, "bad extent address "
+			   "inode: %lu, iblock: %d, depth: %d",
+			   inode->i_ino, iblock, depth);
+		err = -EIO;
+		goto out2;
+	}
 	eh = path[depth].p_hdr;
 
 	ex = path[depth].p_ext;
