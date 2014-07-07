From: David Jander <david@protonic.nl>
Subject: Re: ext4: journal has aborted
Date: Mon, 7 Jul 2014 14:17:01 +0200
Message-ID: <20140707141701.2f9529af@archvile>
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
	<20140704184539.GA11103@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from protonic.xs4all.nl ([83.163.252.89]:15463 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaGGMQw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2014 08:16:52 -0400
In-Reply-To: <20140704184539.GA11103@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Dear Ted,

On Fri, 4 Jul 2014 14:45:39 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Fri, Jul 04, 2014 at 03:45:59PM +0200, David Jander wrote:
> > > 1) Some kind of eMMC driver bug, which is possibly causing the CACHE
> > > FLUSH command not to be sent.
> > 
> > How can I investigate this? According to the fio tests I ran and the
> > explanation Dmitry gave, I conclude that incorrectly sending of CACHE-FLUSH
> > commands is the only thing left to be discarded on the eMMC driver front,
> > right?
> 
> Can you try using an older kernel?  The report that that I quoted from
> John Stultz (https://lkml.org/lkml/2014/6/12/19) indicated that it was
> a problem that showed up in "recent kernels", and a bisection search
> seemed to point towards an unknown problem in the eMMC driver.
> Quoting from https://lkml.org/lkml/2014/6/12/762:
> 
>     "However, despite many many reboots the last good commit in my
>     branch - bb5cba40dc7f079ea7ee3ae760b7c388b6eb5fc3 (mmc: block:
>     Fixup busy detection while...) doesn't ever show the issue. While
>     the immediately following commit which bisect found -
>     e7f3d22289e4307b3071cc18b1d8ecc6598c0be4 (mmc: mmci: Handle CMD
>     irq before DATA irq) always does.
> 
>     The immensely frustrating part is while backing that single change off
>     from its commit sha always makes the issue go away, reverting that
>     change from on top of v3.15 doesn't. The issue persists....."

Next thing I am going to do is check 3.14 and/or 3.12, but first...

> > > 2) Some kind of hardware problem involving flash translation layers
> > > not having durable transactions of their flash metadata across power
> > > failures.
> > 
> > That would be like blaming Micron (the eMMC part manufacturer) for faulty
> > firmware... could be, but how can we test this?
> 
> The problem is that people who write these programs end up doing
> one-offs, as opposed to something that is well packaged and stands the
> test of time.  But basically what we want is a program that writes to
> sequential blocks in a block device with the following information:
> 
> *) a timestamp (seconds and microseconds from gettimeofday)
> *) a 64-bit generation number (which is randomly
>    generated and the same for each run of the progam)
> *) a 32-bit sequence number (starts at zero and
>    increments once per block
> *) a 32-bit "sync" number which is written after each time
>    fsync(2) is called while writing to the disk
> *) the sector number where the data was written
> *) a CRC of the above information
> *) some random pattern to fill the rest of the 512 or 4k block,
>    depending on the physical sector size
> 
> The program would then write this information to each 512 or 4k block,
> and periodically, say every N blocks (where N should be configurable),
> it would call fsync() which on an open block device, should result in
> a CACHE FLUSH command being sent.
> 
> Ideally, the sequence number and sync number would be output via a
> serial console, or maybe over an ssh connection, so you can see what
> was the last sequence number and sync number that was written before
> the disk, before you yank the power cord out of the wall.
> 
> Then you have write another program which scans the disk and makes
> sure that all of the blocks up until the last sync number that was
> output was in fact preserved faithfully on the disk after the power
> outage.
> 
> If not, you know you have a problem.
> 
> For bonus credit, you can also have a mode where the disk is
> pre-written with some known repeating pattern, such as 0xDEADBEEF, and
> then see if you have some sectors that do not contain either the
> expected 0xDEADBEEF, or the test pattern described above.

Ok, I wrote a simple python test script (see at the end of this e-mail) that
implements your idea. The tool checks the device, to see how far it came last
time, eventually analyzes and dumps a corrupt block, rewrites the whole device
to the background pattern (0xdeadbeef), syncs and then starts filling sectors
from the beginning with records consisting of sequence number (=sector index),
64-bit pseudo-random number, a timestamp, a CRC and filling data (0x55). The
sync-interval is an input parameter and is the interval (in sectors) between
calls to fsync() (Yes, I took care to flush python file objects first!). The
sector number after each sync is output to stdout, which is logged on a serial
port.
Next time the program is run (after a power-cycle), data must be correctly
written to at least that sector, and after that only sectors with 100%
background-fill have to exist. This is checked for.

I have been running this script repeatedly with different sync-interval values
on a 256 MiB partition of the eMMC device. Until now, I have not been able to
produce a sector with corrupt data, nor evidence of CACHE_FLUSH not being
processed correctly.

The tool itself is quite hacky (I wrote it this morning), but AFAICS it should
work correctly for our purposes.

> That indicates a potential problem where as power drops, sometimes the
> memory can go insane before the hard drive and the DMA engine manages
> to stop.  (Since as the saying goes, death is not an event, but rather
> a process, and different components inside the computer can die at
> different times.)  SGI discovered this problem very early on, which is
> why SGI machines have extra large capacitors on their power supplies,

