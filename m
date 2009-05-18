From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs bmap problem
Date: Mon, 18 May 2009 12:32:06 -0400
Message-ID: <20090518163206.GB27751@mit.edu>
References: <199598.89239.qm@web43514.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34207 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbZERQcQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 12:32:16 -0400
Content-Disposition: inline
In-Reply-To: <199598.89239.qm@web43514.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 18, 2009 at 07:56:38AM -0700, number9652 wrote:
> 
> I have looked at it a little more closely now, and to me it seems
> that we could add a new function like ext2fs_extent_open to accept
> an inode structure, as an alternative to changing the extent
> structure.

Yes, the right way to do this is to create a new function,
ext2fs_extent_open2() which takes a new parameter, struct inode
*inode, and then make ext2fs_extent_open() call ext2fs_extent_open2()
with the inode parameter set to NULL.  In ext2fs_extent_open2(), if
struct inode *inode is non-NULL, then we use it instead of reading in
the inode.  The one tricky bit is that we will need to use
ext2fs_read_inode() and ext2fs_write_inode() instead of
ext2fs_read_inode_full()/ext2fs_write_inode_full(), but that's OK; the
extents code didn't really need to pull in the full inode structure
anyway.

							- Ted
