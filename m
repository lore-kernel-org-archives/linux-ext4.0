From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Collapsing the number of feature flags (was Re: [PATCH v2.3
 00/23] ext4: Add metadata checksumming)
Date: Thu, 9 Feb 2012 17:49:25 -0500
Message-ID: <20120209224925.GA11737@thunk.org>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
 <20120208180847.GA3654@thunk.org>
 <20120209195444.GA15164@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50853 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab2BIWt3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Feb 2012 17:49:29 -0500
Content-Disposition: inline
In-Reply-To: <20120209195444.GA15164@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 09, 2012 at 11:54:44AM -0800, Darrick J. Wong wrote:
> 
> Hm... does this make it impossible to add checksums to a fs that doesn't have
> flexbg set?  I'm not 100% sure what happens if you enable the flexbg bit on a
> filesystem that wasn't mkfs'd with that turned on.  Most of the other flags
> look like they've been mkfs default for years, but I could be wrong.

You can enable flexbg on any file system, and it will work.
Technically the defintion of flexbg is that the block group's metadata
blocks (i.e., allocation bitmaps and inode table) can be located
anywhere on the disk, not just in its own blockgroup.  So it just
relaxs checks in the kernel and in e2fsck.

Once you do this there is the natural question of what is the block
group layout that should be used by mke2fs and resize2fs.  So we talk
about the flexbg layout, but that's not required by the flexbg feature
flag.  For example, for a long time, before we added the new resize
ioctl, an on-line resize would create new block groups using the old
layout (i.e., with the bitmap and inode table blocks in their own
block group).

Try it!  You can enable flex_bg on any file system you want, including
an old ext2 file system.  That's also a cheap way to force a file
system to be mounted by ext3 or ext4, without making any serious
change to the file system.

					- Ted
