From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Fix block bitmaps initalization with -O
 ^resize_inode
Date: Wed, 4 Dec 2013 18:44:35 -0500
Message-ID: <20131204234435.GF19914@thunk.org>
References: <52662BBA.70503@rs.jp.nec.com>
 <20131123013336.GD10269@birch.djwong.org>
 <20131126012706.GF10269@birch.djwong.org>
 <003101ceea7f$08d3fda0$1a7bf8e0$@rs.jp.nec.com>
 <20131127005505.GG10269@birch.djwong.org>
 <00d301ceec16$de11fec0$9a35fc40$@rs.jp.nec.com>
 <20131130200624.GA9541@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	'ext4 development' <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36629 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab3LDXos (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Dec 2013 18:44:48 -0500
Content-Disposition: inline
In-Reply-To: <20131130200624.GA9541@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 30, 2013 at 12:06:24PM -0800, Darrick J. Wong wrote:
> Hi Ted, I was hoping you might resolve a question for us:
> > And there is a bug that block group which has backup super block
> > and group descriptor block are not write out to device in wrtie_bitmaps()
> > when BLOCK_UNINIT is set.
> > So at this time, I attempted to fix this by cleaning BLOCK_UNIIT.
> 
> Is it the case that a group should only have BLOCK_UNINIT set if the group is
> totally empty (no group metadata, no blocks allocated to files) as Akira says?
> 
> Or is it the case that a group can have BLOCK_UNINIT set if the group contains
> group metadata but no blocks are allocated to files?

The meaning of BLOCK_UNINIT is that the contents of that block group's
block allocation bitmap is not initialized.  This causes libext2fs to
skip writing the block allocation bitmap, and to also skip reading the
block allocation bitmap (which is why it substitutes all zero's
instead of reading the allocation bitmap block).

Before allocating a block from a block group that has the BLOCK_UNINIT
flag set, it is important that the kernel or the userspace library
first initialize the block allocation bitmap and clear the
BLOCK_UNINIT flag.

When allocating blocks, implementations MUST be able to initiaize the
allocation bitmap for block groups which has the block group's own
metadata blocks (backup superblock and bg descriptor blocks if any,
reserved bg blocks, the allocation bitmaps, and inode table blocks) in
use.

Implementations SHOULD be able to initialize bitmaps for block groups
that have metadata blocks from other block groups if the case of
flex_bg.  However, historically there were some implementations that
didn't handle this correctly, which is why mke2fs initializes the
block bitmap and clears BLOCK_UNINIT in block groups that have
metadata blocks for other block groups.

Optionally, implementations MAY set the BLOCK_UNINIT bit after data
blocks have been deallocated from a block group such that the only
blocks in use are the block group's metadata groups.

Also, some implementations MAY clear the BLOCK_UNINIT bit and
initialize the block allocation bitmap early --- for example, when
allocating an inode in the block group.  This shouldn't be required,
however, and so implementations SHOULD correctly handle a situation
where an inode has been allocated in the inode table, but BLOCK_UNINIT
is set.

All of this basically boils down to the two rules of thumb:

1) The BLOCK_UNINIT bit is fundamentally about whether the block
allocation bitmap is valid, and whether mke2fs can skip needing to
initialize the block, and whether e2fsck, dumpe2fs, debugfs, etc. can
skip reading said allocation bitmap.

2) The IETF rule of "be conservative in what you send, and liberal in
what you accept" applies.

Does that help?

Thanks,

					- Ted
