From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 9 Mar 2012 23:48:04 -0500
Message-ID: <20120310044804.GB5652@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40038 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab2CJEsJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 23:48:09 -0500
Content-Disposition: inline
In-Reply-To: <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 09, 2012 at 04:09:43PM -0800, Andreas Dilger wrote:
> > I have also run the correlation.py from Phillip Susi on directory with
> > 100000 4k files and indeed the name to block correlation in ext4 is pretty
> > much random :)
> 
> Just reading this on the plane, so I can't find the exact reference
> that I want, but a solution to this problem with htree was discussed
> a few years ago between myself and Coly Li.
> 
> The basic idea is that for large directories the inode allocator
> starts by selecting a range of (relatively) free inodes based on the
> current directory size, and then piecewise maps the hash value for
> the filename into this inode range and uses that as the goal inode.

I've heard you sketch out this idea before, but it's not been clean to
me how well it would work in practice.  The potential downside is that
it fragments the inode table, such that a single inode table block
might not have as many inodes stored in it as we might otherwise
would.  (Ideally, with 256 byte inodes, there would 16 of them in each
4k block.)  This is something I'd definitely recommend modelling in
simulation to see how well it works first.

I'd observe that if we knew in advance how many files would be in a
particular directory (i.e., via a hint from userspace at mkdir time),
then it would be possible to optimize this case much more easily.  In
fact, if we had perfect knowledge --- if the userspace process could
feed us the exact set of filenames that will be used in the directory,
plus the exact file sizes for each of the file names --- then it would
be possible to allocate inode numbers and starting block numbers such
that when the files are read in readdir() order, the inode numbers and
block numbers would line up perfectly into sequential writes.  

Of course, the trade off is that by optimizing for read order, the
write order will tend to get painful as well!  So there's a tension
here; making the read part of the benchmark faster will make the
process of writing the directory hierarchy require more seeks --- and
this assuming that you know file names and sizes ahead of time.

(Unless, of course, you play the same game that Hans Reiser did when
he cooked his "tar" benchmark by constructing a kernel source tarball
where the file order in the tarball was perfectly ordered to guarantee
the desired result given Reiser4's hash!  :-)


I suspect the best optimization for now is probably something like
this:

1) Since the vast majority of directories are less than (say) 256k
(this would be a tunable value), for directories which are less than
this threshold size, the entire directory is sucked in after the first
readdir() after an opendir() or rewinddir().  The directory contents
are then sorted by inode number (or loaded into an rbtree ordered by
inode number), and returned back to userspace in the inode order via
readdir().  The directory contents will be released on a closedir() or
rewinddir().

2) For files larger than this size, we don't want to hold that much
kernel memory during an opendir(), so fall back to ext4's current
scheme.   

3) If we want do to better than that, we could create new flag
O_NOTELLDIR, which can be set via fcntl.  (This way programs can use
do something like "dir = opendir(..); fd = dirfd(dir); fcntl(fd,
SETFL, O_NOTELLDIR);").  For files who know they don't need to use
telldir/seekdir, they can set this flag, which will allow the above
optimization to be used on large files.


The other thing we could potentially do, if we really cared about this
issue in ext3/4, would be to define whole new (incompatible) storing
the directory indexing format which avoided this problem.  It would be
an INCOMPAT feature, so it would be a while before it could get used
in practice, which is why I'm not entirely convinced it's worth it ---
especially since I suspect just doing (1) would solve the problem for
the vast majority of ext4's users.


						- Ted
