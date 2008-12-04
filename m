From: Andreas Dilger <adilger@sun.com>
Subject: Re: Problems with checking corrupted large ext3 file system
Date: Wed, 03 Dec 2008 17:09:36 -0700
Message-ID: <20081204000936.GE3186@webber.adilger.int>
References: <20081203101100.GO17966@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38151 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318AbYLDAJx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2008 19:09:53 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mB409pfo020429
	for <linux-ext4@vger.kernel.org>; Wed, 3 Dec 2008 16:09:51 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KBB00L01S2XVN00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 03 Dec 2008 16:09:51 -0800 (PST)
In-reply-to: <20081203101100.GO17966@skl-net.de>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 03, 2008  11:11 +0100, Andre Noll wrote:
> I've some trouble checking a corrupted 9T large ext3 fs which resides
> on a logical volume. The underlying physical volumes are three hardware
> raid systems, one of which started to crash frequently. I was able
> to pvmove away the data from the buggy system, so everything is fine
> now on the hardware side.

A big question is what kernel you are running on.  Anything less than
2.6.18-rhel5 (not sure what vanilla kernel) has bugs with ext3 > 8TB.

The other question is whether there is any expectation that the data
moved from the bad RAID arrays was corrupted.

> However, the crashes left me with a seriously corrupted file system
> from which I'm trying to recover as much as possible. First step was
> to unmount the file system after users reported I/O errors when trying
> to open files. The system log contained many messages like
> 
> 	[102445.420125] EXT3-fs error (device dm-2): ext3_free_blocks_sb: bit already cleared for block 544108393                                              
> 
> and some of the form
> 
> 	[160301.277477] EXT3-fs error (device dm-2): htree_dirblock_to_tree: bad entry in directory #153542738: rec_len % 4 != 0 - offset=0, inode=1381653864, +rec_len=26709, name_len=79
> 
> So I compiled the master branch of the e2fsprogs git repo as of
> Dec 1 (tip: 8680b4) and executed
> 
> 	./e2fsck -y -C0 /dev/mapper/abel-abt6_projects
> 
> This ran for a while and then started to output a couple of these:
> 
> 	Inode table for group 68217 is not in group.  (block 825373744)
> 	WARNING: SEVERE DATA LOSS POSSIBLE.
> 
> along with many lines of the form
> 
> 	Illegal block #3036172 (4233778405) in inode 115335438.
>         CLEARED.

Running "e2fsck -y" vs. "e2fsck -p" will sometimes do "bad" things because
the "-y" forces it to continue on no matter what.  It looks like there
was some serious filesystem corruption beyond the 8TB boundary, and the
inode table for at one or more groups (depending on how many of the
"SEVERE DATA LOSS POSSIBLE" messages were printed) is completely lost.

> But then it continued just fine without printing further
> messsages. After about 4 hours it completed but decided to re-run from
> the beginning and this is where the real trouble seems to start. The
> next day I found thousands of lines like this on the console:
> 
>         /backup/data/solexa_analysis/ATH/MA/MA-30-29/run_30/4/length_42/reads_0.fl (inode #145326082, mod time Tue Jan 22 05:09:36 2008)
> followed by
> 
> 	Clone multiply-claimed blocks? yes

This is likely fallout from the original corruption above.  The bad news
is that these "multiply-claimed blocks" are really bogus because of the
garbage in the missing inode tables...  e2fsck has turned random garbage
into inodes, and it results in what you are seeing now.

> At this point the fsck seems to hang. No further messages, no progress
> bar for at least 17 hours.

The pass1b (clone multiply-claimed blocks) code is very slow, because it
involves an O(n^2) operation to find all of the duplicate blocks, read
them from disk, then write them to some new spot on disk, and the e2fsck
allocator is very slow also.

> The lights on the raid system aren't
> flashing but there seems to be a bit of I/O going on as stracing the
> e2fsck process yields
> 
> 	lseek(3, 6206310776832, SEEK_SET)       = 6206310776832
> 	read(3, "002107740635\tD\t2\t169\t35\t0\thhhhhh"..., 4096) = 4096
> 	lseek(3, 1263113973760, SEEK_SET)       = 1263113973760
> 	write(3, "B9K@=?4C=L-F77F4:CGGK\n3\t14221118"..., 4096) = 4096
> 	lseek(3, 5861641846784, SEEK_SET)       = 5861641846784
> 	read(3, "hhhhhh\tIIIIIIIIIIIIIIIIIIIIIIIII"..., 4096) = 4096
> 	lseek(3, 1263113977856, SEEK_SET)       = 1263113977856
> 	write(3, "\t1.00\t0.46\t19\t4\t2\t0\t1\tA\t33\t31\t0\t"..., 4096) = 4096
> 
> There's about only one read per second, so the fsck might take rather
> long if it continues to run at this speed ;)
> 
> It's running for 34 hours now and I don't know what to do, so here are
> a couple of questions for you ext3 gurus:
> 
> 	Is there any hope this will ever complete?

Depends on how many inodes are duplicated, but it could be days :-(.

> 	Should I abort the fsck and restart?

Restarting won't fix anything because it will just get you back to the
same spot 34h from now.

> 	Do things get even worse if I abort it and mount the file
> 	system r/o so that I can see whether important files are
> 	still there?

I would suggest as a starter to run "debugfs -c {devicename}" and
use this to explore the filesystem a bit.  This can be done while
e2fsck is running, and will give you an idea of what data is still
there.  If you think that a majority of your file data (or even just
the important bits) are available, then I would suggest killing e2fsck,
mounting the filesystem read-only, and copying as much as possible.

The kernel should be largely forgiving of errors it finds on disk.

> 	Are there any magic e2fsck command line options I should try?

One option is to use the Lustre e2fsprogs which has a patch that tries
to detect such "garbage" inodes and wipe them clean, instead of trying
to continue using them.

	http://downloads.lustre.org/public/tools/e2fsprogs/latest/

That said, it may be too late to help because the previous e2fsck run
will have done a lot of work to "clean up" the garbage inodes and they
may no longer be above the "bad inode threshold".

You could try this after copying the data elsewhere, to avoid the need
to restore the filesystem and get a bit more data back, but at that
point it might also be faster to just reformat and restore the data.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

