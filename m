From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: journal has aborted
Date: Fri, 4 Jul 2014 14:45:39 -0400
Message-ID: <20140704184539.GA11103@thunk.org>
References: <20140701084206.GG9743@birch.djwong.org>
 <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
 <20140703134338.GE2374@thunk.org>
 <20140703161551.5fd13245@archvile>
 <87tx6yzdxz.fsf@openvz.org>
 <20140704114031.2915161a@archvile>
 <87r421zavi.fsf@openvz.org>
 <20140704132802.0d43b1fc@archvile>
 <20140704122022.GC10514@thunk.org>
 <20140704154559.026331ec@archvile>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45647 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaGDSpq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 14:45:46 -0400
Content-Disposition: inline
In-Reply-To: <20140704154559.026331ec@archvile>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 04, 2014 at 03:45:59PM +0200, David Jander wrote:
> > 1) Some kind of eMMC driver bug, which is possibly causing the CACHE
> > FLUSH command not to be sent.
> 
> How can I investigate this? According to the fio tests I ran and the
> explanation Dmitry gave, I conclude that incorrectly sending of CACHE-FLUSH
> commands is the only thing left to be discarded on the eMMC driver front,
> right?

Can you try using an older kernel?  The report that that I quoted from
John Stultz (https://lkml.org/lkml/2014/6/12/19) indicated that it was
a problem that showed up in "recent kernels", and a bisection search
seemed to point towards an unknown problem in the eMMC driver.
Quoting from https://lkml.org/lkml/2014/6/12/762:

    "However, despite many many reboots the last good commit in my
    branch - bb5cba40dc7f079ea7ee3ae760b7c388b6eb5fc3 (mmc: block:
    Fixup busy detection while...) doesn't ever show the issue. While
    the immediately following commit which bisect found -
    e7f3d22289e4307b3071cc18b1d8ecc6598c0be4 (mmc: mmci: Handle CMD
    irq before DATA irq) always does.

    The immensely frustrating part is while backing that single change off
    from its commit sha always makes the issue go away, reverting that
    change from on top of v3.15 doesn't. The issue persists....."

> > 2) Some kind of hardware problem involving flash translation layers
> > not having durable transactions of their flash metadata across power
> > failures.
> 
> That would be like blaming Micron (the eMMC part manufacturer) for faulty
> firmware... could be, but how can we test this?

The problem is that people who write these programs end up doing
one-offs, as opposed to something that is well packaged and stands the
test of time.  But basically what we want is a program that writes to
sequential blocks in a block device with the following information:

*) a timestamp (seconds and microseconds from gettimeofday)
*) a 64-bit generation number (which is randomly
   generated and the same for each run of the progam)
*) a 32-bit sequence number (starts at zero and
   increments once per block
*) a 32-bit "sync" number which is written after each time
   fsync(2) is called while writing to the disk
*) the sector number where the data was written
*) a CRC of the above information
*) some random pattern to fill the rest of the 512 or 4k block,
   depending on the physical sector size

The program would then write this information to each 512 or 4k block,
and periodically, say every N blocks (where N should be configurable),
it would call fsync() which on an open block device, should result in
a CACHE FLUSH command being sent.

Ideally, the sequence number and sync number would be output via a
serial console, or maybe over an ssh connection, so you can see what
was the last sequence number and sync number that was written before
the disk, before you yank the power cord out of the wall.

Then you have write another program which scans the disk and makes
sure that all of the blocks up until the last sync number that was
output was in fact preserved faithfully on the disk after the power
outage.

If not, you know you have a problem.

For bonus credit, you can also have a mode where the disk is
pre-written with some known repeating pattern, such as 0xDEADBEEF, and
then see if you have some sectors that do not contain either the
expected 0xDEADBEEF, or the test pattern described above.

That indicates a potential problem where as power drops, sometimes the
memory can go insane before the hard drive and the DMA engine manages
to stop.  (Since as the saying goes, death is not an event, but rather
a process, and different components inside the computer can die at
different times.)  SGI discovered this problem very early on, which is
why SGI machines have extra large capacitors on their power supplies,
plus a power fail interrupt, so that when they lose power, the system
can abort DMA transfers before allowing the power to shut down.
Otherwise, a file system which is doing logical journalling can end up
with crap getting written on top of some critical file system data
block, and which replying the journal won't help, since the journal
just contains things like "update the mtime to be this value".

Since ext3 and ext4 do physical block journalling, we don't suffer
from this problem since we always write the journal first, and the
journal is flushed to disk before we update the metadata blocks.  On a
power failure, when we replay the journal, if there is a corrupted fs
metadata block due to the power failure causing garbage to be written
to the disk, the damage can get repaired automatically when the
journal is replayed.  And this is a good thing, since PC class
hardware generally don't have power fail interrupts.  OTOH, ext3/4 is
not as efficient as file systems such as XFS that do logical
journalling.  Life is full of tradeoffs....

> EXT4 was always something like this:
> 
> # fsck.ext4 /dev/mmcblk1p2
> e2fsck 1.42.5 (29-Jul-2012)
> rootfs: recovering journal
> Setting free inodes count to 37692 (was 37695)
> Setting free blocks count to 136285 (was 136291)
> rootfs: clean, 7140/44832 files, 42915/179200 blocks

This is normal, and not an indication of a problem.  In ext4, we
longer update the free blocks and free inodes count in the superblock,
except when we unmount the file system.  Otherwise on large CPU
systems, needing to grab the superblock lock to update these values on
each block/inode allocation and deallocation becomes a massive
scalability bottleneck.

Instead, at mount time, since we need need to read in the block group
descriptors *anyway*, we just sum the free blocks/inodes in each block
group descriptor, and update the global counters then.  So the fact
that the global free blocks and free inodes values in the superblock
are not up to date after a crash is normal, and expected.  This is why
e2fsck didn't ask for permission before fixing this issue, which it
would have when you run e2fsck without either the -p or -y option.

> CASE 2: fsck on every other power-cycle:
> 
> Same as CASE 1 steps 1...5 and then:
> 6.- Turn on power and boot again from dirty internal eMMC without running fsck.
> 7.- Repeat steps 2...5 one more time
> 8.- Perform steps 6...8 from CASE 1.
> 
> With this test, the following difference became apparent:
> 
> With EXT3: fsck.ext3 did the same as in CASE 1
> 
> With EXT4: I get a long list of errors that are being fixed.
> It starts like this:
> 
> # fsck.ext4 /dev/mmcblk1p2
> e2fsck 1.42.5 (29-Jul-2012)
> rootfs: recovering journal
> rootfs contains a file system with errors, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Inode 4591, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4594, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4595, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4596, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4597, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4598, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4599, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4600, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4601, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4602, i_blocks is 16, should be 8.  Fix<y>? yes
> Inode 4603, i_blocks is 16, should be 8.  Fix<y>? yes

*This* is a problem.  And if you're seeing it for such a very large
number of cases, it makes it unlikely to me that it is a ext4/jbd2
bug.  For one thing, if it's so blatent, I should be able to replicate
it very easily when using my "kill qemu" test.

What this makes me suspect is that you may be getting an older version
of an inode table block.  That's why the above test procedure I
outlined included the timestamp and the generation number in each
block.  If after a power failure you start seeing an old generation
number, then that's a hint that the FTL did somethign funky.

And the advantage of the using a test progam that writes to the raw
eMMC flash is that it cuts the file system completely out of the
picture....

Cheers,

						- Ted
