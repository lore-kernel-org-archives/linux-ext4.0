From: David Jander <david@protonic.nl>
Subject: Re: ext4: journal has aborted
Date: Fri, 4 Jul 2014 15:45:59 +0200
Message-ID: <20140704154559.026331ec@archvile>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
	<20140701082619.1ac77f1d@archvile>
	<20140701084206.GG9743@birch.djwong.org>
	<CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
	<20140703134338.GE2374@thunk.org>
	<20140703161551.5fd13245@archvile>
	<87tx6yzdxz.fsf@openvz.org>
	<20140704114031.2915161a@archvile>
	<87r421zavi.fsf@openvz.org>
	<20140704132802.0d43b1fc@archvile>
	<20140704122022.GC10514@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from protonic.xs4all.nl ([83.163.252.89]:9597 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaGDNpw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 09:45:52 -0400
In-Reply-To: <20140704122022.GC10514@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted, Dmitry,

On Fri, 4 Jul 2014 08:20:22 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Fri, Jul 04, 2014 at 01:28:02PM +0200, David Jander wrote:
> > 
> > Here is the output I am getting... AFAICS no problems on the raw device. Is
> > this sufficient testing, Ted?
> 
> I'm not sure what theory Dmitry was trying to pursue when he requested
> that you run the fio test.  Dmitry?
> 
> 
> Please note that at this point there may be multiple causes with
> similar symptoms that are showing up.  So just because one person
> reports one set of data points, such as someone claiming they've seen
> this without a power drop to the storage device, that therefore all of
> the problems were caused by flaky I/O to the device.
> 
> Right now, there are multiple theories floating around --- and it may
> be that more than one of them are true (i.e., there may be multiple
> bugs here).  Some of the possibilities, which again, may not be
> mutually exclusive:
> 
> 1) Some kind of eMMC driver bug, which is possibly causing the CACHE
> FLUSH command not to be sent.

How can I investigate this? According to the fio tests I ran and the
explanation Dmitry gave, I conclude that incorrectly sending of CACHE-FLUSH
commands is the only thing left to be discarded on the eMMC driver front,
right?

> 2) Some kind of hardware problem involving flash translation layers
> not having durable transactions of their flash metadata across power
> failures.

That would be like blaming Micron (the eMMC part manufacturer) for faulty
firmware... could be, but how can we test this?

> 3) Some kind of ext4/jbd2 bug, recently introduced, where we are
> modifying some ext4 metadata (either the block allocation bitmap or
> block group summary statistics) outside of a valid transaction handle.

I think I have some more evidence to support this case:

Until previously, I did not run fsck EVER! I know that this is not a good idea
to do in a production environment, but I am only testing right now, and in
theory it should not be necessary, right?

What I did this time, was to run fsck.ext3 or fsck.ext4 (depending on FS
format of course) once every one or two power cycles.

So effectively, what I did amounts to this:

CASE 1: fsck on every power-cycle:

1.- Boot from clean filesystem
2.- Run the following command line:
$ cp -a /usr . & bonnie\+\+ -r 32 -u 100:100 & bonnie\+\+ -r 32 -u 102:102

3.- Hit CTRL+Z (to stop the second bonnie++ process)
4.- Execute "sync"
5.- While "sync" was running, cut off the power supply.
6.- Turn on power and boot from external medium
7.- Run fsck.ext3/4 on eMMC device
8.- Repeat

In this case, there was a minor difference for the fsck output of both
filesystems:

EXT4 was always something like this:

# fsck.ext4 /dev/mmcblk1p2
e2fsck 1.42.5 (29-Jul-2012)
rootfs: recovering journal
Setting free inodes count to 37692 (was 37695)
Setting free blocks count to 136285 (was 136291)
rootfs: clean, 7140/44832 files, 42915/179200 blocks

While for EXT3 the output did not contain the "Setting free * count..."
messages:

# fsck.ext3 -p /dev/mmcblk1p2
rootfs: recovering journal
rootfs: clean, 4895/44832 files, 36473/179200 blocks



CASE 2: fsck on every other power-cycle:

Same as CASE 1 steps 1...5 and then:
6.- Turn on power and boot again from dirty internal eMMC without running fsck.
7.- Repeat steps 2...5 one more time
8.- Perform steps 6...8 from CASE 1.

With this test, the following difference became apparent:

With EXT3: fsck.ext3 did the same as in CASE 1

With EXT4: I get a long list of errors that are being fixed.
It starts like this:


# fsck.ext4 /dev/mmcblk1p2
e2fsck 1.42.5 (29-Jul-2012)
rootfs: recovering journal
rootfs contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inode 4591, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4594, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4595, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4596, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4597, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4598, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4599, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4600, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4601, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4602, i_blocks is 16, should be 8.  Fix<y>? yes
Inode 4603, i_blocks is 16, should be 8.  Fix<y>? yes
...
...
Eventually I pressed CTRL+C and restarted fsck with the option "-p", because
this list was getting a little long.
...
...

# fsck.ext4 -p /dev/mmcblk1p2
rootfs contains a file system with errors, check forced.
rootfs: Inode 5391, i_blocks is 32, should be 16.  FIXED.
rootfs: Inode 5392, i_blocks is 16, should be 8.  FIXED.
rootfs: Inode 5393, i_blocks is 48, should be 24.  FIXED.
rootfs: Inode 5394, i_blocks is 32, should be 16.  FIXED.
rootfs: Inode 5395, i_blocks is 16, should be 8.  FIXED.
...
...
rootfs: Inode 5854, i_blocks is 240, should be 120.  FIXED.
rootfs: Inode 5857, i_blocks is 576, should be 288.  FIXED.
rootfs: Inode 5860, i_blocks is 512, should be 256.  FIXED.
rootfs: Inode 5863, i_blocks is 656, should be 328.  FIXED.
rootfs: Inode 5866, i_blocks is 480, should be 240.  FIXED.
rootfs: Inode 5869, i_blocks is 176, should be 88.  FIXED.
rootfs: Inode 5872, i_blocks is 336, should be 168.  FIXED.
rootfs: 11379/44832 files (0.1% non-contiguous), 70010/179200 blocks
#

> 4) Some other kind of hard-to-reproduce race or wild pointer which is
> sometimes corrupting fs data structures.

I don't have such a hard time reproducing it... but it does take quite some
time (booting several times, re-installing, testing, etc...)

> If someone has a easy to reproduce failure case, the first step is to
> do a very rough bisection test.  Does the easy-to-reproduce failure go
> away if you use 3.14?  3.12?  Also, if you can describe in great
> detail your hardware and software configuration, and under what
> circumstances the problem reproduces, and when it doesn't, that would
> also be critical.  Whether you are just doing reset or a power cycle
> if an unclean shutdown is involved, might also be important.

Until now, I always do a power-cycle, but I can try to check if I am able to
reproduce the problem with just a "shutdown -f" (AFAIK, this does NOT sync
filesystems, right?)

I will try to check 3.14 and 3.12 (if 3.14 still seems buggy). It could take
quite a while until I have results... certainly not before monday.

> And at this point, because I'm getting very suspicious that there may
> be more than one root cause, we should try to keep the debugging of
> one person's reproduction, such as David's, separate from another's,
> such as Matteo's.  It may be that there ultimately have the same root
> cause, and so if one person is able to get an interesting reproduction
> result, it would be great for the other person to try running the same
> experiment on their hardware/software configuration.  But what we must
> not do is assume that one person's experiment is automatically
> applicable to other circumstances.

I agree.

Best regards,

-- 
David Jander
Protonic Holland.