Hahaha, yes, I think I heard that story before, but I honestly always thought
it was a joke or a myth, since it is pretty stupid. As for our hardware, it
does have proper brown-out detection and asserts "RESET" pins on all
peripherals that have one as soon as any power rail comes out of range. This
would have been the correct way of fixing SGI's "problem" IMHO.

> plus a power fail interrupt, so that when they lose power, the system
> can abort DMA transfers before allowing the power to shut down.

A power-fail interrupt would be helpful to make sure there is no ongoing write
or erase activity in the FLASH chips when power finally drops, but then the
eMMC device itself should have support for it. Instead of that, they do
actually guarantee that power interruptions are harmless through the
"reliable-writes" feature in the FTL firmware. The question is if we can
indeed trust that firmware.

> Otherwise, a file system which is doing logical journalling can end up
> with crap getting written on top of some critical file system data
> block, and which replying the journal won't help, since the journal
> just contains things like "update the mtime to be this value".

I am not familiar with filesystems having such type of journalling, and I
wonder what would be the use of it anyway, but I am not an expert in
filesystems....

> Since ext3 and ext4 do physical block journalling, we don't suffer
> from this problem since we always write the journal first, and the
> journal is flushed to disk before we update the metadata blocks.

That I understand. That's why a working CACHE_FLUSH is so important, right?

> On a
> power failure, when we replay the journal, if there is a corrupted fs
> metadata block due to the power failure causing garbage to be written
> to the disk, the damage can get repaired automatically when the
> journal is replayed.  And this is a good thing, since PC class
> hardware generally don't have power fail interrupts.  OTOH, ext3/4 is
> not as efficient as file systems such as XFS that do logical
> journalling.  Life is full of tradeoffs....

I never dared to use anything different that trusty ol' ext3/4.... or JFFS2
and UBIFS when dealing with bare flash devices of course.

> > EXT4 was always something like this:
> > 
> > # fsck.ext4 /dev/mmcblk1p2
> > e2fsck 1.42.5 (29-Jul-2012)
> > rootfs: recovering journal
> > Setting free inodes count to 37692 (was 37695)
> > Setting free blocks count to 136285 (was 136291)
> > rootfs: clean, 7140/44832 files, 42915/179200 blocks
> 
> This is normal, and not an indication of a problem.  In ext4, we
> longer update the free blocks and free inodes count in the superblock,
> except when we unmount the file system.  Otherwise on large CPU
> systems, needing to grab the superblock lock to update these values on
> each block/inode allocation and deallocation becomes a massive
> scalability bottleneck.
>
> Instead, at mount time, since we need need to read in the block group
> descriptors *anyway*, we just sum the free blocks/inodes in each block
> group descriptor, and update the global counters then.  So the fact
> that the global free blocks and free inodes values in the superblock
> are not up to date after a crash is normal, and expected.  This is why
> e2fsck didn't ask for permission before fixing this issue, which it
> would have when you run e2fsck without either the -p or -y option.

Ok, thanks a lot for this detailed explanation!

> > CASE 2: fsck on every other power-cycle:
> > 
> > Same as CASE 1 steps 1...5 and then:
> > 6.- Turn on power and boot again from dirty internal eMMC without running fsck.
> > 7.- Repeat steps 2...5 one more time
> > 8.- Perform steps 6...8 from CASE 1.
> > 
> > With this test, the following difference became apparent:
> > 
> > With EXT3: fsck.ext3 did the same as in CASE 1
> > 
> > With EXT4: I get a long list of errors that are being fixed.
> > It starts like this:
> > 
> > # fsck.ext4 /dev/mmcblk1p2
> > e2fsck 1.42.5 (29-Jul-2012)
> > rootfs: recovering journal
> > rootfs contains a file system with errors, check forced.
> > Pass 1: Checking inodes, blocks, and sizes
> > Inode 4591, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4594, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4595, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4596, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4597, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4598, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4599, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4600, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4601, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4602, i_blocks is 16, should be 8.  Fix<y>? yes
> > Inode 4603, i_blocks is 16, should be 8.  Fix<y>? yes
> 
> *This* is a problem.  And if you're seeing it for such a very large
> number of cases, it makes it unlikely to me that it is a ext4/jbd2
> bug.  For one thing, if it's so blatent, I should be able to replicate
> it very easily when using my "kill qemu" test.
> 
> What this makes me suspect is that you may be getting an older version
> of an inode table block.  That's why the above test procedure I
> outlined included the timestamp and the generation number in each
> block.  If after a power failure you start seeing an old generation
> number, then that's a hint that the FTL did somethign funky.

I have failed miserably until now at trying to prove the FTL wrong (or funky
at least ;-).

> And the advantage of the using a test progam that writes to the raw
> eMMC flash is that it cuts the file system completely out of the
> picture....

Any suggestion on how to improve my eMMC device test script (see below)?

Best regards,

-- 
David Jander
Protonic Holland.

filldev.py:
#!/usr/bin/env python
# vim: tabstop=4

