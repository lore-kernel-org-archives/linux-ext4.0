From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: Test generic/299 stalling forever
Date: Thu, 13 Oct 2016 16:08:37 +0300
Message-ID: <20161013130836.GA16445@yogzotot>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard>
 <20160929043722.ypf3tnxsl6ovt653@thunk.org>
 <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
 <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Cc: Jens Axboe <axboe@fb.com>, Dave Chinner <david@fromorbit.com>,
        linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
        tarasov@vasily.name
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 12, 2016 at 10:15:52PM -0400, Theodore Ts'o wrote:
> On Wed, Oct 12, 2016 at 03:19:25PM -0600, Jens Axboe wrote:
> > 
> > FWIW, this is the commit that fixes it:
> > 
> > commit 39d13e67ef1f4b327c68431f8daf033a03920117
> > Author: Jens Axboe <axboe@fb.com>
> > Date:   Fri Aug 26 14:39:30 2016 -0600
> > 
> >     backend: check if we need to update rusage stats, if stat_mutex is busy
> > 
> > 2.14 and newer should not have the problem, but earlier versions may
> > depending on how old...
> 
> Unfortunately, I'm still seeing hangs in generic/299 with the latest version of fio:
> 
> fio 	  fio-2.14-10-g0a301e9 (Fri, 23 Sep 2016 11:57:00 -0600)
> 
> If I use an older fio, it reliably does not hang.  What can I do to
> help debug this?
> 
> As I said, I can attach to the hanging fio using a gdb and give you
> stackdumps for all of the threads if that would be helpful.

I don't have git fio hangs on 299 (just a lot of "fallocate: No space left on
device" in results/generic/299.full):

# fio -v
fio-2.14-27-gafd2c
# mount tmpfs -t tmpfs -o size=26g /ramdisk/
# fallocate -l 12g /ramdisk/testvol1 && losetup -f /ramdisk/testvol1
# fallocate -l 12g /ramdisk/scratch0 && losetup -f /ramdisk/scratch0
root@ttip:/home/mator/xfstests-dev# cat local.config
export TEST_DEV=/dev/loop0
export TEST_DIR=/testvol
export SCRATCH_DEV_POOL="/dev/loop1"
#export SCRATCH_DEV_POOL="/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3"
export SCRATCH_MNT=/mnt/scratch

# mkfs.xfs -f /dev/loop0
meta-data=/dev/loop0             isize=512    agcount=4, agsize=786432 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0
data     =                       bsize=4096   blocks=3145728, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@ttip:/home/mator/xfstests-dev# ./check generic/299
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/sparc64 ttip 4.8.0+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
MOUNT_OPTIONS -- /dev/loop1 /mnt/scratch

generic/299      103s
Ran: generic/299
Passed all 1 tests

kernel logs:
$ journalctl -k -e
Oct 13 15:35:41 ttip unknown: run fstests generic/299 at 2016-10-13 15:35:41
Oct 13 15:35:41 ttip kernel: XFS (loop1): Unmounting Filesystem
Oct 13 15:35:42 ttip kernel: XFS (loop1): Mounting V5 Filesystem
Oct 13 15:35:42 ttip kernel: XFS (loop1): Ending clean mount
Oct 13 15:37:24 ttip kernel: XFS (loop1): Unmounting Filesystem
Oct 13 15:37:25 ttip kernel: XFS (loop0): Unmounting Filesystem


results/generic/299.full in attachment

--0OAP2g/MAC+5xKAE
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="299.full.gz"
Content-Transfer-Encoding: base64

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
vQAA

--0OAP2g/MAC+5xKAE--
