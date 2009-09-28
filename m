From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]ext4: Add checks whether two inodes are different
Date: Mon, 28 Sep 2009 16:00:00 -0400
Message-ID: <20090928200000.GA22733@mit.edu>
References: <4ABC7FC5.5070803@rs.jp.nec.com> <20090925103453.GR10562@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38296 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbZI1UAH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2009 16:00:07 -0400
Content-Disposition: inline
In-Reply-To: <20090925103453.GR10562@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 25, 2009 at 04:34:53AM -0600, Andreas Dilger wrote:
> 
> Wouldn't it make more sense to just return an error (or no error
> but do nothing) in the case of source/target inode being the same?
> I don't see how that would be good to "defragment" the inode onto
> itself, just like "cp f f" and "rename f f" don't make sense either.

The code actually checks to make sure the source and target inodes are
different, but it does so too late.  So the following patch should fix
the problem which Akira-san was attempting to solve, without
introducing any extra code complexity (we just move some lines of code
around instead.)

					- Ted

commit 7cdf27b7241ef616b4158a26d7d85bd36f499462
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Sep 28 15:58:29 2009 -0400

    ext4: EXT4_IOC_MOVE_EXT: Check for different original and donor inodes first
    
    Move the check to make sure the original and donor inodes are
    different earlier, to avoid a potential deadlock by trying to lock the
    same inode twice.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 5332fd4..25b6b14 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1001,14 +1001,6 @@ mext_check_arguments(struct inode *orig_inode,
 		return -EINVAL;
 	}
 
-	/* orig and donor should be different file */
-	if (orig_inode->i_ino == donor_inode->i_ino) {
-		ext4_debug("ext4 move extent: The argument files should not "
-			"be same file [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
-		return -EINVAL;
-	}
