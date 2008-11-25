From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC 0/2] ext4: zero uninitialized inode tables
Date: Tue, 25 Nov 2008 13:52:54 -0500
Message-ID: <20081125185254.GB525@mit.edu>
References: <20081121102309.182113793@bull.net> <20081125053226.GE20928@mit.edu> <18731.61311.620237.554814@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:45607 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753975AbYKYSw5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 13:52:57 -0500
Content-Disposition: inline
In-Reply-To: <18731.61311.620237.554814@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 25, 2008 at 01:28:47PM +0100, Solofo.Ramangalahy@bull.net wrote:
>   * This could probably be made into a module, because it is not often in use.
>   and this sentence from the OLS'02 paper
>   "Since the online resizing code is only used very rarely, it would
>   be possible to put the bulk of this code into a separate module that
>   is only loaded when a resize operation is done."
>   Inode zeroing is done only once in a filesystem lifetime (and each
>   time it is resized).

Sure, but (a) zeroing the inode table should not be much code;
especially since we need to zero contiguous block ranges in extents.c
to deal with uninitialized extents.  Also (b) modules have their own
cost; they waste on average PAGE_SIZE/2 worth of memory per module due
to internal fragmentation, and cause extra entries in the TLB cache
(on an x86, the entire kernel uses a single TLB entry, but each 4k
page used by a module burns a separate TLB entry), and (c) loading
modules is slow and serializes the kernel at boot time.  In addition,
(d) some users simply prohibit modules for policy reasons.

So I could imagine adding module support, but it has to work built
into the kernel is critical, and this will probably the primary way it
will be compiled.  And you need to make sure the kernel tries to
automatically load the module when a resize or a new filesystem is
mounted, if it is compiled as a module.

> I was also thinking that there may be other places to do it. For
> example, zeroing the inode table where the inode bitmap is initialized
> (ext4_init_inode_bitmap() called only once in
> ext4_read_inode_bitmap()).

When we first allocate an inode in the inode table and when we need to
zero it is largely unrelated.  The problem is that e2fsck doesn't want
to trust the inode bitmap as being accurate; nor can it necessarily
trust the bg_inodes_unused field --- note particularly that this is
not updated in the backup group descriptors.  Hence the window of
vulnerability has nothing to do with whether or not we have started
using a particular part of the inode table, but because the inode
table has not been initialized.

So we want to get the inode table fully initialized as soon as
possible, although we have to balance this with not impacting the
system's performance.

> The reasoning would have been to zero as soon as it is known to be
> needed:
> . without deferring it to the threads,
> . decreasing the probability of zeroing competing with other code

A block group's inode table can be 2-4 megabytes; and zeroing out that
many disk blocks can take a noticeable amount of time, so doing it
synchronously with an inode creation doesn't seem like a great idea to
me.....

>  > > . fix the resize inode case
>  > 
>  > Not sure what problem you were having here?
> 
> With resize inode, the obtained filesystem is corrupted, fsck says
> "Resize inode not valid.  Recreate?"
> as well as: 
> "Free blocks count wrong for group #0 (6788, counted=6789)."

Something really bogus must be happening; the resize inode is in block
group 0, which always has some inodes (and therefore would never be
touched by your patch, which only initializes completely empty inode
tables).  So if it managed to corrupt the resize inode, that's
especially worrisome.

> Appart from the data structures change you mentionned, these changes
> were discussed:
> . a mount option to disable the threads when doing testing/performance
>   benchmarking

Yes, this makes sense.  The administrator can always remount the filesystem
with a mount option to re-enable itable initialization if the
sysadmin wants to zero the inode table later on.

> . a flag in s_flags field of struct ext4_super_block to indicate that
>   the zeroing has been done on all the groups. Possibly reset with
>   resize.

This doesn't make that much sense to me.  It's not that hard to
iterate through all of the block groups descriptors checking for the
EXT4_BG_INODE_ZEROED flag.

							- Ted
