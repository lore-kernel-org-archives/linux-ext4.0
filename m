From: Bill Fink <billfink@mindspring.com>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 23:27:04 -0400
Message-ID: <20100830232704.39d2e9f4.billfink@mindspring.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>
	<20100830174000.GA6647@thunk.org>
	<20100830164958.edb64c63.bill@wizard.sci.gsfc.nasa.gov>
	<4C7C1D04.1080205@redhat.com>
	<20100830194533.6d09c38b.bill@wizard.sci.gsfc.nasa.gov>
	<4C7C446D.6070602@redhat.com>
	<20100830210541.8b248a14.billfink@mindspring.com>
	<4C7C62E9.4090707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, bill.fink@nasa.gov, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:38918 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678Ab0HaD1V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Aug 2010 23:27:21 -0400
In-Reply-To: <4C7C62E9.4090707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[adding linux-ext4 back in]

On Mon, 30 Aug, Eric Sandeen wrote:

> Bill Fink wrote:
> > On Mon, 30 Aug 2010, Eric Sandeen wrote:
> > 
> >> Bill Fink wrote:
> >>> On Mon, 30 Aug 2010, Eric Sandeen wrote:
> >>>
> >>>> Bill Fink wrote:
> >>>>> On Mon, 30 Aug 2010, Ted Ts'o wrote:
> >>>>>
> >>>>>> On Sun, Aug 29, 2010 at 11:11:26PM -0400, Bill Fink wrote:
> >>>>>>> A 50% ext4 disk write performance regression was introduced
> >>>>>>> in 2.6.32 and still exists in 2.6.35, although somewhat improved
> >>>>>>> from 2.6.32.  Read performance was not affected).
> >>>>>> Thanks for reporting it.  I'm going to have to take a closer look at
> >>>>>> why this makes a difference.  I'm going to guess though that what's
> >>>>>> going on is that we're posting writes in such a way that they're no
> >>>>>> longer aligned or ending at the end of a RAID5 stripe, causing a
> >>>>>> read-modify-write pass.  That would easily explain the write
> >>>>>> performance regression.
> >>>>> I'm not sure I understand.  How could calling or not calling
> >>>>> ext4_num_dirty_pages() (unpatched versus patched 2.6.35 kernel)
> >>>>> affect the write alignment?
> >>>>>
> >>>>> I was wondering if the locking being done in ext4_num_dirty_pages()
> >>>>> could somehow be affecting the performance.  I did notice from top
> >>>>> that in the patched 2.6.35 kernel, the I/O wait time was generally
> >>>>> in the 60-65% range, while in the unpatched 2.6.35 kernel, it was
> >>>>> at a higher 75-80% range.  However, I don't know if that's just a
> >>>>> result of the lower performance, or a possible clue to its cause.
> >>>> Using oprofile might also show you how much time is getting spent there..
> >>>>
> >>>>>> The interesting thing is that we don't actually do anything in
> >>>>>> ext4_da_writepages() to assure that we are making our writes are
> >>>>>> appropriate aligned and sized.  We do pay attention to make sure they
> >>>>>> are alligned correctly in the allocator, but _not_ in the writepages
> >>>>>> code.  So the fact that apparently things were well aligned in 2.6.32
> >>>>>> seems to be luck... (or maybe the writes are perfectly aligned in
> >>>>>> 2.6.32; they're just much worse with 2.6.35, and with explicit
> >>>>>> attention paid to the RAID stripe size, we could do even better :-)
> >>>>> It was 2.6.31 that was good.  The regression was in 2.6.32.  And again
> >>>>> how does the write alignment get modified simply by whether or not
> >>>>> ext4_num_dirty_pages() is called?
> >>>> writeback is full of deep mysteries ... :)
> >>>>
> >>>>>> If you could run blktraces on 2.6.32, 2.6.35 stock, and 2.6.35 with
> >>>>>> your patch, that would be really helpful to confirm my hypothesis.  Is
> >>>>>> that something that wouldn't be too much trouble?
> >>>>> I'd be glad to if you explain how one runs blktraces.
> >>>> Probably the easiest thing to do is to use seekwatcher to invoke blktrace,
> >>>> if it's easily available for your distro.  Then it's just mount debugfs on
> >>>> /sys/kernel/debug, and:
> >>>>
> >>>> # seekwatcher -d /dev/whatever -t tracename -o tracename.png -p "your dd command"
> >>>>
> >>>> It'll leave tracename.* blktrace files, and generate a graph of the IO
> >>>> in the PNG file.
> >>>>
> >>>> (this causes an abbreviated trace, but it's probably enough to see what
> >>>> boundaries the IO was issued on)
> >>> Thanks for the info.  How would you like me to send the blktraces?
> >>> Even using bzip2 they're 2.6 MB.  I could send them to you and Ted
> >>> via private e-mail or I can hunt around and try and find somewhere
> >>> I can post them.  I'm attaching the PNG files (2.6.35 is unpatched
> >>> and 2.6.35+ is patched).
> >> Private email is fine I think, I don't mind a 2.6MB attachment and doubt
> >> Ted would either.  :)
> > 
> > OK.  It's two such attachments (2.6.35 is unpatched and 2.6.35+
> > is patched).
> 
> (fwiw I had to create *.0 and *.1 files to make blktrace happy, it didn't
> like starting with *.2 ...?  oh well)

