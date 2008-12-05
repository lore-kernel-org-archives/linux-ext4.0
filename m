From: Theodore Tso <tytso@mit.edu>
Subject: Re: tune2fs -I seems dangerous
Date: Thu, 4 Dec 2008 20:24:30 -0500
Message-ID: <20081205012430.GC1323@mit.edu>
References: <49385927.9070003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41506 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751518AbYLEBYd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2008 20:24:33 -0500
Content-Disposition: inline
In-Reply-To: <49385927.9070003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 04, 2008 at 04:26:47PM -0600, Eric Sandeen wrote:
> As a small experiment...
> 
> dd if=/dev/zero of=fsfile bs=1M count=16
> mkfs.ext4 -F -I 128 fsfile
> mkdir -p mnt
> mount -o loop fsfile mnt
> for I in `seq 1 4096`; do echo $I > mnt/file.$I; done
> umount mnt
> tune2fs -I 256 fsfile
> e2fsck -fy fsfile
> 
> ... this yields 10031 lines of fsck output, and results in about 38% of
> the files that were on the filesystem going missing.

Looks like the problem is that tune2fs -I was only tested on ext3
filesystem.  It blows up rather spectacularly on filesystems with the
flex_bg option, and it's apparently not updating the checksums if the
uninit_bg option is specified.

> I don't have the strong sense that tune2fs -I has been shaken out at
> all; should it be shipping as a useable option?

It needs some TLC, that's for certain.  Move of the code was copied
from resize2fs, so it's pretty paranoid about error checking and so
on.  The major problems from when the code was adapted for use in
expanding the inode table, and the algorithm that tries to do that
work.

The major problem is seems to be that it's not double checking to make
sure that all of the blocks that it needs to move in order to expand
the inode table are in fact moveable.  Specifically, the code is not
checking and will blindly assume success when in fact things are *not*
successful under the following conditions:

   1) Flex_bg is enabled, and there is an inode table for a subsequent
   block group immediately following the inode table.

   2) There is a block from the bad block inode immediately following
   the inode table (which is really bad).  Tune2fs -I will not notice,
   relocate the block in the bad block, and then write the inode table
   onto the bad block, possibly causing the loss of up to 16 inodes
   per bad block immediately following the inode table.

   3) The filesystem is formatted for RAID so there is stride setting
   which causes the block or inode bitmap to be located immediately
   following the inode.  This will be caught be e2fsck, if the user is
   paranoid enough to run e2fsck immediately after tune2fs -I.

I think is fair, though, to say that tune2fs -I code was written by
someone who wasn't sufficiently paranoid to think through all of the
failure cases.  There is in fact a FIXME!! comment for case #2, but at
the very least what should have happend is that the move_block should
keep track of how many blocks were moved, and if it wasn't equal to
needed blocks, it should have signalled an error because it would have
indicated either a programming bug or a hardware bug or a filesystem
corruption bug.  Either way, it shouldn't move forward because there
is the risk that users' files might get destroyed.

						- Ted
