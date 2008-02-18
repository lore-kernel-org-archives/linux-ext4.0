From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][7/28] e2fsprogs-extents.patch
Date: Mon, 18 Feb 2008 17:09:35 -0500
Message-ID: <20080218220935.GM25098@mit.edu>
References: <20080202075943.GB23836@webber.adilger.int> <20080202082559.GG31694@webber.adilger.int> <20080202082701.GH31694@webber.adilger.int> <47B9C6E5.2010304@redhat.com> <20080218195332.GK25098@mit.edu> <47B9EF12.5020400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55863 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752987AbYBRWJo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 17:09:44 -0500
Content-Disposition: inline
In-Reply-To: <47B9EF12.5020400@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 02:48:18PM -0600, Eric Sandeen wrote:
> > I think we need to get kernel patches into mainline ASAP not to set
> > the EXTENTS_FL 
> 
> You mean on devices/fifos/sockets ?  Ok.

Yes, sorry for not being explicit.

> 
> But today, with 2.6.25-rc1 and e2fsprogs-interim, long (non-fast)
> symlinks get clobbered by e2fsck, because:
> 
> Pass 1: Checking inodes, blocks, and sizes
> Inode 12 has EXTENT_FL set, but is not in extents format
> Fix? yes

Yeah, my current development branch of e2fsprogs does the right thing,
but e2fsprogs-interim doesn't.  We need to add a test to make sure
ext2fs_inode_has_valid_blocks(inode) before marking the inode bad and
asking the user if the inode should be cleared.

> and *poof* it's gone.  That one concerns me more...  This *should* be in
> extents format, right, even though it's limited to one block...

Well, for symlinks, they are only one block, so there is no reason for
it to be using the extent format.  So storing it as a single block
number makes a lot more sense.  It should just not be setting the
EXTENTS_FL flag. 

> well, if any filetypes are not supposed to have the extents flag set,
> and they're zero-length, I'd say go ahead & clear it, and even complain
> if you like - it's the design intent after all -  I wouldn't worry about
> the noise at this stage.  FWIW, I haven't seen a core dump.  :)

The current pu branch core dumps.  My development branch has at least
that problem fixed.  :-)

						- Ted
