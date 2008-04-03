From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Bug in ext2fs_set_gdt_csum() and uninit_groups handling
Date: Thu, 03 Apr 2008 08:54:57 -0400
Message-ID: <E1JhOy1-0006g8-Oy@closure.thunk.org>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43721 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751457AbYDCMzZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 08:55:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Unfortunately, this has already been merged into the mainline branch
before I noticed this, but we have a nasty bug right now in the
uninit_groups handling.   Note this code here in ext2fs_set_gdt_csum():

		/* Even if it wasn't zeroed, by the time this function is
		 * called by e2fsck we have already scanned and corrected
		 * the whole inode table so we may as well not overwrite it.
		 * This is just a hint to the kernel that it could do lazy
		 * zeroing of the inode table if mke2fs didn't do it, to help
		 * out if we need to do a full itable scan sometime later. */
		if (!(bg->bg_flags & (EXT2_BG_INODE_UNINIT |
				      EXT2_BG_INODE_ZEROED)))
			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;


There's only one problem.   ext2fs_set_gdt_csum() is also called by
mke2fs, so all of the block groups are having the EXT2_BG_INODE_ZEROED
bit set.

I'm also not entirely sure this is safe for e2fsck, since as far as I
can tell, e2fsck does *not* currently scan zero uninitialized portions
of the inode table.  It uses the ext2fs_get_next_inode() function, which
will skip uninitialized inodes.

So, I think what needs to happen is that the above fragment in
csum.c:ext2fs_set_gdt_csum() needs to disappear.

Is there a kernel patch that will zero out the inode tables in the
background?  I remember hearing discussions of this, but it doesn't seem
to be in the kernel tree or in the ext4 patch queue.

Eventually, we might want to add a feature to e2fsck (probably
controlled by e2fsck.conf or a command-line option?) to zero out the
inode table, and then we can clear the INODE_ZERO'ed bg_flags.

Jose, Andreas, does this make sense?

							- Ted

P.S.  I noticed this because I had added to dumpe2fs the ability to show
the INODE_ZEROED flag, and noticed it was set when I was *not* expecting
it to be set.