import os, sys, stat
from time import time
from zlib import crc32
import subprocess

class Perc(object):
	def __init__(self, size):
		self.size = size
		self.last = -1

	def update(self, n):
		perc = int((n * 1000) / self.size)
		if perc != self.last:
			sys.stdout.write("\rProgress : %4.1f %% " % (perc/10.0))
			sys.stdout.flush()
			self.last = perc

def devstat(dev):
	# Return size of dev, if it's a file or a device
	size = os.stat(dev).st_size
	if not size:
		# It's probably a device...
		txt, _ = subprocess.Popen("blockdev --getsize " + dev,
				shell=True, stdout=subprocess.PIPE).communicate()
		size = int(txt) * 512
	return size

def initdev(dev):
	size = devstat(dev)
	f = open(dev, 'r+b')
	data = "\xde\xad\xbe\xef" * (512 / 4)
	blocks = size / len(data)
	p = Perc(blocks)
	print "Filling whole device with background pattern:"
	for i in xrange(blocks):
		f.write(data)
		p.update(i)
	p.update(i+1)
	f.close()
	os.system("sync")
	print "\nDone."

class PatternGenerator(object):
	def __init__(self):
		self.index = 0
		self.rand = 18274091872761

	def nextrand(self):
		ret = self.rand * 128273237635 + 45845
		self.rand = ret % (2**32)
		return (ret >> 16) & 0xffff

	def nextrand64(self):
		ret = self.nextrand() | (self.nextrand() << 16)
		return ret | (self.nextrand() << 32) | (self.nextrand() << 48)

	def timestamp(self):
		return "%17.6f" % time()

	def make_record(self):
		ret = "%010d %17.6f %16x" % (self.index, time(), self.nextrand64())
		ret += " %08x \n\0" % (2**31 + crc32(ret))
		self.index += 1
		fill = "\x55" * (512 - len(ret))
		return ret + fill

	def check_record_crc(self, rec):
		try:
			data, crc, rest = rec.rsplit(" ", 2)
		except ValueError:
			return False
		ncrc = (2**31 + crc32(data))
		crc = int(crc, 16)
		return crc == ncrc

	def sync(self):
		self.f.flush()
		os.fsync(self.f)
		os.system("sync")

class PatternWriter(PatternGenerator):
	def __init__(self, dev, syncinterval):
	 	PatternGenerator.__init__(self)
		self.size = devstat(dev)
		self.blocks = self.size / 512
		self.f = open(dev, 'r+b')
		self.perc = Perc(self.blocks)
		self.syncinterval = syncinterval

	def write_one(self):
		self.f.write(self.make_record())
		if (self.index % self.syncinterval) == 0:
			self.sync()
			print "Synced at block", self.index
		self.perc.update(self.index)

	def run(self):
		print "Writing data to device..."
		while self.blocks > self.index:
			self.write_one()
		print "\nDone."

class PatternChecker(PatternGenerator):
	def __init__(self, dev):
		PatternGenerator.__init__(self)
		self.size = devstat(dev)
		self.blocks = self.size / 512
		self.f = open(dev, 'rb')
		self.perc = Perc(self.blocks)
		self.ti = -1

	def read_one(self):
		return self.f.read(512)

	def analyze_block(self, blk):
		data = "\xde\xad\xbe\xef" * (512 / 4)
		self.index += 1
		if blk == data:
			return 1
		print "Possibly corrupt block detected!"
		print "Block data:", repr(blk)
		return 2

	def check_block(self, blk):
		if not self.check_record_crc(blk):
			print "\nCRC error on block", self.index
			ret = self.analyze_block(blk)
			if ret == 1:
				print "Block contents are 100% fill pattern."
				print "Checking rest of device for fill pattern..."
			return ret
		idx, ti, rnd, crc, rest = blk.split()
		idx = int(idx)
		ti = float(ti)
		rnd = int(rnd, 16)
		if idx != self.index:
			print "\nIndex number error on block", self.index
			print "Block data:", repr(blk)
			return 3
		if ti < self.ti:
			print "\nTimestamp error on block", self.index
			print "Block data:", repr(blk)
			return 4
		self.ti = ti
		if rnd != self.nextrand64():
			# FIXME: This can never be true, so remove this check?
			print "\nRandom number incorrect on block", self.index
			print "Block data:", repr(blk)
			return 5
		self.index += 1
		return 0

	def run(self):
		print "Checking device contents..."
		checkfill = False
		while self.blocks > self.index:
			blk = self.read_one()
			if checkfill:
				ret = self.analyze_block(blk)
			else:
				ret = self.check_block(blk)
			if ret == 1:
				checkfill = True
			elif ret:
				sys.exit(ret)
			self.perc.update(self.index)
		print "\nDone."
		return 0

if __name__ == "__main__":
	if len(sys.argv) < 3:
		print "Syntax: filldev <device> <sync-interval>"
		sys.exit(2)
	dev = sys.argv[1]
	sint = int(sys.argv[2], 0)
	c = PatternChecker(dev)
	c.run()
	initdev(dev)
	w = PatternWriter(dev, sint)
	w.run()




