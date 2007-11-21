From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: dir inode reservation V3
Date: Tue, 20 Nov 2007 19:09:45 -0700
Message-ID: <20071121020945.GB8087@webber.adilger.int>
References: <4739B0C0.3060907@suse.de> <1195524061.4177.17.camel@localhost.localdomain> <47425F0B.3030604@suse.de> <1195590124.8471.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coyli@suse.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:56629 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbXKUCJs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2007 21:09:48 -0500
Content-Disposition: inline
In-Reply-To: <1195590124.8471.17.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 20, 2007  12:22 -0800, Mingming Cao wrote:
> On Tue, 2007-11-20 at 12:14 +0800, Coly Li wrote:
> > Mingming Cao wrote:
> > > On Tue, 2007-11-13 at 22:12 +0800, Coly Li wrote:
> > The hole is (s_dir_ireserve_nr - 1), not N * s_dir_ireserve_nr. Because
> > directory inode will also use a inode slot from reserved area, reset
> > slots number for files is (s_dir_ireserve_nr - 1).  Except for the
> > reserved inodes number, your understanding exactly matches my idea.
> 
> The performance gain on large number of directories looks interesting,
> but I am afraid this makes the uninitialized block group feature less
> useful (to speed up fsck) than before:( The reserved inode will cause
> the unused inode watermark higher than before, and spread the
> directories over to other block groups earlier than before. Maybe it
> worth it...not sure.

My original thoughts on the design for this were slightly different:
- that the per-directory reserved window would scale with the size of
  the directory, so that even (or especially) with htree directories the 
  inodes would be kept in hash-ordered sets to speed up stat/unlink
- it would be possible/desirable to re-use the existing block bitmap
  reservation code to handle inode bitmap reservation for directories
  while those directories are in-core.  We already have the mechanisms
  for this, "all" that would need to change is have the reservation code
  point at the inode bitmaps but I don't know how easy that is
- after an unmount/remount it would be desirable to re-use the same blocks
  for getting good hash->inode mappings, wherein lies the problem of
  compatibility

One possible solutions for the restart problem is searching the directory
leaf block in which an inode is being added for the inode numbers and try
to use those as a goal for the inode allocation...  Has a minor problem
with ordering, because usually the inode is allocated before the dirent
is created, but isn't impossible to fix (e.g. find dirent slot first,
keep a pointer to it, check for inode goals, and then fill in dirent
inum after allocating inode)

> > >> 5, Performance number
> > >> On a Core-Duo, 2MB DDM memory, 7200 RPM SATA PC, I built a 50GB ext4
> > >> partition, and tried to create 50000 directories, and create 15 (1KB)
> > >> files in each directory alternatively. After a remount, I tried to
> > >> remove all the directories and files recursively by a 'rm -rf'.
> > >> Below is the benchmark result,
> > >> 		normal ext4			ext4 with dir inode reservation
> > >> 	mount options:	-o data=writeback	-o data=writeback,dir_ireserve=low
> > >> 	Create dirs:	real    0m49.101s	real    2m59.703s
> > >> 	Create files:	real    24m17.962s	real    21m8.161s
> > >> 	Unlink all:	real    24m43.788s	real    17m29.862s

One likely reason that the create dirs step is slower is that this is
doing a lot more IO than in the past.  Only a single inode in each
inode table block is being used, so that means that a lot of empty
bytes are being read and written (maybe 16x as much data in this case).

Also, in what order are you creating files in the directories?  If you
are creating them in directory order like:

	for (f = 0; f < 15; f++)
		for (i = 0; i < 50000; i++)
			touch dir$i/f$f

then it is completely unsurprising that directory reservation is faster
at file create/unlink because those inodes are now contiguous at the
expense of having gaps in the inode sequence.  Creating 15 files per
directory is of course the optimum test case also.

How does this patch behave with benchmarks like dbench, mongo, postmark?

> It would be nice to remember the last allocated bit for each block
> group, so we don't have to start from bit 0 (in the worse case scan the
> entire block group) for every single directory. Probably this can be
> saved in the in-core block group descriptor.  Right now the in core
> block group descriptor structure is the same on-disk block-group
> structure though, it might worth to separate them and provide load/store
> helper functions.

Note that mballoc already creates an in-memory struct for each group.
I think the initialization of this should be moved outside of mballoc
so that it can be used for other purposes as you propose.

Eric had a benchmark where creating many files/subdirs would cause
a huge slowdown because of bitmap searching, and having a per-group
pointer with the first free inode (or last allocated inode might be
less work to track) would speed this up a lot. 

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
