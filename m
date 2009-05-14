From: Theodore Tso <tytso@mit.edu>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 10:07:32 -0400
Message-ID: <20090514140732.GI11352@mit.edu>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41061 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbZENOHe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2009 10:07:34 -0400
Content-Disposition: inline
In-Reply-To: <20090514132506.GD5146@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 10:55:06PM +0930, Kevin Shanahan wrote:
> On Thu, May 14, 2009 at 08:37:00PM +0930, Kevin Shanahan wrote:
> > Sure - now running with 2.6.29.3 + your patch.
> > 
> >   patching file fs/ext4/inode.c
> >   Hunk #1 succeeded at 1040 with fuzz 1 (offset -80 lines).
> >   Hunk #2 succeeded at 1113 (offset -81 lines).
> >   Hunk #3 succeeded at 1184 (offset -93 lines).
> > 
> > I'll report any hits for "check_block_validity" in syslog.
> 
> That didn't take long:
> 
> May 14 22:49:17 hermes kernel: EXT4-fs error (device dm-0): check_block_validity: inode #759 logical block 1741329 mapped to 529 (size 1)
> May 14 22:49:17 hermes kernel: Aborting journal on device dm-0:8.
> May 14 22:49:17 hermes kernel: ext4_da_writepages: jbd2_start: 293 pages, ino 759; err -30
> May 14 22:49:17 hermes kernel: Pid: 374, comm: pdflush Not tainted 2.6.29.3 #1
> May 14 22:49:17 hermes kernel: Call Trace:

The reason why I put in the ext4_error() was because I figured it was
better to stop the filesystem from stomping on the inode table (since
that way would lie data loss).  It would also freeze the filesystem so
we could see what was happening.

Could you run debugfs on the filesystem, and then send me the results
of these commands:

debugfs: stat <759>
debugfs: ncheck 759

Also, could you try run e2fsck on the filesystem and send me the
output?  The ext4_error() should have stopped the kernel from doing
any damage (like stomping on block 529, which was part of the inode
table or block group descriptors).  If send me the dumpe2fs output
about group 0, we'll know for sure (i.e.):

Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x3e19, unused inodes 8169
  Primary superblock at 0, Group descriptors at 1-5
  Reserved GDT blocks at 6-32
  Block bitmap at 33 (+33), Inode bitmap at 49 (+49)
  Inode table at 65-576 (+65)

(Your numbers will be different; this was from a 80GB hard drive).

> Any clues there? I don't think I'll be able to run this during the day
> if it's going to trigger and remount the fs read-only as easily as
> this.

Yes, this is a *huge*.  Finding this may have been just what we needed
to determine what has been going on.  Thank you!!

What I would suggest doing is to mount the filesystem with the mount
option -o nodelalloc.  This would be useful for two fronts: (1) it
would determine whether or not the problem shows up if we suppress
delayed allocation, and (2) if it works, hopefully it will prevent you
from further filesystem corruption incidents.  (At least as a
workaround; turning off delayed allocation will result in a
performance decrease, but better that then data loss, I always say!)

The fact that this triggered so quickly is actually a bit scary, so
hopefully we'll be able to track down exactly what happened fairly
quickly from here, and then fix the problem for real.

Thanks,

					- Ted
