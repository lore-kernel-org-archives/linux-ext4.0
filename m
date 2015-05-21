From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unused block group, but all blocks not free?
Date: Thu, 21 May 2015 19:59:40 -0400
Message-ID: <20150521235940.GB2750@thunk.org>
References: <555BDEF4.1020704@ubuntu.com>
 <20150520151007.GK2871@thunk.org>
 <555CA52F.3010109@ubuntu.com>
 <20150520163148.GA23989@thunk.org>
 <555D0541.1000804@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51486 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbbEUX7o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 May 2015 19:59:44 -0400
Content-Disposition: inline
In-Reply-To: <555D0541.1000804@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 20, 2015 at 06:05:53PM -0400, Phillip Susi wrote:
> On 05/20/2015 12:31 PM, Theodore Ts'o wrote:
> > As an optimization, if we can reconstruct the allocation bitmap from
> > the block group descriptors, we'll leave the block allocation bitmap
> > uninitialized, so that programs like e2fsck don't have to read the
> > bitmap block.  For a mostly empty file system, this optimization is
> > quite noticeable.
> 
> Ahh, so for block groups that have uninitialized bitmaps, I suppose I'll
> need to add a check to reconstruct the used blocks from the group
> descriptor table pointers.
> 
> > Can you send me a compressed raw e2image of the file system so I can
> > take a look?
> 
> Here it is.

Ah, so it's pretty self-explanatory.  From the dumpe2fs of the image:

Group 25: (Blocks 819200-851967) csum 0x45a8 [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
                  ^^^^^^^^^^^^^
  Backup superblock at 819200, Group descriptors at 819201-819201
                       ^^^^^^                       ^^^^^^^^^^^^^
  Reserved GDT blocks at 819202-819584
                         ^^^^^^^^^^^^^
  Block bitmap at 524297 (bg #16 + 9)
  Inode bitmap at 524313 (bg #16 + 25)
  Inode table at 528928-529439 (bg #16 + 4640)
  32383 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks: 819585-851967
  Free inodes: 204801-212992

One of the things which we didn't do as part of flex_bg was to change
the location of the superblocks that had backup superblock and block
group descriptor blocks (which perhaps we should have done, but oh,
well).  There is the sparse_super2 feature which would allow us to
reduce the number of backup superblocks down to two, one, or zero, but
that would require people using newer versions of e2fsprogs, so it's
not something we've enabled yet for wider use (although it is
something I've been using at $WORK).

					- Ted