The .0 and .1 files were 0 bytes.  There was also a 56 byte .3 file
in each case.  Did you also want to see those?

> [sandeen@sandeen tmp]$ blkparse ext4dd-2.6.35-trace | tail -n 13
> CPU2 (ext4dd-2.6.35-trace):
>  Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
>  Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
>  Reads Requeued:         0		 Writes Requeued:         0
>  Reads Completed:      249,      996KiB	 Writes Completed:  270,621,   30,544MiB
>  Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
>  Read depth:             0        	 Write depth:             0
>  IO unplugs:             0        	 Timer unplugs:           0
> 
> Throughput (R/W): 13KiB/s / 409,788KiB/s
> Events (ext4dd-2.6.35-trace): 270,870 entries
> Skips: 0 forward (0 -   0.0%)
> Input file ext4dd-2.6.35-trace.blktrace.2 added
> 
> 
> [sandeen@sandeen tmp]$ blkparse ext4dd-2.6.35+-trace | tail -n 13
> CPU2 (ext4dd-2.6.35+-trace):
>  Reads Queued:           0,        0KiB	 Writes Queued:           0,        0KiB
>  Read Dispatches:        0,        0KiB	 Write Dispatches:        0,        0KiB
>  Reads Requeued:         0		 Writes Requeued:         0
>  Reads Completed:      504,    2,016KiB	 Writes Completed:  246,500,   30,610MiB
>  Read Merges:            0,        0KiB	 Write Merges:            0,        0KiB
>  Read depth:             0        	 Write depth:             0
>  IO unplugs:             0        	 Timer unplugs:           0
> 
> Throughput (R/W): 38KiB/s / 590,917KiB/s
> Events (ext4dd-2.6.35+-trace): 247,004 entries
> Skips: 0 forward (0 -   0.0%)
> Input file ext4dd-2.6.35+-trace.blktrace.2 added
> 
> 
> Ok not a -huge- difference in the overall stats, though the unpatched version did
> fdo 24,000 more writes, which is 10% ...
> 
> At the extremes in both cases there are 8-block and 256-block writes.
> 
> 2.6.35:
> 
>  nr wrt size
>   25256 8
>    1701 16
>    1646 24
>     297 248
> ...
>  232657 256
> 
> 
> 2.6.35+:
> 
>  nr wrt size
>    4785 8
>    1732 16
>     357 24
> ...
>      50 248
>  237907 256
> 
> So not a huge difference in the distribution really, though there were
> 20,000 more 1-block (8-sector) writes in the unpatched version.
> 
> So a lot of 32-block writes turned into 1-block writes and smaller, I guess.
> 
> To know for sure about alignment, what is your raid stripe unit, and is this
> filesystem on a partition?  If so at what offset?

Would the stripe unit be the Block size in the following?

[root@i7test7 linux-git]# hptrc -s1 query arrays
ID    Capacity(GB)    Type        Status   Block  Sector   Cache            Name
-------------------------------------------------------------------------------
1           500.00   RAID5        NORMAL    256k    512B      WB        RAID50_1
2           250.00   RAID5        NORMAL    256k    512B      WB       RAID500_1
3          2350.00   RAID5        NORMAL    256k    512B      WB         RAID5_1

The testing was done on the first 500 GB array.

And here's how the ext4 filesystem was created (using the
entire device):

[root@i7test7 linux-git]# mkfs.ext4 /dev/sde
mke2fs 1.41.10 (10-Feb-2009)
/dev/sde is entire device, not just one partition!
Proceed anyway? (y,n) y
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
30523392 inodes, 122070144 blocks
6103507 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
3726 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
	102400000

Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 25 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

						-Thanks

						-Bill



> -Eric
> 
> >> I keep meaning to patch seekwatcher to color unaligned IOs differently,
> >> but without that we need the blktrace data to know if that's what's going
> >> on.
> >>
> >> It's interesting that the patched run is starting at block 0 while
> >> unpatched is starting futher in (which would be a little slower at least)
> >>
> >> was there a fresh mkfs in between?
> > 
> > No mkfs in between, and the original mkfs.ext4 was done without
> > any special options.  I am using the noauto_da_alloc option on the
> > mount to workaround another 9% performance hit between 2.6.31 and
> > 2.6.32, introduced by 5534fb5bb35a62a94e0bd1fa2421f7fb6e894f10
> > (ext4: Fix the alloc on close after a truncate hueristic).  That
> > one only affected already existing files.
> > 
> >> Thanks!
> >>
> >> -Eric
